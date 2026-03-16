import subprocess
import os

def run_sim(ip_name, vector, width):
    cmd_compile = f"verilator --cc lib/{ip_name}/rtl/{ip_name}.v --exe cpp/sim_main.cpp -DBITWIDTH={width}"
    subprocess.run(cmd_compile, shell=True)

    with open("sim_input.mem","w") as f:
        f.write(f"{vector['a']} {vector['b']} {vector['cin']}\n")

    subprocess.run("./sim.out", shell=True)

    with open("sim_output.mem","r") as f:
        rtl_sum = int(f.readline())
    return rtl_sum