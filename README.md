```
rtl_lab/
│
├─ primitives/          # building blocks nhỏ
│   ├─ mux/
│   │    mux.v
│   └─ synchronizer/
│        sync.v
│
├─ lib/                 # reusable RTL modules
│   ├─ fifo/
│   │    rtl/fifo.v
│   │    tb/fifo_tb.v
│   │    doc/README.md
│   ├─ uart/
│   │    rtl/uart.v
│   │    tb/uart_tb.v
│   │    doc/README.md
│   └─ arbiter/
│        rtl/arbiter.v
│        tb/arbiter_tb.v
│        doc/README.md
│
├─ systems/             # integration / mini SoC
│   ├─ simple_cpu/
│   │    rtl/cpu.v
│   │    tb/cpu_tb.v
│   └─ simple_soc/
│        rtl/soc_top.v
│        tb/soc_tb.v
│
├─ sim/                 # simulation artifacts
│   ├─ verilator_build/
│   └─ waveform/
│
├─ cpp/                 # C++ simulation harness
│   ├─ sim_main.cpp
│   ├─ memory_model.cpp
│   └─ peripheral_model.cpp
│
├─ python/              # test runner + automation
│   ├─ run_test.py
│   └─ regression.py
│
├─ tests/
│   ├─ unit/
│   ├─ integration/
│   └─ system/
│
└─ software/            # firmware / OS
    ├─ baremetal/
    └─ linux/
```

# RTL Lab Personal Framework

## 1. Kiến trúc tổng thể

```
PRIMITIVES → IP LIBRARY → SYSTEM → C++ SIMULATION → PYTHON TEST LAB
```

| Layer           | Vai trò                                                      | Tương tác                                                                               |
| --------------- | ------------------------------------------------------------ | --------------------------------------------------------------------------------------- |
| PRIMITIVES      | Các building block cơ bản: mux, reg, flip-flop, synchronizer | Bắt đầu với block nhỏ như adder, comparator, shift register                             |
| IP LIBRARY      | Module hoàn chỉnh tái sử dụng: fifo, arbiter, uart           | Đóng gói block adder, reuse cho nhiều module khác                                       |
| SYSTEM          | Hệ thống tích hợp: CPU core, mini-SoC                        | Ráp các IP thành system-level design                                                    |
| C++ SIMULATION  | Verilator compile RTL thành C++ executable                   | Test system-level hoặc multi-IP integration                                             |
| PYTHON TEST LAB | Test runner, automation, regression                          | Viết test stimulus cho adder, chạy nhiều test case, collect waveform & report pass/fail |

---

## 2. Thư mục gợi ý

```
rtl_lab/
├─ primitives/
├─ lib/
├─ systems/
├─ sim/
│   ├─ logs/
│   └─ waveform/
├─ cpp/
├─ python/
│   ├─ run_test.py
│   ├─ regression.py
│   ├─ test_modules/
│   └─ utils/
└─ software/
```

* `primitives/`: building blocks nhỏ (mux, synchronizer, adder)
* `lib/`: reusable RTL modules với tb và doc
* `systems/`: tích hợp mini CPU, SoC
* `sim/`: simulation artifacts, waveform, logs
* `cpp/`: C++ simulation harness
* `python/`: test runner và automation scripts
* `software/`: firmware hoặc Linux cho RTL system

---

## 3. Simulation Harness (C++)

`cpp/sim_main.cpp`:

```cpp
#include "Vtop.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

int main(int argc, char **argv) {
    Verilated::commandArgs(argc, argv);
    Vtop* top = new Vtop;
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("waveform/dump.vcd");

    int cycles = 0;
    while (!Verilated::gotFinish() && cycles < 1000) {
        top->clk = 0; top->eval();
        top->clk = 1; top->eval();
        cycles++;
    }

    tfp->close();
    delete top;
    return 0;
}
```

---

## 4. Python Test Lab

### 4.1 Thư mục Python

```
python/
├─ run_test.py
├─ regression.py
├─ test_modules/
│   ├─ adder_test.py
│   ├─ fifo_test.py
│   └─ arbiter_test.py
└─ utils/
    ├─ sim_runner.py
    └─ waveform.py
```

### 4.2 Ví dụ `adder_test.py`

```python
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
```

### 4.3 `sim_runner.py`

```python
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
```

### 4.4 `run_test.py`

```python
from test_modules.adder_test import test_adder

if __name__ == "__main__":
    widths = [4, 8, 16, 32]
    for w in widths:
        print(f"Testing adder with width={w}")
        test_adder(w, num_tests=1000)
```

---

## 5. Lưu log và waveform

### 5.1 Thư mục gợi ý

```
sim/
├─ logs/
│   ├─ adder/width4_run1.log
│   ├─ adder/width8_run1.log
│   └─ ...
└─ waveform/
    ├─ adder/width4_run1.vcd
    ├─ adder/width8_run1.vcd
    └─ ...
```

### 5.2 Lưu log

