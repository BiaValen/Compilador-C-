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
    addi x2, x2, -44
   

    lw   t0, 2044(x0)
    sw   t0, -4(x8)
   

   

    lw   t0, -4(x8)
   

    sw   t0, -8(x8)
   

    lw   t0, 2044(x0)
    sw   t0, -12(x8)
   

   

    lw   t0, -12(x8)
   

    sw   t0, -16(x8)
   

    lw   t0, -8(x8)
   

    sw   t0, -20(x8)
   

    lw   t0, -16(x8)
   

    sw   t0, -24(x8)
   

    lw   t0, -20(x8)
   

    lw   t1, -24(x8)
   

    mul  t2, t0, t1
   

    sw   t2, -28(x8)
   

    addi t0, x0, 2
   

    sw   t0, -32(x8)
   

    lw   t0, -28(x8)
   

    lw   t1, -32(x8)
   

    div  t2, t0, t1
   

    sw   t2, -36(x8)
   

    lw   t0, -36(x8)
   

    sw   t0, -40(x8)
   

    lw   t0, -40(x8)
   

    sw   t0, -44(x8)
   

    lw   t0, -44(x8)
   

    addi x2, x2, -4
    sw   t0, 0(x2)
   

    lw   t0, 0(x2)
    addi x2, x2, 4
    sw   t0, 2040(x0)
   

# ---- fim de main ----
    addi x2, x8, 0
    jalr x0, x1, 0
   


