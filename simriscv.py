#!/usr/bin/env python3
"""
Simulador RISC-V simplificado para verificar o assembly gerado pelo compilador C-.
Suporta: add, sub, mul, div, addi, lw, sw, slt, slti, xor, xori, sll,
         beq, bne, blt, bge, jal, jalr
I/O via MMIO no endereço 2044.
"""

import sys
import re

# ============================================================
# ESTADO DO PROCESSADOR
# ============================================================

MEM_SIZE  = 8192       # bytes de memória
MMIO_IN_ADDR = 2044       # endereço do input
MMIO_OUT_ADDR =  2040 # endereço de saida

regs = [0] * 32        # x0-x31
memory = [0] * (MEM_SIZE // 4 + 100)  # palavras de 32 bits

# Entrada simulada (substitui o input() do programa)
input_values = []
input_idx    = 0

# Saída capturada
output_values = []

def reg_num(name):
    """Converte nome de registrador para índice."""
    name = name.strip().rstrip(',')
    aliases = {
        'x0':0,'x1':1,'x2':2,'x3':3,'x4':4,'x5':5,'x6':6,'x7':7,
        'x8':8,'x9':9,'x10':10,'x11':11,'x12':12,'x13':13,'x14':14,'x15':15,
        'x16':16,'x17':17,'x18':18,'x19':19,'x20':20,'x21':21,'x22':22,'x23':23,
        'x24':24,'x25':25,'x26':26,'x27':27,'x28':28,'x29':29,'x30':30,'x31':31,
        'zero':0,'ra':1,'sp':2,'gp':3,'tp':4,
        't0':5,'t1':6,'t2':7,'s0':8,'fp':8,'s1':9,
        'a0':10,'a1':11,'a2':12,'a3':13,'a4':14,'a5':15,'a6':16,'a7':17,
        's2':18,'s3':19,'s4':20,'s5':21,'s6':22,'s7':23,'s8':24,'s9':25,'s10':26,'s11':27,
        't3':28,'t4':29,'t5':30,'t6':31,
    }
    if name in aliases:
        return aliases[name]
    raise ValueError(f"Registrador desconhecido: {name}")

def to_signed32(val):
    """Converte para inteiro com sinal de 32 bits."""
    val = val & 0xFFFFFFFF
    if val >= 0x80000000:
        val -= 0x100000000
    return val

def mem_read(addr):
    """Lê uma palavra de 32 bits da memória."""
    global input_idx
    if addr == MMIO_IN_ADDR:
        if input_idx < len(input_values):
            val = input_values[input_idx]   
            input_idx += 1
            print(f"  [INPUT] → {val}")
            return val
        else:
            val = int(input("  [INPUT] Digite um valor: "))
            return val
    idx = addr // 4
    if idx < 0 or idx >= len(memory):
        raise RuntimeError(f"Acesso fora da memória: addr={addr}")
    return to_signed32(memory[idx])

def mem_write(addr, val):
    """Escreve uma palavra de 32 bits na memória."""
    if addr == MMIO_OUT_ADDR:
        print(f"  [OUTPUT] → {to_signed32(val)}")
        output_values.append(to_signed32(val))
        return
    idx = addr // 4
    if idx < 0 or idx >= len(memory):
        raise RuntimeError(f"Escrita fora da memória: addr={addr}")
    memory[idx] = val & 0xFFFFFFFF

def set_reg(rd, val):
    """Escreve em registrador (x0 é sempre 0)."""
    if rd != 0:
        regs[rd] = val & 0xFFFFFFFF

def get_reg(rs):
    return to_signed32(regs[rs])

# ============================================================
# PARSER DO ASSEMBLY
# ============================================================

def parse_asm(filename):
    """
    Lê o arquivo .asm e retorna:
    - instructions: lista de (linha_original, mnemonic, operands)
    - labels: dict {nome: índice na lista}
    """
    instructions = []
    labels = {}

    with open(filename) as f:
        for line in f:
            # Remove comentários e espaços
            line = line.split('#')[0].strip()
            if not line:
                continue

            # Label
            if line.endswith(':'):
                labels[line[:-1].strip()] = len(instructions)
                continue

            # Instrução
            parts = line.replace(',', ' ').split()
            if not parts:
                continue

            mnemonic = parts[0].lower()
            operands = parts[1:]
            instructions.append((line, mnemonic, operands))

    return instructions, labels

def parse_mem_operand(op):
    """Parseia 'offset(reg)' → (offset, reg_idx)."""
    m = re.match(r'(-?\d+)\((\w+)\)', op)
    if m:
        return int(m.group(1)), reg_num(m.group(2))
    raise ValueError(f"Operando de memória inválido: {op}")

# ============================================================
# EXECUÇÃO
# ============================================================

def run(instructions, labels, max_steps=100000):
    pc = 0
    steps = 0

    while pc < len(instructions) and steps < max_steps:
        steps += 1
        line, mn, ops = instructions[pc]
        next_pc = pc + 1

        try:
            if mn == 'addi':
                rd  = reg_num(ops[0])
                rs1 = reg_num(ops[1])
                imm = int(ops[2])
                set_reg(rd, get_reg(rs1) + imm)

            elif mn == 'add':
                rd  = reg_num(ops[0])
                rs1 = reg_num(ops[1])
                rs2 = reg_num(ops[2])
                set_reg(rd, get_reg(rs1) + get_reg(rs2))

            elif mn == 'sub':
                rd  = reg_num(ops[0])
                rs1 = reg_num(ops[1])
                rs2 = reg_num(ops[2])
                set_reg(rd, get_reg(rs1) - get_reg(rs2))

            elif mn == 'mul':
                rd  = reg_num(ops[0])
                rs1 = reg_num(ops[1])
                rs2 = reg_num(ops[2])
                set_reg(rd, get_reg(rs1) * get_reg(rs2))

            elif mn == 'div':
                rd  = reg_num(ops[0])
                rs1 = reg_num(ops[1])
                rs2 = reg_num(ops[2])
                divisor = get_reg(rs2)
                if divisor == 0:
                    raise RuntimeError("Divisão por zero!")
                set_reg(rd, int(get_reg(rs1) / divisor))

            elif mn == 'xor':
                rd  = reg_num(ops[0])
                rs1 = reg_num(ops[1])
                rs2 = reg_num(ops[2])
                set_reg(rd, get_reg(rs1) ^ get_reg(rs2))

            elif mn == 'xori':
                rd  = reg_num(ops[0])
                rs1 = reg_num(ops[1])
                imm = int(ops[2])
                set_reg(rd, get_reg(rs1) ^ imm)

            elif mn == 'slt':
                rd  = reg_num(ops[0])
                rs1 = reg_num(ops[1])
                rs2 = reg_num(ops[2])
                set_reg(rd, 1 if get_reg(rs1) < get_reg(rs2) else 0)

            elif mn == 'slti':
                rd  = reg_num(ops[0])
                rs1 = reg_num(ops[1])
                imm = int(ops[2])
                set_reg(rd, 1 if get_reg(rs1) < imm else 0)

            elif mn == 'sll':
                rd    = reg_num(ops[0])
                rs1   = reg_num(ops[1])
                rs2   = reg_num(ops[2])
                shamt = get_reg(rs2) & 0x1F
                set_reg(rd, get_reg(rs1) << shamt)

            elif mn == 'lw':
                rd  = reg_num(ops[0])
                off, rs1 = parse_mem_operand(ops[1])
                addr = get_reg(rs1) + off
                set_reg(rd, mem_read(addr))

            elif mn == 'sw':
                rs2 = reg_num(ops[0])
                off, rs1 = parse_mem_operand(ops[1])
                addr = get_reg(rs1) + off
                mem_write(addr, get_reg(rs2))

            elif mn == 'beq':
                rs1 = reg_num(ops[0])
                rs2 = reg_num(ops[1])
                label = ops[2]
                if get_reg(rs1) == get_reg(rs2):
                    next_pc = labels[label]

            elif mn == 'bne':
                rs1 = reg_num(ops[0])
                rs2 = reg_num(ops[1])
                label = ops[2]
                if get_reg(rs1) != get_reg(rs2):
                    next_pc = labels[label]

            elif mn == 'blt':
                rs1 = reg_num(ops[0])
                rs2 = reg_num(ops[1])
                label = ops[2]
                if get_reg(rs1) < get_reg(rs2):
                    next_pc = labels[label]

            elif mn == 'bge':
                rs1 = reg_num(ops[0])
                rs2 = reg_num(ops[1])
                label = ops[2]
                if get_reg(rs1) >= get_reg(rs2):
                    next_pc = labels[label]

            elif mn == 'jal':
                rd    = reg_num(ops[0])
                label = ops[1]
                set_reg(rd, next_pc)   # salva endereço de retorno
                next_pc = labels[label]

            elif mn == 'jalr':
                rd  = reg_num(ops[0])
                rs1 = reg_num(ops[1])
                imm = int(ops[2])
                ret = next_pc
                next_pc = None   # encerra se rd == x0
                target = get_reg(rs1) + imm
                set_reg(rd, ret)
                if rd == 0 and target == 0:
                    # jalr x0, x1, 0 — retorno
                    # target deve ser o valor de x1
                    pass
                # usa o valor de rs1 ANTES de ser sobrescrito
                next_pc = to_signed32(regs[reg_num(ops[1])]) + imm
                # se rd == x0 e alvo == 0, encerra
                if next_pc <= 0:
                    print(f"\n[FIM] Programa encerrou após {steps} passos.")
                    return

            else:
                print(f"  [AVISO] Instrução não reconhecida: {mn}")

        except Exception as e:
            print(f"\n[ERRO] na instrução {pc}: '{line}'")
            print(f"  {e}")
            print(f"  PC={pc}, SP={get_reg(2)}, x8={get_reg(8)}")
            return

        pc = next_pc
        if pc is None or pc < 0:
            break

    if steps >= max_steps:
        print(f"\n[AVISO] Limite de {max_steps} passos atingido — possível loop infinito.")

    print(f"\n[FIM] {steps} passos executados.")

# ============================================================
# PONTO DE ENTRADA
# ============================================================

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Uso: python simriscv.py arquivo.asm [input1 input2 ...]")
        print("Exemplo GCD:  python simriscv.py saida.asm 12 8")
        print("Exemplo sort: python simriscv.py saida.asm 5 3 8 1 9 2 7 4 6 0")
        sys.exit(1)

    asm_file = sys.argv[1]

    # Valores de input passados como argumentos
    input_values = [int(x) for x in sys.argv[2:]]

    print(f"=== Simulador RISC-V ===")
    print(f"Arquivo: {asm_file}")
    if input_values:
        print(f"Inputs:  {input_values}")
    print()

    instructions, labels = parse_asm(asm_file)
    print(f"{len(instructions)} instruções carregadas, {len(labels)} labels.\n")

    run(instructions, labels)

#   if output_values:
#        print(f"\n=== SAÍDA DO PROGRAMA ===")
#       print(output_values)
#


#python simriscv.py <nome_do_arquivo.asm> [entradas_opcionais]

#python simriscv.py saida.asm 12 8   -> GCD
#python simriscv.py saida.asm 10     -> Fibonacci
#python simriscv.py saida.asm 10     -> Ordenação Sort