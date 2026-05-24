# Assembly RISC-V gerado pelo Compilador C-
# Arquitetura: RV32IM customizada
# I/O via MMIO: endereco 2044

    addi x2, x0, 8188
    jal  x0, main

    # OP NAO IMPLEMENTADO: 13

# ---- funcao minloc (int) | 3 parametros ----
minloc:
    add  x8, x2, x0
    lw   t0, 8(x8)
    sw   t0, -4(x8)
    lw   t0, -4(x8)
    sw   t0, -8(x8)
    lw   t0, 8(x8)
    sw   t0, -12(x8)
    lw   t1, -12(x8)
    addi t0, x0, 2
    sll  t1, t1, t0
    lw   t0, 12(x2)
    add  t0, t0, t1
    lw   t2, 0(t0)
    sw   t2, -16(x8)
    lw   t0, -16(x8)
    sw   t0, -20(x8)
    lw   t0, 8(x8)
    sw   t0, -24(x8)
    addi t0, x0, 1
    sw   t0, -28(x8)
    lw   t0, -24(x8)
    lw   t1, -28(x8)
    add  t2, t0, t1
    sw   t2, -32(x8)
    lw   t0, -32(x8)
    sw   t0, -36(x8)
L1:
    lw   t0, -36(x8)
    sw   t0, -40(x8)
    lw   t0, 4(x8)
    sw   t0, -44(x8)
    lw   t0, -40(x8)
    lw   t1, -44(x8)
    slt  t2, t0, t1
    sw   t2, -48(x8)
    lw   t0, -48(x8)
    beq  t0, x0, L2
    lw   t0, -36(x8)
    sw   t0, -52(x8)
    lw   t1, -52(x8)
    addi t0, x0, 2
    sll  t1, t1, t0
    lw   t0, 12(x2)
    add  t0, t0, t1
    lw   t2, 0(t0)
    sw   t2, -56(x8)
    lw   t0, -20(x8)
    sw   t0, -60(x8)
    lw   t0, -56(x8)
    lw   t1, -60(x8)
    slt  t2, t0, t1
    sw   t2, -64(x8)
    lw   t0, -64(x8)
    beq  t0, x0, L3
    lw   t0, -36(x8)
    sw   t0, -68(x8)
    lw   t1, -68(x8)
    addi t0, x0, 2
    sll  t1, t1, t0
    lw   t0, 12(x2)
    add  t0, t0, t1
    lw   t2, 0(t0)
    sw   t2, -72(x8)
    lw   t0, -72(x8)
    sw   t0, -20(x8)
    lw   t0, -36(x8)
    sw   t0, -76(x8)
    lw   t0, -76(x8)
    sw   t0, -8(x8)
L3:
    lw   t0, -36(x8)
    sw   t0, -80(x8)
    addi t0, x0, 1
    sw   t0, -84(x8)
    lw   t0, -80(x8)
    lw   t1, -84(x8)
    add  t2, t0, t1
    sw   t2, -88(x8)
    lw   t0, -88(x8)
    sw   t0, -36(x8)
    jal  x0, L1
L2:
    lw   t0, -8(x8)
    sw   t0, -92(x8)
    lw   x10, -92(x8)
    jalr x0, x1, 0
# ---- fim de minloc ----


# ---- funcao sort (void) | 3 parametros ----
sort:
    add  x8, x2, x0
    lw   t0, 8(x8)
    sw   t0, -4(x8)
    lw   t0, -4(x8)
    sw   t0, -8(x8)
L4:
    lw   t0, -8(x8)
    sw   t0, -12(x8)
    lw   t0, 4(x8)
    sw   t0, -16(x8)
    addi t0, x0, 1
    sw   t0, -20(x8)
    lw   t0, -16(x8)
    lw   t1, -20(x8)
    sub  t2, t0, t1
    sw   t2, -24(x8)
    lw   t0, -12(x8)
    lw   t1, -24(x8)
    slt  t2, t0, t1
    sw   t2, -28(x8)
    lw   t0, -28(x8)
    beq  t0, x0, L5
    lw   t0, 12(x8)
    sw   t0, -32(x8)
    lw   t0, -32(x8)
    addi x2, x2, -4
    sw   t0, 0(x2)
    lw   t0, -8(x8)
    sw   t0, -36(x8)
    lw   t0, -36(x8)
    addi x2, x2, -4
    sw   t0, 0(x2)
    lw   t0, 4(x8)
    sw   t0, -40(x8)
    lw   t0, -40(x8)
    addi x2, x2, -4
    sw   t0, 0(x2)
    addi x2, x2, -4
    sw   x1, 0(x2)
    jal  x1, minloc
    lw   x1, 0(x2)
    addi x2, x2, 4
    addi x2, x2, 12
    sw   x10, -44(x8)
    lw   t0, -44(x8)
    sw   t0, -48(x8)
    lw   t0, -48(x8)
    sw   t0, -52(x8)
    lw   t1, -52(x8)
    addi t0, x0, 2
    sll  t1, t1, t0
    lw   t0, 12(x2)
    add  t0, t0, t1
    lw   t2, 0(t0)
    sw   t2, -56(x8)
    lw   t0, -56(x8)
    sw   t0, -60(x8)
    lw   t0, -48(x8)
    sw   t0, -64(x8)
    lw   t0, -8(x8)
    sw   t0, -68(x8)
    lw   t1, -68(x8)
    addi t0, x0, 2
    sll  t1, t1, t0
    lw   t0, 12(x2)
    add  t0, t0, t1
    lw   t2, 0(t0)
    sw   t2, -72(x8)
    lw   t1, -64(x8)
    addi t0, x0, 2
    sll  t1, t1, t0
    lw   t0, 12(x2)
    add  t0, t0, t1
    lw   t2, -72(x8)
    sw   t2, 0(t0)
    lw   t0, -8(x8)
    sw   t0, -76(x8)
    lw   t0, -60(x8)
    sw   t0, -80(x8)
    lw   t1, -76(x8)
    addi t0, x0, 2
    sll  t1, t1, t0
    lw   t0, 12(x2)
    add  t0, t0, t1
    lw   t2, -80(x8)
    sw   t2, 0(t0)
    lw   t0, -8(x8)
    sw   t0, -84(x8)
    addi t0, x0, 1
    sw   t0, -88(x8)
    lw   t0, -84(x8)
    lw   t1, -88(x8)
    add  t2, t0, t1
    sw   t2, -92(x8)
    lw   t0, -92(x8)
    sw   t0, -8(x8)
    jal  x0, L4
