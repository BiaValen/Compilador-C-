# Assembly RISC-V gerado pelo Compilador C-
# Arquitetura: RV32IM customizada
# I via MMIO: endereco 2044
# O via MMIO: endereco 2040

    addi x2, x0, 8188
    jal  x0, main

# vetor global 'dados[6]' reservado no endereco 0
# vetor global 'copia[6]' reservado no endereco 24
   

   


# ---- funcao igual (int) | 2 parametros ----
igual:
    add  x8, x2, x0
    addi x2, x2, -20
   

    lw   t0, 12(x8)
   

    sw   t0, -4(x8)
   

    lw   t0, 8(x8)
   

    sw   t0, -8(x8)
   

    lw   t0, -4(x8)
   

    lw   t1, -8(x8)
   

    xor  t2, t0, t1
    slti t2, t2, 1
   

    sw   t2, -12(x8)
   

    lw   t0, -12(x8)
   

    beq  t0, x0, L1
   

    addi t0, x0, 1
   

    sw   t0, -16(x8)
   

    lw   x10, -16(x8)
   

    addi x2, x8, 0
    jalr x0, x1, 0
   

    jal  x0, L2
   

L1:
   

    addi t0, x0, 0
   

    sw   t0, -20(x8)
   

    lw   x10, -20(x8)
   

    addi x2, x8, 0
    jalr x0, x1, 0
   

L2:
   

# ---- fim de igual ----
    addi x2, x8, 0
    jalr x0, x1, 0
   


   

   


# ---- funcao diferente (int) | 2 parametros ----
diferente:
    add  x8, x2, x0
    addi x2, x2, -20
   

    lw   t0, 12(x8)
   

    sw   t0, -4(x8)
   

    lw   t0, 8(x8)
   

    sw   t0, -8(x8)
   

    lw   t0, -4(x8)
   

    lw   t1, -8(x8)
   

    xor  t2, t0, t1
    slti t2, t2, 1
    xori t2, t2, 1
   

    sw   t2, -12(x8)
   

    lw   t0, -12(x8)
   

    beq  t0, x0, L3
   

    addi t0, x0, 1
   

    sw   t0, -16(x8)
   

    lw   x10, -16(x8)
   

    addi x2, x8, 0
    jalr x0, x1, 0
   

    jal  x0, L4
   

L3:
   

    addi t0, x0, 0
   

    sw   t0, -20(x8)
   

    lw   x10, -20(x8)
   

    addi x2, x8, 0
    jalr x0, x1, 0
   

L4:
   

# ---- fim de diferente ----
    addi x2, x8, 0
    jalr x0, x1, 0
   


   

   


# ---- funcao maximo (int) | 2 parametros ----
maximo:
    add  x8, x2, x0
    addi x2, x2, -20
   

    lw   t0, 12(x8)
   

    sw   t0, -4(x8)
   

    lw   t0, 8(x8)
   

    sw   t0, -8(x8)
   

    lw   t0, -4(x8)
   

    lw   t1, -8(x8)
   

    slt  t2, t1, t0
   

    sw   t2, -12(x8)
   

    lw   t0, -12(x8)
   

    beq  t0, x0, L5
   

    lw   t0, 12(x8)
   

    sw   t0, -16(x8)
   

    lw   x10, -16(x8)
   

    addi x2, x8, 0
    jalr x0, x1, 0
   

    jal  x0, L6
   

L5:
   

    lw   t0, 8(x8)
   

    sw   t0, -20(x8)
   

    lw   x10, -20(x8)
   

    addi x2, x8, 0
    jalr x0, x1, 0
   

L6:
   

# ---- fim de maximo ----
    addi x2, x8, 0
    jalr x0, x1, 0
   


   

   


# ---- funcao distancia (int) | 2 parametros ----
distancia:
    add  x8, x2, x0
    addi x2, x2, -36
   

    lw   t0, 12(x8)
   

    sw   t0, -4(x8)
   

    lw   t0, 8(x8)
   

    sw   t0, -8(x8)
   

    lw   t0, -4(x8)
   

    lw   t1, -8(x8)
   

    slt  t2, t0, t1
    xori t2, t2, 1
   

    sw   t2, -12(x8)
   

    lw   t0, -12(x8)
   

    beq  t0, x0, L7
   

    lw   t0, 12(x8)
   

    sw   t0, -16(x8)
   

    lw   t0, 8(x8)
   

    sw   t0, -20(x8)
   

    lw   t0, -16(x8)
   

    lw   t1, -20(x8)
   

    sub  t2, t0, t1
   

    sw   t2, -24(x8)
   

    lw   x10, -24(x8)
   

    addi x2, x8, 0
    jalr x0, x1, 0
   

    jal  x0, L8
   

