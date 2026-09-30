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

# vetor global 'a[3]' reservado no endereco 0
# vetor global 'b[3]' reservado no endereco 12

# ---- funcao main (void) | 0 parametros ----
main:
    add  x8, x2, x0
    addi x2, x2, -144
   

    addi t0, x0, 0
   

    sw   t0, -4(x8)
   

    lw   t0, -4(x8)
   

    sw   t0, -8(x8)
   

L1:
   

    lw   t0, -8(x8)
   

    sw   t0, -12(x8)
   

    addi t0, x0, 3
   

    sw   t0, -16(x8)
   

    lw   t0, -12(x8)
   

    lw   t1, -16(x8)
   

    slt  t2, t0, t1
   

    sw   t2, -20(x8)
   

    lw   t0, -20(x8)
   

    beq  t0, x0, L2
   

    lw   t0, -8(x8)
   

    sw   t0, -24(x8)
   

    lw   t0, 2044(x0)
    sw   t0, -28(x8)
   

   

    lw   t1, -24(x8)
   

    addi t0, x0, 2
    sll  t1, t1, t0
    addi t0, x0, 0
    add  t0, t0, t1
    lw   t2, -28(x8)
   

    sw   t2, 0(t0)
    lw   t0, -8(x8)
   

    sw   t0, -32(x8)
   

    addi t0, x0, 1
   

    sw   t0, -36(x8)
   

    lw   t0, -32(x8)
   

    lw   t1, -36(x8)
   

    add  t2, t0, t1
   

    sw   t2, -40(x8)
   

    lw   t0, -40(x8)
   

    sw   t0, -8(x8)
   

    jal  x0, L1
   

L2:
   

    addi t0, x0, 0
   

    sw   t0, -44(x8)
   

    lw   t0, -44(x8)
   

    sw   t0, -8(x8)
   

L3:
   

    lw   t0, -8(x8)
   

    sw   t0, -48(x8)
   

    addi t0, x0, 5
   

    sw   t0, -52(x8)
   

    lw   t0, -48(x8)
   

    lw   t1, -52(x8)
   

    slt  t2, t0, t1
   

    sw   t2, -56(x8)
   

    lw   t0, -56(x8)
   

    beq  t0, x0, L4
   

    lw   t0, -8(x8)
   

    sw   t0, -60(x8)
   

    lw   t0, 2044(x0)
    sw   t0, -64(x8)
   

   

    lw   t1, -60(x8)
   

    addi t0, x0, 2
    sll  t1, t1, t0
    addi t0, x0, 12
    add  t0, t0, t1
    lw   t2, -64(x8)
   

    sw   t2, 0(t0)
    lw   t0, -8(x8)
   

    sw   t0, -68(x8)
   

    addi t0, x0, 1
   

    sw   t0, -72(x8)
   

    lw   t0, -68(x8)
   

    lw   t1, -72(x8)
   

    add  t2, t0, t1
   

    sw   t2, -76(x8)
   

    lw   t0, -76(x8)
   

    sw   t0, -8(x8)
   

    jal  x0, L3
   

L4:
   

    addi t0, x0, 0
   

    sw   t0, -80(x8)
   

    lw   t0, -80(x8)
   

    sw   t0, -84(x8)
   

    addi t0, x0, 0
   

    sw   t0, -88(x8)
   

    lw   t0, -88(x8)
   

    sw   t0, -8(x8)
   

L5:
   

    lw   t0, -8(x8)
   

    sw   t0, -92(x8)
   

    addi t0, x0, 5
   

    sw   t0, -96(x8)
   

    lw   t0, -92(x8)
   

    lw   t1, -96(x8)
   

    slt  t2, t0, t1
   

    sw   t2, -100(x8)
   

    lw   t0, -100(x8)
   

    beq  t0, x0, L6
   

    lw   t0, -84(x8)
   

    sw   t0, -104(x8)
   

    lw   t0, -8(x8)
   

    sw   t0, -108(x8)
   

    lw   t1, -108(x8)
   

    addi t0, x0, 2
    sll  t1, t1, t0
    addi t0, x0, 0
    add  t0, t0, t1
    lw   t2, 0(t0)
    sw   t2, -112(x8)
   

    lw   t0, -8(x8)
   

    sw   t0, -116(x8)
   

    lw   t1, -116(x8)
   

    addi t0, x0, 2
    sll  t1, t1, t0
    addi t0, x0, 12
    add  t0, t0, t1
    lw   t2, 0(t0)
    sw   t2, -120(x8)
   

    lw   t0, -112(x8)
   

    lw   t1, -120(x8)
   

    mul  t2, t0, t1
   

    sw   t2, -124(x8)
   

    lw   t0, -104(x8)
   

    lw   t1, -124(x8)
   

    add  t2, t0, t1
   

    sw   t2, -128(x8)
   

    lw   t0, -128(x8)
   

    sw   t0, -84(x8)
   

    lw   t0, -8(x8)
   

    sw   t0, -132(x8)
   

    addi t0, x0, 1
   

    sw   t0, -136(x8)
   

    lw   t0, -132(x8)
   

    lw   t1, -136(x8)
   

    add  t2, t0, t1
   

    sw   t2, -140(x8)
   

    lw   t0, -140(x8)
   

    sw   t0, -8(x8)
   

    jal  x0, L5
   

L6:
   

    lw   t0, -84(x8)
   

    sw   t0, -144(x8)
   

    lw   t0, -144(x8)
   

    addi x2, x2, -4
    sw   t0, 0(x2)
   

    lw   t0, 0(x2)
    addi x2, x2, 4
    sw   t0, 2040(x0)
   

# ---- fim de main ----
    addi x2, x8, 0
    jalr x0, x1, 0
   