L5:
# ---- fim de sort ----


# ---- funcao main (void) | 0 parametros ----
main:
    add  x8, x2, x0
    addi t0, x0, 0
    sw   t0, -4(x8)
    lw   t0, -4(x8)
    sw   t0, -8(x8)
L6:
    lw   t0, -8(x8)
    sw   t0, -12(x8)
    addi t0, x0, 10
    sw   t0, -16(x8)
    lw   t0, -12(x8)
    lw   t1, -16(x8)
    slt  t2, t0, t1
    sw   t2, -20(x8)
    lw   t0, -20(x8)
    beq  t0, x0, L7
    lw   t0, -8(x8)
    sw   t0, -24(x8)
    lw   t0, 2044(x0)
    sw   t0, -28(x8)
    lw   t1, -24(x8)
    addi t0, x0, 2
    sll  t1, t1, t0
    lw   t0, -32(x2)
    add  t0, t0, t1
    lw   t2, -28(x8)
    sw   t2, 0(t0)
    lw   t0, -8(x8)
    sw   t0, -36(x8)
    addi t0, x0, 1
    sw   t0, -40(x8)
    lw   t0, -36(x8)
    lw   t1, -40(x8)
    add  t2, t0, t1
    sw   t2, -44(x8)
    lw   t0, -44(x8)
    sw   t0, -8(x8)
    jal  x0, L6
L7:
    lw   t0, -32(x8)
    sw   t0, -48(x8)
    lw   t0, -48(x8)
    addi x2, x2, -4
    sw   t0, 0(x2)
    addi t0, x0, 0
    sw   t0, -52(x8)
    lw   t0, -52(x8)
    addi x2, x2, -4
    sw   t0, 0(x2)
    addi t0, x0, 10
    sw   t0, -56(x8)
    lw   t0, -56(x8)
    addi x2, x2, -4
    sw   t0, 0(x2)
    addi x2, x2, -4
    sw   x1, 0(x2)
    jal  x1, sort
    lw   x1, 0(x2)
    addi x2, x2, 4
    addi x2, x2, 12
    sw   x10, -60(x8)
    addi t0, x0, 0
    sw   t0, -64(x8)
    lw   t0, -64(x8)
    sw   t0, -8(x8)
L8:
    lw   t0, -8(x8)
    sw   t0, -68(x8)
    addi t0, x0, 10
    sw   t0, -72(x8)
    lw   t0, -68(x8)
    lw   t1, -72(x8)
    slt  t2, t0, t1
    sw   t2, -76(x8)
    lw   t0, -76(x8)
    beq  t0, x0, L9
    lw   t0, -8(x8)
    sw   t0, -80(x8)
    lw   t1, -80(x8)
    addi t0, x0, 2
    sll  t1, t1, t0
    lw   t0, -32(x2)
    add  t0, t0, t1
    lw   t2, 0(t0)
    sw   t2, -84(x8)
    lw   t0, -84(x8)
    addi x2, x2, -4
    sw   t0, 0(x2)
    lw   t0, 0(x2)
    addi x2, x2, 4
    sw   t0, 2044(x0)
    lw   t0, -8(x8)
    sw   t0, -88(x8)
    addi t0, x0, 1
    sw   t0, -92(x8)
    lw   t0, -88(x8)
    lw   t1, -92(x8)
    add  t2, t0, t1
    sw   t2, -96(x8)
    lw   t0, -96(x8)
    sw   t0, -8(x8)
    jal  x0, L8
L9:
# ---- fim de main ----