L7:
   

    lw   t0, 8(x8)
   

    sw   t0, -28(x8)
   

    lw   t0, 12(x8)
   

    sw   t0, -32(x8)
   

    lw   t0, -28(x8)
   

    lw   t1, -32(x8)
   

    sub  t2, t0, t1
   

    sw   t2, -36(x8)
   

    lw   x10, -36(x8)
   

    addi x2, x8, 0
    jalr x0, x1, 0
   

L8:
   

# ---- fim de distancia ----
    addi x2, x8, 0
    jalr x0, x1, 0
   


   


# ---- funcao fib (int) | 1 parametros ----
fib:
    add  x8, x2, x0
    addi x2, x2, -52
   

    lw   t0, 8(x8)
   

    sw   t0, -4(x8)
   

    addi t0, x0, 1
   

    sw   t0, -8(x8)
   

    lw   t0, -4(x8)
   

    lw   t1, -8(x8)
   

    slt  t2, t1, t0
    xori t2, t2, 1
   

    sw   t2, -12(x8)
   

    lw   t0, -12(x8)
   

    beq  t0, x0, L9
   

    lw   t0, 8(x8)
   

    sw   t0, -16(x8)
   

    lw   x10, -16(x8)
   

    addi x2, x8, 0
    jalr x0, x1, 0
   

    jal  x0, L10
   

L9:
   

    lw   t0, 8(x8)
   

    sw   t0, -20(x8)
   

    addi t0, x0, 1
   

    sw   t0, -24(x8)
   

    lw   t0, -20(x8)
   

    lw   t1, -24(x8)
   

    sub  t2, t0, t1
   

    sw   t2, -28(x8)
   

    lw   t0, -28(x8)
   

    addi x2, x2, -4
    sw   t0, 0(x2)
   

    addi x2, x2, -4
    sw   x8, 0(x2)
    addi x2, x2, -4
    sw   x1, 0(x2)
    jal  x1, fib
    lw   x1, 0(x2)
    lw   x8, 4(x2)
    addi x2, x2, 8
   

    addi x2, x2, 4
    sw   x10, -32(x8)
   

   

    lw   t0, 8(x8)
   

    sw   t0, -36(x8)
   

    addi t0, x0, 2
   

    sw   t0, -40(x8)
   

    lw   t0, -36(x8)
   

    lw   t1, -40(x8)
   

    sub  t2, t0, t1
   

    sw   t2, -44(x8)
   

    lw   t0, -44(x8)
   

    addi x2, x2, -4
    sw   t0, 0(x2)
   

    addi x2, x2, -4
    sw   x8, 0(x2)
    addi x2, x2, -4
    sw   x1, 0(x2)
    jal  x1, fib
    lw   x1, 0(x2)
    lw   x8, 4(x2)
    addi x2, x2, 8
   

    addi x2, x2, 4
    sw   x10, -48(x8)
   

   

    lw   t0, -32(x8)
   

    lw   t1, -48(x8)
   

    add  t2, t0, t1
   

    sw   t2, -52(x8)
   

    lw   x10, -52(x8)
   

    addi x2, x8, 0
    jalr x0, x1, 0
   

L10:
   

# ---- fim de fib ----
    addi x2, x8, 0
    jalr x0, x1, 0
   


   

   


# ---- funcao resto (int) | 2 parametros ----
resto:
    add  x8, x2, x0
    addi x2, x2, -44
   

    lw   t0, 12(x8)
   

    sw   t0, -4(x8)
   

    lw   t0, 8(x8)
   

    sw   t0, -8(x8)
   

    lw   t0, -4(x8)
   

    lw   t1, -8(x8)
   

    div  t2, t0, t1
   

    sw   t2, -12(x8)
   

    lw   t0, -12(x8)
   

    sw   t0, -16(x8)
   

    lw   t0, 12(x8)
   

    sw   t0, -20(x8)
   

    lw   t0, -16(x8)
   

    sw   t0, -24(x8)
   

    lw   t0, 8(x8)
   

    sw   t0, -28(x8)
   

    lw   t0, -24(x8)
   

    lw   t1, -28(x8)
   

    mul  t2, t0, t1
   

    sw   t2, -32(x8)
   

    lw   t0, -20(x8)
   

    lw   t1, -32(x8)
   

    sub  t2, t0, t1
   

    sw   t2, -36(x8)
   

    lw   t0, -36(x8)
   

    sw   t0, -40(x8)
   

    lw   t0, -40(x8)
   

    sw   t0, -44(x8)
   

    lw   x10, -44(x8)
   

    addi x2, x8, 0
    jalr x0, x1, 0
   

