# test_gpio_02_asm
# for-loop para setear los pines GPIO uno por uno.

.globl _boot
.section .text

.equ N, 8

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

    addi    t2, zero, 0x1                   # t2 en 0x1

for_loop:
    sb      t2, GPIO_OFF_PDOR(t0)           # Refleja t2 en GPIO[7..0]

    slli    t2, t2, 1
    addi    t3, zero, N
    bne     t3, zero, for_loop

    j       loop

loop:   j   loop

.section .data
