"""Canonical Boolean netlist shared by independent CUPL and GHDL frontends.

Reduced ordered BDDs remove frontend gate factoring and product-term order.
A deterministic prime-implicant cover is emitted in the fitter's TT2 format.
No reference netlist, fuse file or source from the other language is consulted.
"""
import json
from pathlib import Path
import re


def natural(text):
    return tuple(int(s) if s.isdigit() else s for s in re.split(r'(\d+)', text.upper()))


class BDD:
    def __init__(self, variables):
        self.variables = variables
        self.index = {name: i for i, name in enumerate(variables)}
        self.nodes = [None, None]
        self.unique = {}
        self.memo = {}

    def node(self, variable, low, high):
        if low == high: return low
        key = (variable, low, high)
        if key not in self.unique:
            self.unique[key] = len(self.nodes)
            self.nodes.append(key)
        return self.unique[key]

    def variable(self, name):
        return self.node(self.index[name], 0, 1)

    def apply(self, op, a, b=0):
        if op == 'not': return self.apply('xor', a, 1)
        if a > b: a, b = b, a
        key = (op, a, b)
        if key in self.memo: return self.memo[key]
        if a < 2 and b < 2:
            return int({'and': bool(a and b), 'or': bool(a or b), 'xor': bool(a ^ b)}[op])
        va = self.nodes[a][0] if a > 1 else len(self.variables)
        vb = self.nodes[b][0] if b > 1 else len(self.variables)
        v = min(va, vb)
        al, ah = self.nodes[a][1:] if va == v else (a, a)
        bl, bh = self.nodes[b][1:] if vb == v else (b, b)
        result = self.node(v, self.apply(op, al, bl), self.apply(op, ah, bh))
        self.memo[key] = result
        return result

    def cube(self, values):
        result = 1
        for variable, value in reversed(sorted(values.items())):
            result = self.node(variable, 0 if value else result, result if value else 0)
        return result

    def paths(self, function, values=None):
        values = {} if values is None else values
        if function == 1:
            yield values
        elif function:
            variable, low, high = self.nodes[function]
            yield from self.paths(low, dict(values, **{str(variable): 0}))
            yield from self.paths(high, dict(values, **{str(variable): 1}))

    def cover(self, function):
        if function == 0: return []
        forbidden = self.apply('not', function)
        candidates = set()
        for path in self.paths(function):
            cube = {int(k): v for k, v in path.items()}
            # Expand each path to an implicant in a fixed variable order.
            for variable in sorted(cube):
                value = cube.pop(variable)
                if self.apply('and', self.cube(cube), forbidden): cube[variable] = value
            candidates.add(tuple(sorted(cube.items())))
        ordered = sorted(candidates, key=lambda c: (len(c), c))
        cover = []
        covered = 0
        for cube in ordered:
            term = self.cube(dict(cube))
            if self.apply('and', term, self.apply('not', covered)):
                cover.append(cube)
                covered = self.apply('or', covered, term)
        assert covered == function
        # Deterministically remove terms rendered redundant by later terms.
        for cube in list(reversed(cover)):
            others = 0
            for other in cover:
                if other != cube: others = self.apply('or', others, self.cube(dict(other)))
            if others == function: cover.remove(cube)
        return cover


def parse_tt2(path):
    inputs, outputs, cubes, pins, nodes = [], [], [], {}, []
    for line in path.read_text().splitlines():
        words = line.split()
        if line.startswith('#$ PINS '):
            for name, sign, number in re.findall(r'(\w+)([+-])(?::(\d+))?', line):
                pins[name] = {'pin': int(number) if number else None, 'invert': sign == '-'}
        elif line.startswith('#$ NODES '):
            nodes = re.findall(r'(\w+)[+-]', line)
        elif words and words[0] == '.ilb': inputs = words[1:]
        elif words and words[0] == '.ob': outputs = words[1:]
        elif words and words[0] == '.phase': assert set(words[1]) == {'1'}
        elif words and words[0] == '.type': assert words[1] == 'f'
        elif words and not words[0].startswith(('#', '.')):
            assert len(words) == 2 and len(words[0]) == len(inputs) and len(words[1]) == len(outputs)
            assert set(words[0]) <= set('01-') and set(words[1]) <= set('01')
            cubes.append(words)
    assert inputs and outputs and cubes and pins
    return inputs, outputs, cubes, pins, nodes