# ---- fim de resto ----
    addi x2, x8, 0
    jalr x0, x1, 0
   


   

   


# ---- funcao mdc (int) | 2 parametros ----
mdc:
    add  x8, x2, x0
    addi x2, x2, -40
   

L11:
   

    lw   t0, 8(x8)
   

    sw   t0, -4(x8)
   

    addi t0, x0, 0
   

    sw   t0, -8(x8)
   

    lw   t0, -4(x8)
   

    lw   t1, -8(x8)
   

    xor  t2, t0, t1
    slti t2, t2, 1
    xori t2, t2, 1
   

    sw   t2, -12(x8)
   

    lw   t0, -12(x8)
   

    beq  t0, x0, L12
   

    lw   t0, 12(x8)
   

    sw   t0, -16(x8)
   

    lw   t0, -16(x8)
   

    addi x2, x2, -4
    sw   t0, 0(x2)
   

    lw   t0, 8(x8)
   

    sw   t0, -20(x8)
   

    lw   t0, -20(x8)
   

    addi x2, x2, -4
    sw   t0, 0(x2)
   

    addi x2, x2, -4
    sw   x8, 0(x2)
    addi x2, x2, -4
    sw   x1, 0(x2)
    jal  x1, resto
    lw   x1, 0(x2)
    lw   x8, 4(x2)
    addi x2, x2, 8
   

    addi x2, x2, 8
    sw   x10, -24(x8)
   

   

    lw   t0, -24(x8)
   

    sw   t0, -28(x8)
   

    lw   t0, 8(x8)
   

    sw   t0, -32(x8)
   

    lw   t0, -32(x8)
   

    sw   t0, 12(x8)
   

    lw   t0, -28(x8)
   

    sw   t0, -36(x8)
   

    lw   t0, -36(x8)
   

    sw   t0, 8(x8)
   

    jal  x0, L11
   

L12:
   

    lw   t0, 12(x8)
   

    sw   t0, -40(x8)
   

    lw   x10, -40(x8)
   

    addi x2, x8, 0
    jalr x0, x1, 0
   

# ---- fim de mdc ----
    addi x2, x8, 0
    jalr x0, x1, 0
   


   

   


# ---- funcao ler (void) | 2 parametros ----
ler:
    add  x8, x2, x0
    addi x2, x2, -40
   

    addi t0, x0, 0
   

    sw   t0, -4(x8)
   

    lw   t0, -4(x8)
   

    sw   t0, -8(x8)
   

L13:
   

    lw   t0, -8(x8)
   

    sw   t0, -12(x8)
   

    lw   t0, 8(x8)
   

    sw   t0, -16(x8)
   

    lw   t0, -12(x8)
   

    lw   t1, -16(x8)
   

    slt  t2, t0, t1
   

    sw   t2, -20(x8)
   

    lw   t0, -20(x8)
   

    beq  t0, x0, L14
   

    lw   t0, -8(x8)
   

    sw   t0, -24(x8)
   

    lw   t0, 2044(x0)
    sw   t0, -28(x8)
   

   

    lw   t1, -24(x8)
   

    addi t0, x0, 2
    sll  t1, t1, t0
    lw   t0, 12(x8)
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
   

    jal  x0, L13
   

L14:
   

# ---- fim de ler ----
    addi x2, x8, 0
    jalr x0, x1, 0
   


   

   

   


# ---- funcao copiareverso (void) | 3 parametros ----
copiareverso:
    add  x8, x2, x0
    addi x2, x2, -68
   

    addi t0, x0, 0
   

    sw   t0, -4(x8)
   

    lw   t0, -4(x8)
   

    sw   t0, -8(x8)
   

