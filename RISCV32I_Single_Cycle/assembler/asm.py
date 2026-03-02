import re

def assemble_line(line):
    # Remove comments and clean up whitespace
    line = line.split('#')[0].split('//')[0]
    line = line.replace(',', ' ').replace('(', ' ').replace(')', ' ').split()
    if not line: return None
    
    instr = line[0].lower()
    get_reg = lambda r: int(re.search(r'\d+', r).group())

    # R-Type Encoding (Standard RV32I + RV32M Extension)
    # Mapping for R-type instructions based on opcode 0110011
    r_type_i = {'add':(0,0), 'sub':(0x20,0), 'sll':(0,1), 'slt':(0,2), 'sltu':(0,3), 
                'xor':(0,4), 'srl':(0,5), 'sra':(0x20,5), 'or':(0,6), 'and':(0,7)}
    
    # RV32M Extension Mapping (funct7 is always 0000001)
    r_type_m = {'mul':0, 'mulh':1, 'mulhsu':2, 'mulhu':3, 'div':4, 'divu':5, 'rem':6, 'remu':7}

    if instr in r_type_i:
        rd, rs1, rs2 = get_reg(line[1]), get_reg(line[2]), get_reg(line[3])
        f7, f3 = r_type_i[instr]
        return (f7 << 25) | (rs2 << 20) | (rs1 << 15) | (f3 << 12) | (rd << 7) | 0x33
    
    elif instr in r_type_m:
        rd, rs1, rs2 = get_reg(line[1]), get_reg(line[2]), get_reg(line[3])
        f3 = r_type_m[instr]
        return (0x01 << 25) | (rs2 << 20) | (rs1 << 15) | (f3 << 12) | (rd << 7) | 0x33

    # I-Type ALU (Immediate)
    elif instr in ['addi', 'slti', 'sltiu', 'xori', 'ori', 'andi']:
        rd, rs1, imm = get_reg(line[1]), get_reg(line[2]), int(line[3])
        f3 = {'addi':0, 'slti':2, 'sltiu':3, 'xori':4, 'ori':6, 'andi':7}[instr]
        return ((imm & 0xFFF) << 20) | (rs1 << 15) | (f3 << 12) | (rd << 7) | 0x13

    # I-Type Load (LW)
    elif instr == 'lw':
        rd, imm, rs1 = get_reg(line[1]), int(line[2]), get_reg(line[3])
        return ((imm & 0xFFF) << 20) | (rs1 << 15) | (2 << 12) | (rd << 7) | 0x03

    # S-Type Store (SW)
    elif instr == 'sw':
        rs2, imm, rs1 = get_reg(line[1]), int(line[2]), get_reg(line[3])
        return ((imm >> 5 & 0x7F) << 25) | (rs2 << 20) | (rs1 << 15) | (2 << 12) | (imm & 0x1F << 7) | 0x23

    # B-Type Branch
    elif instr in ['beq', 'bne', 'blt', 'bge', 'bltu', 'bgeu']:
        rs1, rs2, imm = get_reg(line[1]), get_reg(line[2]), int(line[3])
        f3 = {'beq':0, 'bne':1, 'blt':4, 'bge':5, 'bltu':6, 'bgeu':7}[instr]
        # Scrambled bits for B-type [cite: 81]
        b_imm = ((imm >> 12 & 0x1) << 31) | ((imm >> 5 & 0x3F) << 25) | \
                ((rs2 & 0x1F) << 20) | ((rs1 & 0x1F) << 15) | (f3 << 12) | \
                ((imm >> 1 & 0xF) << 8) | ((imm >> 11 & 0x1) << 7) | 0x63
        return b_imm

    return None

def write_coe(filename, data, radix, is_binary=False):
    with open(filename, 'w') as f:
        f.write(f"memory_initialization_radix={radix};\n")
        f.write("memory_initialization_vector=\n")
        for i, val in enumerate(data):
            fmt = f"{val:032b}" if is_binary else f"{val:08x}"
            ending = ";" if i == len(data) - 1 else ","
            f.write(f"{fmt}{ending}\n")

# Reading from ins.txt
try:
    with open('ins.txt', 'r') as f:
        instructions = f.readlines()
    
    encoded = [assemble_line(line) for line in instructions]
    encoded = [x for x in encoded if x is not None]

    if encoded:
        write_coe("hex.coe", encoded, 16)
        write_coe("binary.coe", encoded, 2, is_binary=True)
        print(f"Successfully assembled {len(encoded)} instructions.")
except FileNotFoundError:
    print("Error: ins.txt not found.")