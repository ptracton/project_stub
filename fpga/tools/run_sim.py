#! /usr/bin/env python3

"""
run_sim.py

Run FPGA simulations via Icarus, NCVerilog, Modelsim or Isim.

"""

import json
import os
import shlex
import subprocess
import sys
import argparse
import string


def which(program):
    """
    Find the path to an executable program
    """

    def is_exe(fpath):
        """
        Return True is the fpath exists and is executable.  This is needed since the
        executables are specifed in the JSON files, but not the path to them.  The
        executables may be in different locations based on which PC is running this.
        """
        return os.path.isfile(fpath) and os.access(fpath, os.X_OK)

    fpath, fname = os.path.split(program)
    if fpath:
        if is_exe(program):
            return program
    else:
        for path in os.environ["PATH"].split(os.pathsep):
            path = path.strip('"')
            exe_file = os.path.join(path, program)
            if is_exe(exe_file):
                return exe_file

    return None


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description='Run FPGA Simulation')
    parser.add_argument("-D", "--debug",
                        help="Debug this script",
                        action="store_true")
    parser.add_argument("--icarus",
                        help="Use Icarus Verilog",
                        action="store_true")
    parser.add_argument("--xcelium",
                        help="Use Xcelium",
                        action="store_true")

    parser.add_argument("--xcelium_gate",
                        help="Use Xcelium",
                        action="store_true")

    parser.add_argument("--xcelium_synthesis",
                        help="Use Xcelium",
                        action="store_true")

    parser.add_argument("--corner",
                        help="Fast or Slow",
                        default="RTL",
                        action="store")

    parser.add_argument("--modelsim",
                        help="Use Altera Modelsim",
                        action="store_true")
    parser.add_argument("--vivado",
                        help="Use Xilinx Vivado XSim",
                        action="store_true")
    parser.add_argument("--simulation",
                        help="Which simulation test case to run",
                        required=True,
                        action="store")

    print(os.environ['PATH'])
    args = parser.parse_args()
    if args.debug:
        print(args)

    if args.icarus:
        json_file = "../configurations/simulate_iverilog.json"
        tool = "icarus"
    if args.xcelium:
        json_file = "../configurations/simulate_xcelium.json"
        tool = "xcelium"
    if args.xcelium_gate:
        json_file = "../configurations/simulate_xcelium_gate.json"
        tool = "xcelium"
    if args.xcelium_synthesis:
        json_file = "../configurations/simulate_xcelium_synthesis.json"
        tool = "xcelium"
    if args.modelsim:
        json_file = "../configurations/simulate_modelsim.json"
        tool = "modelsim"
    if args.vivado:
        json_file = "../configurations/simulate_vivado.json"
        tool = "vivado"

    try:
        f = open(json_file, "r")
        json_data = json.load(f)
    except:
        print("Failed to open %s" % (json_file))
        sys.exit(-1)

    flow_steps = json_data['flow_steps']
    print(flow_steps)

    for step in sorted(flow_steps.keys()):
        print("Running Step: %s " % step)
        executable = json_data['flow'][flow_steps[step]]['executable']
        arguments = string.Template(
            json_data['flow'][flow_steps[step]]['arguments'])
        arguments_str = arguments.safe_substitute(
            simulation=args.simulation, corner=args.corner, tool=tool)
        #executable = which(executable)
        print(executable)
        if (arguments == None):
            command = executable
        else:
            command = executable + " " + arguments_str

        print(command)
        command = shlex.split(command)
        p = subprocess.Popen(command)
        p.communicate()
