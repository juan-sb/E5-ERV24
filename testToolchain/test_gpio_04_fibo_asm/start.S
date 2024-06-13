.globl _boot
.section .text

.equ DELAY, 100000

.equ GPIO_BASE, 0x40000
.equ GPIO_OFF_PDOR, 0x0
.equ GPIO_OFF_PSOR, 0x1
.equ GPIO_OFF_PCOR, 0x2
.equ GPIO_OFF_PTOR, 0x3
.equ GPIO_OFF_PDIR, 0x4
.equ GPIO_OFF_PDDR, 0x5

_boot:
    lui     t0, GPIO_BASE

    addi    t1, zero, 0xFF
    sb      t1, GPIO_OFF_PDDR(t0)           # GPIO[7..0] como salida
    sb      zero, GPIO_OFF_PDOR(t0)         # Todos apagados

    addi    t3, zero, 0x1                   # t3 en 0x1 (contador de delay)
    li      t4, DELAY

    addi    t5, zero, 0x1                   # Fibonacci n-1
    addi    a0, zero, 0x1                   # Fibonacci n

loop:
    nop
    addi    t3, t3, 0x1
    bne     t3, t4, loop

    sb      a0, GPIO_OFF_PDOR(t0)           # Escribir Fibonacci actual al GPIO

    # Calcular siguiente número de Fibonacci
    add     a1, t5, a0                      # a1 = Fibonacci n-1 + Fibonacci n
    addi    t5, a0, 0                       # Actualizar Fibonacci n-1
    addi    a0, a1, 0                       # Actualizar Fibonacci n

    addi    t3, zero, 0x1                   # Reset contador de delay
    j       loop

.section .data
