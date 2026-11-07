#!/usr/bin/env python3
"""Prove VHDL register-input/control equations against CUPL's TT2 PLA with SAT.

This checks the GHDL-elaborated VHDL, not a second reading of the translation.
Each native macrocell Q is a symbolic state input. Matching all D/T, clock,
enable, preset/reset, OE and combinational outputs establishes the same Boolean
state transition relation (with corresponding states), for arbitrary inputs.
It does not prove physical timing or fuse-map identity.
"""
import argparse
import json
from pathlib import Path
import re
import subprocess


def load_pla(path):
    inputs, outputs, cubes = [], [], []
    for line in path.read_text().splitlines():
        words = line.split()
        if not words or words[0].startswith('#'):
            continue
        if words[0] == '.ilb': inputs = words[1:]
        elif words[0] == '.ob': outputs = words[1:]
        elif words[0] == '.phase':
            assert set(words[1]) == {'1'}, 'Only positive TT2 output phase is supported'
        elif words[0] == '.type': assert words[1] == 'f'
        elif not words[0].startswith('.'):
            assert len(words) == 2 and len(words[0]) == len(inputs) and len(words[1]) == len(outputs)
            assert set(words[0]) <= set('01-') and set(words[1]) <= set('01')
            cubes.append(words)
    assert inputs and outputs and cubes
    return inputs, outputs, cubes


