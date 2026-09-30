# Assembly RISC-V gerado pelo Compilador C-
# Arquitetura: RV32IM customizada
# I via MMIO: endereco 2044
# O via MMIO: endereco 2040

    addi x2, x0, 2047
    addi x2, x2, 2047
    addi x2, x2, 2047
    addi x2, x2, 2047
    jal  x1, main
__halt:
    jal  x0, __halt

# vetor global 'v[5]' reservado no endereco 0
   


# ---- funcao somaRec (int) | 1 parametros ----
somaRec:
    add  x8, x2, x0
    addi x2, x2, -44
   

    lw   t0, 8(x8)
   

    sw   t0, -4(x8)
   

    addi t0, x0, 0
   

    sw   t0, -8(x8)
   

    lw   t0, -4(x8)
   

    lw   t1, -8(x8)
   

    slt  t2, t0, t1
   

    sw   t2, -12(x8)
   

    lw   t0, -12(x8)
   

    beq  t0, x0, L1
   

    addi t0, x0, 0
   

    sw   t0, -16(x8)
   

    lw   x10, -16(x8)
   

    addi x2, x8, 0
    jalr x0, x1, 0
   

    jal  x0, L2
   

L1:
   

    lw   t0, 8(x8)
   

    sw   t0, -20(x8)
   

    lw   t1, -20(x8)
   

    addi t0, x0, 2
    sll  t1, t1, t0
    addi t0, x0, 0
    add  t0, t0, t1
    lw   t2, 0(t0)
    sw   t2, -24(x8)
   

    lw   t0, 8(x8)
   

    sw   t0, -28(x8)
   

    addi t0, x0, 1
   

    sw   t0, -32(x8)
   

    lw   t0, -28(x8)
   

    lw   t1, -32(x8)
   

    sub  t2, t0, t1
   

    sw   t2, -36(x8)
   

    lw   t0, -36(x8)
   

    addi x2, x2, -4
    sw   t0, 0(x2)
   

    addi x2, x2, -4
    sw   x8, 0(x2)
    addi x2, x2, -4
    sw   x1, 0(x2)
    jal  x1, somaRec
    lw   x1, 0(x2)
    lw   x8, 4(x2)
    addi x2, x2, 8
   

    addi x2, x2, 4
    sw   x10, -40(x8)
   

   

    lw   t0, -24(x8)
   

    lw   t1, -40(x8)
   

    add  t2, t0, t1
   

    sw   t2, -44(x8)
   

    lw   x10, -44(x8)
   

    addi x2, x8, 0
    jalr x0, x1, 0
   

L2:
   

# ---- fim de somaRec ----
    addi x2, x8, 0
    jalr x0, x1, 0
   



# ---- funcao main (void) | 0 parametros ----
main:
    add  x8, x2, x0
    addi x2, x2, -48
   

    addi t0, x0, 0
   

    sw   t0, -4(x8)
   

    addi t0, x0, 1
   

    sw   t0, -8(x8)
   

    lw   t1, -4(x8)
   

    addi t0, x0, 2
    sll  t1, t1, t0
    addi t0, x0, 0
    add  t0, t0, t1
    lw   t2, -8(x8)
   

    sw   t2, 0(t0)
    addi t0, x0, 1
   

    sw   t0, -12(x8)
   

    addi t0, x0, 2
   

    sw   t0, -16(x8)
   

    lw   t1, -12(x8)
   

    addi t0, x0, 2
    sll  t1, t1, t0
    addi t0, x0, 0
    add  t0, t0, t1
    lw   t2, -16(x8)
   

    sw   t2, 0(t0)
    addi t0, x0, 2
   

    sw   t0, -20(x8)
   

    addi t0, x0, 3
   

    sw   t0, -24(x8)
   

    lw   t1, -20(x8)
   

    addi t0, x0, 2
    sll  t1, t1, t0
    addi t0, x0, 0
    add  t0, t0, t1
    lw   t2, -24(x8)
   

    sw   t2, 0(t0)
    addi t0, x0, 3
   

    sw   t0, -28(x8)
   

    addi t0, x0, 4
   

    sw   t0, -32(x8)
   

    lw   t1, -28(x8)
   

    addi t0, x0, 2
    sll  t1, t1, t0
    addi t0, x0, 0
    add  t0, t0, t1
    lw   t2, -32(x8)
   

    sw   t2, 0(t0)
    addi t0, x0, 4
   

    sw   t0, -36(x8)
   

    addi t0, x0, 5
   

    sw   t0, -40(x8)
   

    lw   t1, -36(x8)
   

    addi t0, x0, 2
    sll  t1, t1, t0
    addi t0, x0, 0
    add  t0, t0, t1
    lw   t2, -40(x8)
   

    sw   t2, 0(t0)
    addi t0, x0, 4
   

    sw   t0, -44(x8)
   

    lw   t0, -44(x8)
   

    addi x2, x2, -4
    sw   t0, 0(x2)
   

    addi x2, x2, -4
    sw   x8, 0(x2)
    addi x2, x2, -4
    sw   x1, 0(x2)
    jal  x1, somaRec
    lw   x1, 0(x2)
    lw   x8, 4(x2)
    addi x2, x2, 8
   

    addi x2, x2, 4
    sw   x10, -48(x8)
   

   

    lw   t0, -48(x8)
   

    addi x2, x2, -4
    sw   t0, 0(x2)
   

    lw   t0, 0(x2)
    addi x2, x2, 4
    sw   t0, 2040(x0)
   

# ---- fim de main ----
    addi x2, x8, 0
    jalr x0, x1, 0
   