L15:
   

    lw   t0, -8(x8)
   

    sw   t0, -12(x8)
   

    lw   t0, 8(x8)
   

    sw   t0, -16(x8)
   

    lw   t0, -12(x8)
   

    lw   t1, -16(x8)
   

    slt  t2, t0, t1
   

    sw   t2, -20(x8)
   

    lw   t0, -20(x8)
   

    beq  t0, x0, L16
   

    lw   t0, 8(x8)
   

    sw   t0, -24(x8)
   

    addi t0, x0, 1
   

    sw   t0, -28(x8)
   

    lw   t0, -24(x8)
   

    lw   t1, -28(x8)
   

    sub  t2, t0, t1
   

    sw   t2, -32(x8)
   

    lw   t0, -8(x8)
   

    sw   t0, -36(x8)
   

    lw   t0, -32(x8)
   

    lw   t1, -36(x8)
   

    sub  t2, t0, t1
   

    sw   t2, -40(x8)
   

    lw   t0, -40(x8)
   

    sw   t0, -44(x8)
   

    lw   t0, -8(x8)
   

    sw   t0, -48(x8)
   

    lw   t0, -44(x8)
   

    sw   t0, -52(x8)
   

    lw   t1, -52(x8)
   

    addi t0, x0, 2
    sll  t1, t1, t0
    lw   t0, 16(x8)
    add  t0, t0, t1
    lw   t2, 0(t0)
    sw   t2, -56(x8)
   

    lw   t1, -48(x8)
   

    addi t0, x0, 2
    sll  t1, t1, t0
    lw   t0, 12(x8)
    add  t0, t0, t1
    lw   t2, -56(x8)
   

    sw   t2, 0(t0)
    lw   t0, -8(x8)
   

    sw   t0, -60(x8)
   

    addi t0, x0, 1
   

    sw   t0, -64(x8)
   

    lw   t0, -60(x8)
   

    lw   t1, -64(x8)
   

    add  t2, t0, t1
   

    sw   t2, -68(x8)
   

    lw   t0, -68(x8)
   

    sw   t0, -8(x8)
   

    jal  x0, L15
   

L16:
   

# ---- fim de copiareverso ----
    addi x2, x8, 0
    jalr x0, x1, 0
   


   

   


# ---- funcao soma (int) | 2 parametros ----
soma:
    add  x8, x2, x0
    addi x2, x2, -60
   

    addi t0, x0, 0
   

    sw   t0, -4(x8)
   

    lw   t0, -4(x8)
   

    sw   t0, -8(x8)
   

    addi t0, x0, 0
   

    sw   t0, -12(x8)
   

    lw   t0, -12(x8)
   

    sw   t0, -16(x8)
   

L17:
   

    lw   t0, -8(x8)
   

    sw   t0, -20(x8)
   

    lw   t0, 8(x8)
   

    sw   t0, -24(x8)
   

    lw   t0, -20(x8)
   

    lw   t1, -24(x8)
   

    slt  t2, t0, t1
   

    sw   t2, -28(x8)
   

    lw   t0, -28(x8)
   

    beq  t0, x0, L18
   

    lw   t0, -16(x8)
   

    sw   t0, -32(x8)
   

    lw   t0, -8(x8)
   

    sw   t0, -36(x8)
   

    lw   t1, -36(x8)
   

    addi t0, x0, 2
    sll  t1, t1, t0
    lw   t0, 12(x8)
    add  t0, t0, t1
    lw   t2, 0(t0)
    sw   t2, -40(x8)
   

    lw   t0, -32(x8)
   

    lw   t1, -40(x8)
   

    add  t2, t0, t1
   

    sw   t2, -44(x8)
   

    lw   t0, -44(x8)
   

    sw   t0, -16(x8)
   

    lw   t0, -8(x8)
   

    sw   t0, -48(x8)
   

    addi t0, x0, 1
   

    sw   t0, -52(x8)
   

    lw   t0, -48(x8)
   

    lw   t1, -52(x8)
   

    add  t2, t0, t1
   

    sw   t2, -56(x8)
   

    lw   t0, -56(x8)
   

    sw   t0, -8(x8)
   

    jal  x0, L17
   

L18:
   

    lw   t0, -16(x8)
   

    sw   t0, -60(x8)
   

    lw   x10, -60(x8)
   

    addi x2, x8, 0
    jalr x0, x1, 0
   

# ---- fim de soma ----
    addi x2, x8, 0
    jalr x0, x1, 0
   


   

   


# ---- funcao produto (int) | 2 parametros ----
produto:
    add  x8, x2, x0
    addi x2, x2, -88
   

    addi t0, x0, 0
   

    sw   t0, -4(x8)
   

    lw   t0, -4(x8)
   

    sw   t0, -8(x8)
   

    addi t0, x0, 1
   

    sw   t0, -12(x8)
   

    lw   t0, -12(x8)
   

    sw   t0, -16(x8)
   