def prove(design, directory, source_root):
    work = directory / design
    work.mkdir(parents=True, exist_ok=True)
    source = source_root / (design + '.vhdl')
    reference = Path('build/cupl') / design / (design + '.frontend.tt2')
    # These project basenames contain no Yosys/GHDL quoting metacharacters.
    script = (f'read_liberty -lib /atf15xx_yosys/cells.lib; '
              f'ghdl --std=08 {source} -e {design}; hierarchy -top {design}; '
              f'write_json {work}/actual.json')
    with (work / 'elaborate.log').open('w') as log:
        subprocess.run(['yosys', '-m', 'ghdl', '-p', script], check=True, stdout=log, stderr=subprocess.STDOUT)
    actual = json.loads((work / 'actual.json').read_text())['modules'][design]
    inputs, outputs, cubes = load_pla(reference)
    cells = actual['cells']
    nets = {name.lower(): value['bits'] for name, value in actual['netnames'].items()}
    ports = actual['ports']
    registers = {}
    tri = {}
    removed = []
    for label, cell in cells.items():
        typ = cell['type']
        if re.fullmatch(r'[DT]FF(?:E)?(?:AR|AS|ARS)?', typ):
            assert label.endswith('_register'), label
            registers[label[:-len('_register')].upper()] = cell
            removed.append(label)
        elif typ == '$tribuf':
            assert len(cell['connections']['Y']) == 1
            tri[cell['connections']['Y'][0]] = cell
            removed.append(label)
    assert registers, 'No explicit native register primitives found'
    for label in removed: del cells[label]
    # Keep original input/inout ports; register outputs become state cutpoints.
    actual['ports'] = {name: dict(data, direction='input') for name, data in ports.items() if data['direction'] in ('input', 'inout')}
    for name, cell in registers.items():
        assert len(cell['connections']['Q']) == 1
        actual['ports']['state_' + name] = {'direction': 'input', 'bits': cell['connections']['Q']}

    def wire(name):
        if name.endswith('.Q'):
            return registers[name[:-2]]['connections']['Q'][0]
        if name.endswith('.PIN'): name = name[:-4]
        if name.lower() == 'intq' and design.endswith('MAIN'): name = 'intq_ff'
        assert name.lower() in nets, f'Missing VHDL net: {name}'
        assert len(nets[name.lower()]) == 1, name
        return nets[name.lower()][0]

    def actual_output(label):
        if '.' in label:
            name, field = label.split('.')
            if field == 'OE':
                return tri[ports[name]['bits'][0]]['connections']['EN'][0]
            assert name in registers, f'Missing VHDL register: {name}'
            cell = registers[name]
            pin = {'REG': 'D', 'T': 'T', 'C': 'CLK', 'CE': 'CE', 'AR': 'AR', 'AP': 'AS'}[field]
            assert pin in cell['connections'], f'{name} missing native {pin}'
            assert ('T' in cell['connections']) == (name + '.T' in outputs), f'Wrong register kind: {name}'
            return cell['connections'][pin][0]
        bit = ports[label]['bits'][0] if label in ports else wire(label)
        if bit in tri: return tri[bit]['connections']['A'][0]
        return bit

    bits = [wire(name) for name in inputs]
    next_bit = max(bit for net in actual['netnames'].values() for bit in net['bits'] if isinstance(bit, int)) + 1
    cache = {}
    def gate(kind, *args):
        nonlocal next_bit
        if kind in ('$and', '$or'):
            args = tuple(sorted(args, key=str))
        key = (kind,) + args
        if key in cache: return cache[key]
        bit = next_bit
        next_bit += 1
        params = {'A_SIGNED': '0', 'A_WIDTH': '1', 'Y_WIDTH': '1'}
        connections = {'A': [args[0]], 'Y': [bit]}
        directions = {'A': 'input', 'Y': 'output'}
        if len(args) == 2:
            params.update(B_SIGNED='0', B_WIDTH='1')
            connections['B'] = [args[1]]
            directions['B'] = 'input'
        cells['proof_' + str(bit)] = {'hide_name': 1, 'type': kind, 'parameters': params, 'attributes': {}, 'port_directions': directions, 'connections': connections}
        cache[key] = bit
        return bit
    expected = ['0'] * len(outputs)
    for pattern, mask in cubes:
        term = '1'
        for bit, value in zip(bits, pattern):
            if value == '-': continue
            term = gate('$and', term, bit if value == '1' else gate('$not', bit))
        for index, value in enumerate(mask):
            if value == '1': expected[index] = gate('$or', expected[index], term)
    mismatch = '0'
    for label, golden in zip(outputs, expected):
        difference = gate('$xor', actual_output(label), golden)
        mismatch = gate('$or', mismatch, difference)
        actual['ports']['check_' + label.replace('.', '_')] = {'direction': 'output', 'bits': [difference]}
    # Also prove the physical polarity of every register-backed output pin.
    tt2 = reference.read_text()
    pins_line = next(line for line in tt2.splitlines() if line.startswith('#$ PINS '))
    polarity_checks = 0
    for name, polarity in re.findall(r'(\w+)([+-]):\d+', pins_line):
        if name not in registers: continue
        golden = registers[name]['connections']['Q'][0]
        if polarity == '-': golden = gate('$not', golden)
        mismatch = gate('$or', mismatch, gate('$xor', ports[name]['bits'][0], golden))
        polarity_checks += 1
    actual['ports']['mismatch'] = {'direction': 'output', 'bits': [mismatch]}
    (work / 'miter.json').write_text(json.dumps({'modules': {'miter': actual}}))
    with (work / 'proof.log').open('w') as log:
        subprocess.run(['yosys', '-p', f'read_json {work}/miter.json; hierarchy -top miter; opt_clean; check -assert; sat -verify -prove mismatch 0 -show-inputs -show-outputs'], check=True, stdout=log, stderr=subprocess.STDOUT)
    result = {'design': design, 'registers': len(registers), 'equations_proved': len(outputs), 'registered_pin_polarities_proved': polarity_checks, 'result': 'PASS', 'scope': 'All Boolean inputs and corresponding arbitrary register states; macrocell D/T/CLK/CE/AR/AS controls, combinational data and output enables. Physical timing, power-up behavior, analogue effects and post-fit equivalence are outside this check.'}
    (work / 'result.json').write_text(json.dumps(result, indent=2) + '\n')
    print(json.dumps(result), flush=True)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('design', nargs='*', default=['QBUSEMUMAIN', 'QBUSEMUDMA'])
    parser.add_argument('--output', type=Path, default=Path('build/equivalence'))
    parser.add_argument('--source-root', type=Path, default=Path('.'))
    args = parser.parse_args()
    for design in args.design:
        assert design in ('QBUSEMUMAIN', 'QBUSEMUDMA')
        prove(design, args.output, args.source_root)
