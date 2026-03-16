import random
from utils.sim_runner import run_sim

def gen_adder_test(width, num_tests):
    for _ in range(num_tests):
        a = random.randint(0, 2**width-1)
        b = random.randint(0, 2**width-1)
        cin = random.randint(0,1)
        sum_expected = a + b + cin
        yield {"a": a, "b": b, "cin": cin, "expected": sum_expected}

def test_adder(width, num_tests=1000):
    for vec in gen_adder_test(width, num_tests):
        rtl_sum = run_sim("adder", vec, width)
        if rtl_sum != vec["expected"]:
            print(f"FAIL: width={width}, {vec}")
        else:
            print(f"PASS: width={width}, a={vec['a']}, b={vec['b']}, cin={vec['cin']}")