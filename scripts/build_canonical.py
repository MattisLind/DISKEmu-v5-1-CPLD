#!/usr/bin/env python3
"""Compile one source language independently, normalize Boolean logic and fit."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tempfile
from canonical_netlist import from_cupl, from_ghdl, emit


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('flow', choices=('cupl', 'vhdl'))
    parser.add_argument('design', choices=('QBUSEMUMAIN', 'QBUSEMUDMA'))
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    contract_path = Path('qbus-pinout.json')
    contract = json.loads(contract_path.read_text())[args.design]
    source = Path(args.design + ('.PLD' if args.flow == 'cupl' else '.vhdl'))
    out = args.output.resolve() / args.design
    out.mkdir(parents=True, exist_ok=True)
    for suffix in ('.jed', '.build.json', '.frontend.json'):
        (out / (args.design + suffix)).unlink(missing_ok=True)
    with tempfile.TemporaryDirectory(prefix='diskemu-frontend-') as temp:
        work = Path(temp)
        local = work / source.name
        shutil.copyfile(source, local)
        if args.flow == 'cupl':
            text = local.read_text()
            local.write_text(re.sub(r'(^\s*Name\s+)\w+(\s*;)', rf'\g<1>{args.design}\2', text, count=1, flags=re.M | re.I))
            env = os.environ.copy()
            env['LIBCUPL'] = subprocess.check_output(['winepath', '-w', '/opt/cupl/Atmel.dl'], text=True).strip()
            part = re.search(r'\d+', contract['device']).group()
            device = 'f' + part + 'isp' + contract['package'].lower()
            command = ['wine', '/opt/cupl/cupl.exe', '-a', '-l', '-e', '-x', '-f', '-b', '-m2', '-n', device, source.name]
            print('+ ' + ' '.join(command), flush=True)
            process = subprocess.run(command, cwd=work, env=env, text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
            print(process.stdout, flush=True)
            (out / (args.design + '.cupl.log')).write_text(process.stdout)
            for path in work.iterdir():
                if path.name != source.name:
                    shutil.copyfile(path, out / (args.design + '.frontend' + path.suffix))
            process.check_returncode()
            assert re.search(r'Error Code\s*=\s*0\b', process.stdout)
            bdd, functions, nodes = from_cupl(work / (args.design + '.tt2'), contract)
        else:
            # Hardware constraints are shared, but logic is derived solely from VHDL.
            fixed = {name: int(pin) for name, pin in re.findall(r'^--PIN:\s*(\w+)\s*:\s*(\d+)\s*$', local.read_text(), re.M)}
            assert fixed == {name: item['pin'] for name, item in contract['pins'].items() if item['pin'] is not None}
            auto = set(re.findall(r'^--AUTO-PIN:\s*(\w+)\s*$', local.read_text(), re.M))
            assert auto == {name for name, item in contract['pins'].items() if item['pin'] is None}
            command = ['yosys', '-m', 'ghdl', '-p',
                       f'read_liberty -lib /atf15xx_yosys/cells.lib; ghdl --std=08 {local.name} -e {args.design}; hierarchy -top {args.design}; write_json actual.json']
            with (out / (args.design + '.ghdl.log')).open('w') as log:
                subprocess.run(command, cwd=work, check=True, stdout=log, stderr=subprocess.STDOUT)
            shutil.copyfile(work / 'actual.json', out / (args.design + '.rtl.json'))
            bdd, functions, nodes = from_ghdl(work / 'actual.json', args.design, contract)
        canonical = out / (args.design + '.tt2')
        stats = emit(canonical, args.design, contract, bdd, functions, nodes)
        # Ensure the serialized TT2 is also a stable canonical form.
        bdd2, functions2, nodes2 = from_cupl(canonical, contract)
        second = work / 'roundtrip.tt2'
        emit(second, args.design, contract, bdd2, functions2, nodes2)
        assert canonical.read_bytes() == second.read_bytes()
        metadata = dict(stats, flow=args.flow, source=source.name, source_sha256=digest(source),
                        contract_sha256=digest(contract_path), canonical_tt2_sha256=digest(canonical))
        print(f'{args.design} {args.flow}: canonical TT2 {metadata["canonical_tt2_sha256"]}', flush=True)
        subprocess.run(['python3', '/opt/atf15xx/toolchain.py', 'tt2', str(canonical),
                        '-d', contract['device'], '-p', contract['package'], '-s', str(contract['speed_ns']), '-o', str(out)], check=True)
        (out / (args.design + '.frontend.json')).write_text(json.dumps(metadata, indent=2) + '\n')


if __name__ == '__main__':
    main()