L19:
   

    lw   t0, -8(x8)
   

    sw   t0, -20(x8)
   

    lw   t0, 8(x8)
   

    sw   t0, -24(x8)
   

    lw   t0, -20(x8)
   

    lw   t1, -24(x8)
   

    slt  t2, t0, t1
   

    sw   t2, -28(x8)
   

    lw   t0, -28(x8)
   

    beq  t0, x0, L20
   

    lw   t0, -8(x8)
   

    sw   t0, -32(x8)
   

    lw   t1, -32(x8)
   

    addi t0, x0, 2
    sll  t1, t1, t0
    lw   t0, 12(x8)
    add  t0, t0, t1
    lw   t2, 0(t0)
    sw   t2, -36(x8)
   

    addi t0, x0, 0
   

    sw   t0, -40(x8)
   

    lw   t0, -36(x8)
   

    lw   t1, -40(x8)
   

    slt  t2, t1, t0
   

    sw   t2, -44(x8)
   

    lw   t0, -44(x8)
   

    beq  t0, x0, L21
   

    lw   t0, -16(x8)
   

    sw   t0, -48(x8)
   

    lw   t0, -8(x8)
   

    sw   t0, -52(x8)
   

    lw   t1, -52(x8)
   

    addi t0, x0, 2
    sll  t1, t1, t0
    lw   t0, 12(x8)
    add  t0, t0, t1
    lw   t2, 0(t0)
    sw   t2, -56(x8)
   

    lw   t0, -48(x8)
   

    lw   t1, -56(x8)
   

    mul  t2, t0, t1
   

    sw   t2, -60(x8)
   

    lw   t0, -60(x8)
   

    sw   t0, -16(x8)
   

    jal  x0, L22
   

L21:
   

    lw   t0, -16(x8)
   

    sw   t0, -64(x8)
   

    addi t0, x0, 1
   

    sw   t0, -68(x8)
   

    lw   t0, -64(x8)
   

    lw   t1, -68(x8)
   

    mul  t2, t0, t1
   

    sw   t2, -72(x8)
   

    lw   t0, -72(x8)
   

    sw   t0, -16(x8)
   

L22:
   

    lw   t0, -8(x8)
   

    sw   t0, -76(x8)
   

    addi t0, x0, 1
   

    sw   t0, -80(x8)
   

    lw   t0, -76(x8)
   

    lw   t1, -80(x8)
   

    add  t2, t0, t1
   

    sw   t2, -84(x8)
   

    lw   t0, -84(x8)
   

    sw   t0, -8(x8)
   

    jal  x0, L19
   

L20:
   

    lw   t0, -16(x8)
   

    sw   t0, -88(x8)
   

    lw   x10, -88(x8)
   

    addi x2, x8, 0
    jalr x0, x1, 0
   

# ---- fim de produto ----
    addi x2, x8, 0
    jalr x0, x1, 0
   



