from test_modules.adder_test import test_adder

if __name__ == "__main__":
    widths = [4, 8, 16, 32]
    for w in widths:
        print(f"Testing adder with width={w}")
        test_adder(w, num_tests=1000)