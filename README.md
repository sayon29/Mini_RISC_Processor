# Custom CPU Architectures in Verilog

This repository contains multiple 32-bit CPU implementations written in Verilog HDL.  
The purpose of this project is to explore different Instruction Set Architectures (ISAs) and microarchitectural designs, including both single-cycle and pipelined processors.

---

## Repository Structure

custom-cpu-architectures/
│
├── mips-single-cycle/
├── riscv32i-single-cycle/
├── riscv32i-5stage-pipeline/   (in progress)
└── README.md

Each processor is implemented as a self-contained design with its own source files, testbenches, and documentation.

---

## Implemented Architectures

### 1. MIPS Single-Cycle Processor
- 32-bit architecture
- Single-cycle datapath
- Separate control and datapath modules
- 32 general-purpose registers
- Supports arithmetic, logical, branch, and memory instructions

### 2. RISC-V RV32I Single-Cycle Processor
- 32-bit RV32I base ISA
- 32 registers (x0–x31)
- Immediate generator supporting I, S, B, U, and J formats
- Word-based memory system
- Modular control and datapath design

### 3. RISC-V RV32I 5-Stage Pipelined Processor (In Progress)
Planned features:
- IF, ID, EX, MEM, WB stages
- Pipeline registers
- Hazard detection unit
- Forwarding unit
- Improved branch handling

---

## Project Goals

- Compare MIPS and RISC-V ISA design principles  
- Understand control logic and datapath implementation  
- Analyze single-cycle vs pipelined processor behavior  
- Build modular and synthesizable RTL designs  
- Develop a structured hardware design portfolio  

---

## Tools and Environment

- Verilog HDL
- FPGA-compatible RTL design
- Simulation using ModelSim, Vivado, or similar tools
- Synthesizable hardware implementation style

---

## Future Improvements

- Complete RV32I compliance verification
- Implement hazard detection and forwarding
- Add memory-mapped I/O
- Performance comparison between architectures
- Optional cache integration

---

## Notes

Each processor version contains its own:
- src/ directory for RTL source files  
- tb/ directory for testbenches  
- README.md file for architecture-specific documentation  

---

## Author

Custom CPU architecture exploration project implemented in Verilog.