def schema(contract, registers):
    variables = list(contract['inputs']) + [p + '.PIN' for p in contract['inouts']]
    variables += [r + '.Q' for r in registers] + contract['soft_buffers']
    return BDD(sorted(set(variables), key=natural))


def from_cupl(path, contract):
    inputs, outputs, cubes, pins, nodes = parse_tt2(path)
    assert pins == contract['pins'], 'CUPL pin contract changed'
    registers = {name.split('.')[0] for name in outputs if name.endswith(('.REG', '.T'))}
    assert set(nodes) == registers - pins.keys() | set(contract['soft_buffers'])
    bdd = schema(contract, registers)
    functions = {}
    active = set()
    def input_function(name):
        if name.endswith('.PIN') and name[:-4] in contract['inputs']: name = name[:-4]
        if name in bdd.index: return bdd.variable(name)
        return function(name)
    def function(name):
        if name in functions: return functions[name]
        assert name not in active, f'Combinational loop at {name}'
        active.add(name)
        index = outputs.index(name)
        result = 0
        for pattern, mask in cubes:
            if mask[index] != '1': continue
            term = 1
            for signal, bit in zip(inputs, pattern):
                if bit == '-': continue
                value = input_function(signal)
                term = bdd.apply('and', term, value if bit == '1' else bdd.apply('not', value))
            result = bdd.apply('or', result, term)
        active.remove(name)
        functions[name] = result
        return result
    for name in outputs: function(name)
    return bdd, functions, sorted(nodes, key=natural)


def from_ghdl(path, design, contract):
    module = json.loads(path.read_text())['modules'][design]
    nets = {name.lower(): value['bits'] for name, value in module['netnames'].items()}
    ports, cells = module['ports'], module['cells']
    assert set(ports) == set(contract['pins'])
    assert {n for n, p in ports.items() if p['direction'] == 'input'} == set(contract['inputs'])
    assert {n for n, p in ports.items() if p['direction'] == 'inout'} == set(contract['inouts'])
    registers, drivers, tri = {}, {}, {}
    for name, cell in cells.items():
        if re.fullmatch(r'[DT]FF(?:E)?(?:AR|AS|ARS)?', cell['type']):
            assert name.endswith('_register')
            registers[name[:-len('_register')].upper()] = cell
        elif cell['type'] == '$tribuf':
            tri[cell['connections']['Y'][0]] = cell
        else:
            for port, direction in cell['port_directions'].items():
                if direction == 'output':
                    assert len(cell['connections'][port]) == 1
                    drivers[cell['connections'][port][0]] = cell
    bdd = schema(contract, registers)
    cuts = {ports[name]['bits'][0]: bdd.variable(name) for name in contract['inputs']}
    cuts.update({ports[name]['bits'][0]: bdd.variable(name + '.PIN') for name in contract['inouts']})
    cuts.update({cell['connections']['Q'][0]: bdd.variable(name + '.Q') for name, cell in registers.items()})
    cuts.update({nets[name.lower()][0]: bdd.variable(name) for name in contract['soft_buffers']})
    cache = {}
    def expand(bit):
        if isinstance(bit, str):
            assert bit in ('0', '1'), f'Undefined constant {bit}'
            return int(bit)
        cell = drivers[bit]
        typ, conn = cell['type'], cell['connections']
        assert typ in ('$and', '$or', '$xor', '$not'), f'Unsupported Boolean cell {typ}'
        args = [evaluate(conn[p][0]) for p in ('A', 'B') if p in conn]
        return bdd.apply(typ[1:], *args)
    def evaluate(bit):
        if bit in cuts: return cuts[bit]
        if bit not in cache: cache[bit] = expand(bit)
        return cache[bit]
    functions = {}
    for name, cell in registers.items():
        con = cell['connections']
        for pin, suffix in (('D', 'REG'), ('T', 'T'), ('CLK', 'C'), ('CE', 'CE'), ('AR', 'AR'), ('AS', 'AP')):
            if pin in con: functions[name + '.' + suffix] = evaluate(con[pin][0])
        if name in ports:
            # Assert correct physical pin polarity without consulting CUPL.
            actual = evaluate(ports[name]['bits'][0])
            expected = bdd.variable(name + '.Q')
            if contract['pins'][name]['invert']: expected = bdd.apply('not', expected)
            assert actual == expected, f'Wrong registered pin polarity: {name}'
    for name, port in ports.items():
        if port['direction'] == 'input' or name in registers: continue
        if port['direction'] == 'inout':
            cell = tri[port['bits'][0]]
            functions[name] = evaluate(cell['connections']['A'][0])
            functions[name + '.OE'] = evaluate(cell['connections']['EN'][0])
        else: functions[name] = evaluate(port['bits'][0])
    for name in contract['soft_buffers']: functions[name] = expand(nets[name.lower()][0])
    nodes = sorted(registers.keys() - ports.keys() | set(contract['soft_buffers']), key=natural)
    return bdd, functions, nodes