# ---- funcao main (void) | 0 parametros ----
main:
    add  x8, x2, x0
    addi x2, x2, -268
   

    addi t0, x0, 0
   

    sw   t0, -4(x8)
   

    lw   t0, -4(x8)
   

    addi x2, x2, -4
    sw   t0, 0(x2)
   

    addi t0, x0, 6
   

    sw   t0, -8(x8)
   

    lw   t0, -8(x8)
   

    addi x2, x2, -4
    sw   t0, 0(x2)
   

    addi x2, x2, -4
    sw   x8, 0(x2)
    addi x2, x2, -4
    sw   x1, 0(x2)
    jal  x1, ler
    lw   x1, 0(x2)
    lw   x8, 4(x2)
    addi x2, x2, 8
   

    addi x2, x2, 8
    sw   x10, -12(x8)
   

   

    addi t0, x0, 0
   

    sw   t0, -16(x8)
   

    lw   t0, -16(x8)
   

    addi x2, x2, -4
    sw   t0, 0(x2)
   

    addi t0, x0, 24
   

    sw   t0, -20(x8)
   

    lw   t0, -20(x8)
   

    addi x2, x2, -4
    sw   t0, 0(x2)
   

    addi t0, x0, 6
   

    sw   t0, -24(x8)
   

    lw   t0, -24(x8)
   

    addi x2, x2, -4
    sw   t0, 0(x2)
   

    addi x2, x2, -4
    sw   x8, 0(x2)
    addi x2, x2, -4
    sw   x1, 0(x2)
    jal  x1, copiareverso
    lw   x1, 0(x2)
    lw   x8, 4(x2)
    addi x2, x2, 8
   

    addi x2, x2, 12
    sw   x10, -28(x8)
   

   

    addi t0, x0, 0
   

    sw   t0, -32(x8)
   

    lw   t0, -32(x8)
   

    addi x2, x2, -4
    sw   t0, 0(x2)
   

    addi t0, x0, 6
   

    sw   t0, -36(x8)
   

    lw   t0, -36(x8)
   

    addi x2, x2, -4
    sw   t0, 0(x2)
   

    addi x2, x2, -4
    sw   x8, 0(x2)
    addi x2, x2, -4
    sw   x1, 0(x2)
    jal  x1, soma
    lw   x1, 0(x2)
    lw   x8, 4(x2)
    addi x2, x2, 8
   

    addi x2, x2, 8
    sw   x10, -40(x8)
   

   

    lw   t0, -40(x8)
   

    sw   t0, -44(x8)
   

    addi t0, x0, 0
   

    sw   t0, -48(x8)
   

    lw   t0, -48(x8)
   

    addi x2, x2, -4
    sw   t0, 0(x2)
   

    addi t0, x0, 6
   

    sw   t0, -52(x8)
   

    lw   t0, -52(x8)
   

    addi x2, x2, -4
    sw   t0, 0(x2)
   

    addi x2, x2, -4
    sw   x8, 0(x2)
    addi x2, x2, -4
    sw   x1, 0(x2)
    jal  x1, produto
    lw   x1, 0(x2)
    lw   x8, 4(x2)
    addi x2, x2, 8
   

    addi x2, x2, 8
    sw   x10, -56(x8)
   

   

    lw   t0, -56(x8)
   

    sw   t0, -60(x8)
   

    addi t0, x0, 0
   

    sw   t0, -64(x8)
   

    lw   t1, -64(x8)
   

    addi t0, x0, 2
    sll  t1, t1, t0
    addi t0, x0, 0
    add  t0, t0, t1
    lw   t2, 0(t0)
    sw   t2, -68(x8)
   

    lw   t0, -68(x8)
   

    addi x2, x2, -4
    sw   t0, 0(x2)
   

    addi t0, x0, 5
   

    sw   t0, -72(x8)
   

    lw   t1, -72(x8)
   

    addi t0, x0, 2
    sll  t1, t1, t0
    addi t0, x0, 0
    add  t0, t0, t1
    lw   t2, 0(t0)
    sw   t2, -76(x8)
   

    lw   t0, -76(x8)
   

    addi x2, x2, -4
    sw   t0, 0(x2)
   

    addi x2, x2, -4
    sw   x8, 0(x2)
    addi x2, x2, -4
    sw   x1, 0(x2)
    jal  x1, maximo
    lw   x1, 0(x2)
    lw   x8, 4(x2)
    addi x2, x2, 8
   

    addi x2, x2, 8
    sw   x10, -80(x8)
   

   

    lw   t0, -80(x8)
   

    sw   t0, -84(x8)
   

    addi t0, x0, 1
   

    sw   t0, -88(x8)
   

    lw   t1, -88(x8)
   

    addi t0, x0, 2
    sll  t1, t1, t0
    addi t0, x0, 0
    add  t0, t0, t1
    lw   t2, 0(t0)
    sw   t2, -92(x8)
   

    lw   t0, -92(x8)
   

    addi x2, x2, -4
    sw   t0, 0(x2)
   

    addi t0, x0, 4
   

    sw   t0, -96(x8)
   

    lw   t1, -96(x8)
   

    addi t0, x0, 2
    sll  t1, t1, t0
    addi t0, x0, 0
    add  t0, t0, t1
    lw   t2, 0(t0)
    sw   t2, -100(x8)
   

    lw   t0, -100(x8)
   

    addi x2, x2, -4
    sw   t0, 0(x2)
   

    addi x2, x2, -4
    sw   x8, 0(x2)
    addi x2, x2, -4
    sw   x1, 0(x2)
    jal  x1, distancia
    lw   x1, 0(x2)
    lw   x8, 4(x2)
    addi x2, x2, 8
   

    addi x2, x2, 8
    sw   x10, -104(x8)
   

   

    lw   t0, -104(x8)
   

    sw   t0, -108(x8)
   

    addi t0, x0, 6
   

    sw   t0, -112(x8)
   

    lw   t0, -112(x8)
   

    addi x2, x2, -4
    sw   t0, 0(x2)
   

    addi x2, x2, -4
    sw   x8, 0(x2)
    addi x2, x2, -4
    sw   x1, 0(x2)
    jal  x1, fib
    lw   x1, 0(x2)
    lw   x8, 4(x2)
    addi x2, x2, 8
   

    addi x2, x2, 4
    sw   x10, -116(x8)
   

   

    lw   t0, -116(x8)
   

    sw   t0, -120(x8)
   

    addi t0, x0, 2
   

    sw   t0, -124(x8)
   

    lw   t1, -124(x8)
   

    addi t0, x0, 2
    sll  t1, t1, t0
    addi t0, x0, 0
    add  t0, t0, t1
    lw   t2, 0(t0)
    sw   t2, -128(x8)
   

    lw   t0, -128(x8)
   

    addi x2, x2, -4
    sw   t0, 0(x2)
   

    addi t0, x0, 3
   

    sw   t0, -132(x8)
   

    lw   t1, -132(x8)
   

    addi t0, x0, 2
    sll  t1, t1, t0
    addi t0, x0, 0
    add  t0, t0, t1
    lw   t2, 0(t0)
    sw   t2, -136(x8)
   

    lw   t0, -136(x8)
   

    addi x2, x2, -4
    sw   t0, 0(x2)
   

    addi x2, x2, -4
    sw   x8, 0(x2)
    addi x2, x2, -4
    sw   x1, 0(x2)
    jal  x1, igual
    lw   x1, 0(x2)
    lw   x8, 4(x2)
    addi x2, x2, 8
   

    addi x2, x2, 8
    sw   x10, -140(x8)
   

   

    lw   t0, -140(x8)
   

    sw   t0, -144(x8)
   

    addi t0, x0, 2
   

    sw   t0, -148(x8)
   

    lw   t1, -148(x8)
   

    addi t0, x0, 2
    sll  t1, t1, t0
    addi t0, x0, 0
    add  t0, t0, t1
    lw   t2, 0(t0)
    sw   t2, -152(x8)
   

    lw   t0, -152(x8)
   

    addi x2, x2, -4
    sw   t0, 0(x2)
   

    addi t0, x0, 3
   

    sw   t0, -156(x8)
   

    lw   t1, -156(x8)
   

    addi t0, x0, 2
    sll  t1, t1, t0
    addi t0, x0, 0
    add  t0, t0, t1
    lw   t2, 0(t0)
    sw   t2, -160(x8)
   

    lw   t0, -160(x8)
   

    addi x2, x2, -4
    sw   t0, 0(x2)
   

    addi x2, x2, -4
    sw   x8, 0(x2)
    addi x2, x2, -4
    sw   x1, 0(x2)
    jal  x1, diferente
    lw   x1, 0(x2)
    lw   x8, 4(x2)
    addi x2, x2, 8
   

    addi x2, x2, 8
    sw   x10, -164(x8)
   

   

    lw   t0, -164(x8)
   

    sw   t0, -168(x8)
   

    lw   t0, -44(x8)
   

    sw   t0, -172(x8)
   

    lw   t0, -172(x8)
   

    addi x2, x2, -4
    sw   t0, 0(x2)
   

    addi t0, x0, 5
   

    sw   t0, -176(x8)
   

    lw   t0, -176(x8)
   

    addi x2, x2, -4
    sw   t0, 0(x2)
   

    addi x2, x2, -4
    sw   x8, 0(x2)
    addi x2, x2, -4
    sw   x1, 0(x2)
    jal  x1, resto
    lw   x1, 0(x2)
    lw   x8, 4(x2)
    addi x2, x2, 8
   

    addi x2, x2, 8
    sw   x10, -180(x8)
   

   

    lw   t0, -180(x8)
   

    sw   t0, -184(x8)
   

    lw   t0, -44(x8)
   

    sw   t0, -188(x8)
   

    lw   t0, -188(x8)
   

    addi x2, x2, -4
    sw   t0, 0(x2)
   

    lw   t0, -60(x8)
   

    sw   t0, -192(x8)
   

    lw   t0, -192(x8)
   

    addi x2, x2, -4
    sw   t0, 0(x2)
   

    addi x2, x2, -4
    sw   x8, 0(x2)
    addi x2, x2, -4
    sw   x1, 0(x2)
    jal  x1, mdc
    lw   x1, 0(x2)
    lw   x8, 4(x2)
    addi x2, x2, 8
   

    addi x2, x2, 8
    sw   x10, -196(x8)
   

   

    lw   t0, -196(x8)
   

    sw   t0, -200(x8)
   

    addi t0, x0, 0
   

    sw   t0, -204(x8)
   

    lw   t1, -204(x8)
   

    addi t0, x0, 2
    sll  t1, t1, t0
    addi t0, x0, 24
    add  t0, t0, t1
    lw   t2, 0(t0)
    sw   t2, -208(x8)
   

    lw   t0, -208(x8)
   

    sw   t0, -212(x8)
   

    addi t0, x0, 5
   

    sw   t0, -216(x8)
   

    lw   t1, -216(x8)
   

    addi t0, x0, 2
    sll  t1, t1, t0
    addi t0, x0, 24
    add  t0, t0, t1
    lw   t2, 0(t0)
    sw   t2, -220(x8)
   

    lw   t0, -220(x8)
   

    sw   t0, -224(x8)
   

    lw   t0, -44(x8)
   

    sw   t0, -228(x8)
   

    lw   t0, -228(x8)
   

    addi x2, x2, -4
    sw   t0, 0(x2)
   

    lw   t0, 0(x2)
    addi x2, x2, 4
    sw   t0, 2040(x0)
   

    lw   t0, -60(x8)
   

    sw   t0, -232(x8)
   

    lw   t0, -232(x8)
   

    addi x2, x2, -4
    sw   t0, 0(x2)
   

    lw   t0, 0(x2)
    addi x2, x2, 4
    sw   t0, 2040(x0)
   

    lw   t0, -84(x8)
   

    sw   t0, -236(x8)
   

    lw   t0, -236(x8)
   

    addi x2, x2, -4
    sw   t0, 0(x2)
   

    lw   t0, 0(x2)
    addi x2, x2, 4
    sw   t0, 2040(x0)
   

    lw   t0, -108(x8)
   

    sw   t0, -240(x8)
   

    lw   t0, -240(x8)
   

    addi x2, x2, -4
    sw   t0, 0(x2)
   

    lw   t0, 0(x2)
    addi x2, x2, 4
    sw   t0, 2040(x0)
   

    lw   t0, -120(x8)
   

    sw   t0, -244(x8)
   

    lw   t0, -244(x8)
   

    addi x2, x2, -4
    sw   t0, 0(x2)
   

    lw   t0, 0(x2)
    addi x2, x2, 4
    sw   t0, 2040(x0)
   

    lw   t0, -144(x8)
   

    sw   t0, -248(x8)
   

    lw   t0, -248(x8)
   

    addi x2, x2, -4
    sw   t0, 0(x2)
   

    lw   t0, 0(x2)
    addi x2, x2, 4
    sw   t0, 2040(x0)
   

    lw   t0, -168(x8)
   

    sw   t0, -252(x8)
   

    lw   t0, -252(x8)
   

    addi x2, x2, -4
    sw   t0, 0(x2)
   

    lw   t0, 0(x2)
    addi x2, x2, 4
    sw   t0, 2040(x0)
   

    lw   t0, -184(x8)
   

    sw   t0, -256(x8)
   

    lw   t0, -256(x8)
   

    addi x2, x2, -4
    sw   t0, 0(x2)
   

    lw   t0, 0(x2)
    addi x2, x2, 4
    sw   t0, 2040(x0)
   

    lw   t0, -200(x8)
   

    sw   t0, -260(x8)
   

    lw   t0, -260(x8)
   

    addi x2, x2, -4
    sw   t0, 0(x2)
   

    lw   t0, 0(x2)
    addi x2, x2, 4
    sw   t0, 2040(x0)
   

    lw   t0, -212(x8)
   

    sw   t0, -264(x8)
   

    lw   t0, -264(x8)
   

    addi x2, x2, -4
    sw   t0, 0(x2)
   

    lw   t0, 0(x2)
    addi x2, x2, 4
    sw   t0, 2040(x0)
   

    lw   t0, -224(x8)
   

    sw   t0, -268(x8)
   

    lw   t0, -268(x8)
   

    addi x2, x2, -4
    sw   t0, 0(x2)
   

    lw   t0, 0(x2)
    addi x2, x2, 4
    sw   t0, 2040(x0)
   

# ---- fim de main ----
    addi x2, x8, 0
    jalr x0, x1, 0
   


