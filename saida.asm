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


# ---- funcao main (void) | 0 parametros ----
main:
    add  x8, x2, x0
    addi x2, x2, -36
   

    addi t0, x0, 12
   

    sw   t0, -4(x8)
   

    lw   t0, -4(x8)
   

    sw   t0, -8(x8)
   

    addi t0, x0, 8
   

    sw   t0, -12(x8)
   

    lw   t0, -12(x8)
   

    sw   t0, -16(x8)
   

    lw   t0, -20(x8)
   

    sw   t0, -24(x8)
   

    lw   t0, -24(x8)
   

    addi x2, x2, -4
    sw   t0, 0(x2)
   

    lw   t0, -28(x8)
   

    sw   t0, -32(x8)
   

    lw   t0, -32(x8)
   

    addi x2, x2, -4
    sw   t0, 0(x2)
   

    addi x2, x2, -4
    sw   x8, 0(x2)
    addi x2, x2, -4
    sw   x1, 0(x2)
    jal  x1, gcd
    lw   x1, 0(x2)
    lw   x8, 4(x2)
    addi x2, x2, 8
   

    addi x2, x2, 8
    sw   x10, -36(x8)
   

   

    lw   t0, -36(x8)
   

    addi x2, x2, -4
    sw   t0, 0(x2)
   

    lw   t0, 0(x2)
    addi x2, x2, 4
    sw   t0, 2040(x0)
   

# ---- fim de main ----
    addi x2, x8, 0
    jalr x0, x1, 0
   