def emit(path, design, contract, bdd, functions, nodes):
    outputs = sorted(functions, key=natural)
    covers = {name: bdd.cover(functions[name]) for name in outputs}
    used = sorted({index for cover in covers.values() for cube in cover for index, value in cube})
    inputs = [bdd.variables[index] for index in used]
    rows = {}
    for column, name in enumerate(outputs):
        for cube in covers[name]:
            bits = dict(cube)
            pattern = ''.join(str(bits[index]) if index in bits else '-' for index in used)
            rows.setdefault(pattern, ['0'] * len(outputs))[column] = '1'
    part = re.search(r'\d+', contract['device']).group()
    lines = ['#$ TOOL CUPL', '# Canonical Boolean TT2; independent CUPL/GHDL frontends.',
             '#$ TITLE ' + design, '#$ MODULE ' + design[:8], '#$ JEDECFILE ' + design[:8],
             '#$ DEVICE f' + part + 'isp' + contract['package'].lower(),
             '#$ PROPERTY ATMEL Cascade_logic ON', '#$ PROPERTY ATMEL Preassign KEEP']
    if contract['soft_buffers']: lines += ['#$ PROPERTY ATMEL SOFT_BUFFER = ' + ', '.join(sorted(contract['soft_buffers'], key=natural))]
    pins = [name + ('-' if item['invert'] else '+') + (':' + str(item['pin']) if item['pin'] else '') for name, item in sorted(contract['pins'].items(), key=lambda pair: natural(pair[0]))]
    lines += ['#$ PINS ' + str(len(pins)) + ' ' + ' '.join(pins),
              '#$ NODES ' + str(len(nodes)) + ' ' + ' '.join(name + '+' for name in nodes),
              '.i ' + str(len(inputs)), '.o ' + str(len(outputs)), '.type f',
              '.ilb ' + ' '.join(inputs), '.ob ' + ' '.join(outputs), '.phase ' + '1' * len(outputs), '.p ' + str(len(rows))]
    lines += [pattern + ' ' + ''.join(rows[pattern]) for pattern in sorted(rows)]
    lines += ['.e', '']
    path.write_text('\n'.join(lines))
    return {'variables': len(inputs), 'functions': len(outputs), 'product_terms': len(rows), 'bdd_nodes': len(bdd.nodes)}