```python
import os
from datetime import datetime

LOG_DIR = "sim/logs/adder"

def log_result(width, run_id, vector, rtl_sum, expected):
    os.makedirs(LOG_DIR, exist_ok=True)
    logfile = os.path.join(LOG_DIR, f"width{width}_run{run_id}.log")
    with open(logfile, "a") as f:
        f.write(f"{datetime.now()} | a={vector['a']} b={vector['b']} cin={vector['cin']} | RTL={rtl_sum} | EXPECT={expected}\n")
```

### 5.3 Lưu waveform (C++ harness / Verilator)

```cpp
#include "verilated_vcd_c.h"
VerilatedVcdC* tfp = new VerilatedVcdC;
top->trace(tfp, 99);
tfp->open("sim/waveform/adder/width4_run1.vcd");
...
tfp->close();
```

* Python có thể scan `sim/waveform/adder/` để mở waveform tự động

---

## 6. Workflow từ adder → system → regression

1. Viết RTL parametric adder: `rtl/adder.v`
2. Viết Verilog TB (unit test nhỏ)
3. Viết Python generator + checker cho nhiều width
4. Python gọi Verilator/C++ harness, chạy simulation
5. Python log kết quả + lưu waveform
6. Khi scale lên ALU/CPU: Python vẫn generate input, call harness, check output, tổng hợp regression report

---

## 7. Tóm tắt tư duy

* **Verilog TB:** test unit nhỏ, debug trực quan
* **Python Test Lab:** generate vector, run sim, check output, regression
* **C++ harness:** system-level, multi-IP, fast simulation
* **Logs:** lưu input/output/pass/fail
* **Waveform:** lưu tín hiệu theo thời gian để debug
* **Scalability:** test adder 4 → 32 → 64 bit, ALU, CPU, SoC

---

## 8. Nguyên tắc mở rộng

* Tên file/folder theo IP + width + run
* Mỗi IP module có test module Python riêng trong `test_modules/`
* C++ harness + Python driver cho system-level simulation
* Regression scan toàn bộ logs + waveform, tổng hợp báo cáo

---

## 9. Vị trí và ví dụ các file Testbench Verilog và C++ Harness

### 9.1 Vị trí Verilog Testbench

Verilog testbench thường nằm **gần RTL module** để dễ debug và maintain.

```
lib/
├─ adder/
│   ├─ rtl/
│   │   └─ adder.v
│   ├─ tb/
│   │   └─ adder_tb.v
│   └─ doc/
│       └─ README.md
```

Nguyên tắc:

* `rtl/` → RTL design
* `tb/` → unit testbench
* `doc/` → mô tả module

### 9.2 Ví dụ Verilog Testbench cho Adder

`lib/adder/tb/adder_tb.v`

```verilog
`timescale 1ns/1ps

module adder_tb;

reg [7:0] a;
reg [7:0] b;
reg cin;
wire [8:0] sum;

adder #(.WIDTH(8)) dut (
    .a(a),
    .b(b),
    .cin(cin),
    .sum(sum)
);

initial begin

    $dumpfile("sim/waveform/adder/adder_tb.vcd");
    $dumpvars(0, adder_tb);

    a = 0; b = 0; cin = 0; #10;
    a = 3; b = 5; cin = 0; #10;
    a = 10; b = 20; cin = 1; #10;

    $finish;
end

endmodule
```

Testbench này dùng để:

* debug logic nhanh
* xem waveform
* test corner case nhỏ

---

### 9.3 Vị trí C++ Simulation Harness

C++ harness thường đặt ở **level project**, vì nó chạy cho nhiều module hoặc system.

```
rtl_lab/
├─ cpp/
│   ├─ sim_main.cpp
│   ├─ memory_model.cpp
│   └─ device_model.cpp
```

Vai trò:

* tạo clock
* quản lý reset
* mô phỏng memory
* ghi waveform

---

### 9.4 Ví dụ C++ Harness đơn giản

`cpp/sim_main.cpp`

```cpp
#include "Vadder.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

int main(int argc, char **argv) {

    Verilated::commandArgs(argc, argv);

    Vadder* top = new Vadder;

    VerilatedVcdC* tfp = new VerilatedVcdC;

    top->trace(tfp, 99);

    tfp->open("sim/waveform/adder/adder_cpp.vcd");

    for (int i = 0; i < 20; i++) {

        top->a = i;
        top->b = i + 1;
        top->cin = 0;

        top->eval();

        tfp->dump(i);
    }

    tfp->close();

    delete top;

    return 0;
}
```

C++ harness thường được dùng khi:

* test system lớn
* simulation cần chạy hàng triệu cycle
* tích hợp với Python automation

---

## 10. Khi nào dùng Verilog TB và khi nào dùng C++ Harness

| Trường hợp                | Verilog TB | C++ Harness |
| ------------------------- | ---------- | ----------- |
| Unit test adder           | ✓          |             |
| Test mux / fifo / arbiter | ✓          |             |
| Integration nhiều IP      |            | ✓           |
| System simulation         |            | ✓           |
| Chạy firmware / OS        |            | ✓           |
| Debug signal timing       | ✓          | ✓           |

Tư duy thiết kế:

```
Small module → Verilog TB
Multi-IP / System → C++ Harness
Automation → Python
```
