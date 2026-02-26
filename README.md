# Mini RISC Processor
## 32-bit Custom RISC Architecture (FPGA Implementation)

A modular, synthesizable 32-bit RISC processor designed in Verilog HDL.

Developed as part of:
CS39001 – Computer Organization & Architecture Laboratory

------------------------------------------------------------

## Overview

This project implements a fully functional 32-bit RISC processor designed from scratch following classical RISC principles:

- Fixed 32-bit instruction format
- Load/Store architecture
- Hardwired control unit
- Byte-addressable memory
- Word-aligned accesses
- Modular and FPGA-friendly hierarchy

The processor is written entirely in Verilog HDL and is designed for synthesis using Xilinx Vivado.

------------------------------------------------------------

## Top-Level Architecture

The topmost module of the entire design is:

risc_processor

It instantiates the following major subsystems:

- instruction_fetch
- update_pc
- control_unit
- instruction_decoder
- datapath_unit

Vivado reconstructs hierarchy automatically based on module instantiations.

------------------------------------------------------------

## Complete Module Hierarchy

```text
risc_processor
├── instruction_fetch
├── update_pc
├── control_unit
├── instruction_decoder
└── datapath_unit
    ├── register_bank
    ├── data_memory
    ├── alu
    │   ├── comparator_unit
    │   ├── logical_ops
    │   │   ├── logical_ops_unit
    │   │   └── shift_ops_unit
    │   ├── hamming_unit
    │   └── adder_subtractor
    ├── branch_comparator
    └── cmov_comparator
```

------------------------------------------------------------

## Instruction Set Architecture (ISA)

The processor supports multiple instruction formats.

R-Type Format:
opcode (6) | rs (5) | rt (5) | rd (5) | unused (7) | funct (4)

Used for:
- ADD
- SUB
- AND
- OR
- SLT
- HAM (Hamming Distance)
- MOVE
- CMOV

I-Type Format:
opcode (6) | rs (5) | rt (5) | immediate (16)

Used for:
- ADDI
- ANDI
- Load (LD)
- Store (ST)
- Conditional branches (BZ, BMI, BPL)

J-Type Format:
opcode (6) | target address (26)

Used for:
- BR (Unconditional Branch)

Program Control:
- HALT
- NOP

------------------------------------------------------------

## Register Organization

- R0 : Constant Zero Register
- R1–R15 : General Purpose Registers
- SP : Stack Pointer
- PC : Program Counter

Total Registers: 17 × 32-bit

------------------------------------------------------------

## Memory Model

- Byte addressable
- 32-bit word-aligned access
- Base + immediate addressing for load/store
- Memory initialization supported via .coe files

------------------------------------------------------------

## Control Unit

The processor uses a hardwired control unit generating signals such as:

- aluOp
- aluSrc
- wrReg
- wrMem
- rdMem
- mToReg
- immSel
- isBranch
- isCmov
- movOrBr

This ensures efficient decoding and FPGA-friendly synthesis.

------------------------------------------------------------

## Project Structure (Repository Layout)

src/
  All Verilog source files (.v)

constraints/
  XDC constraint file

memory/
  data_memory.coe
  instruction_memory.coe

tb/
  testbench file

Note:
Although all .v files are kept inside a single src/ folder for easy Vivado import,
the logical hierarchy is maintained through module instantiation.

------------------------------------------------------------

## How To Run in Vivado

1. Open Vivado
2. Create New Project
3. Select RTL Project
4. Add all .v files from src/
5. Add:
   - .coe files (memory initialization)
   - .xdc constraints file
6. Set top module as: risc_processor
7. Run:
   - Behavioral Simulation
   - Synthesis
   - Implementation
   - Generate Bitstream

------------------------------------------------------------

## Simulation

You may simulate using:
- Vivado Simulator
- ModelSim
- Any Verilog-compatible simulator

Ensure:
- Testbench file is included
- Memory initialization files are correctly referenced

------------------------------------------------------------

## Design Philosophy

This processor strictly follows RISC design principles:

- Simple and uniform instruction formats
- Hardwired control (low latency)
- Load/Store architecture
- Modular ALU design
- Clear hierarchical decomposition
- FPGA-optimized structure

Custom instructions like HAM (Hamming Distance) and CMOV enhance computational capability while keeping decoding complexity minimal.

------------------------------------------------------------

## Authors

Group 74

Battula Hari Lakshman Prasad (23CS10009)
Sayon Sujit Mondal (23CS30063)

Date: September 2025

------------------------------------------------------------

## License

This project is developed for academic purposes.