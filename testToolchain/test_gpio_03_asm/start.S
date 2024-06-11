# test_gpio_03_asm
# Toggle GPIO[0] cada N iteraciones bloqueantes.

.globl _boot
.section .text

.equ N, 10000000

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

    addi    t2, zero, 0x81                  # t2 en 0x1
    addi    t3, zero, 0x1                   # t3 en 0x1
    li      t4, N

loop:
    addi    t3, t3, 0x1
    bne     t3, t4, loop

    sb      t2, GPIO_OFF_PDOR(t0)           # t2 a GPIO[0]
    
    xori    t2, t2, 0x1                     # Toggle t2[0]
    addi    t3, zero, 0x1                   # Reset t3

    j       loop

.section .data
