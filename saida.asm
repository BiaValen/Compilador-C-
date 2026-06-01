# Assembly RISC-V gerado pelo Compilador C-
# Arquitetura: RV32IM customizada
# I/O via MMIO: endereco 2044

    addi x2, x0, 8188
    jal  x0, main

   

   


# ---- funcao soma (int) | 2 parametros ----
soma:
    add  x8, x2, x0
   

    lw   t0, 8(x8)
   

    sw   t0, -4(x8)
   

    lw   t0, 4(x8)
   

    sw   t0, -8(x8)
   

    lw   t0, -4(x8)
   

    lw   t1, -8(x8)
   

    add  t2, t0, t1
   

    sw   t2, -12(x8)
   

    lw   x10, -12(x8)
   

    jalr x0, x1, 0
   

# ---- fim de soma ----


# ---- funcao main (int) | 0 parametros ----
main:
    add  x8, x2, x0
   

    addi t0, x0, 5
   

    sw   t0, -4(x8)
   

    lw   t0, -4(x8)
   

    addi x2, x2, -4
    sw   t0, 0(x2)
   

    addi t0, x0, 3
   

    sw   t0, -8(x8)
   

    lw   t0, -8(x8)
   

    addi x2, x2, -4
    sw   t0, 0(x2)
   

    addi x2, x2, -4
    sw   x1, 0(x2)
    jal  x1, soma
    lw   x1, 0(x2)
    addi x2, x2, 4
   

    addi x2, x2, 8
    sw   x10, -12(x8)
   

   

    lw   t0, -12(x8)
   

    sw   t0, -16(x8)
   

    lw   t0, -16(x8)
   

    sw   t0, -20(x8)
   

    lw   x10, -20(x8)
   

    jalr x0, x1, 0
   

# ---- fim de main ----

