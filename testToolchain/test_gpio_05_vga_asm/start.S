# test_gpio_00_asm
# Prende LEDs 7 a 1, configurando GPIO[7..1] como salida (PDDR) y escribiendo 0xFE al PDOR

.globl _boot
.section .text

# .equ DELAY, 12500000
.equ DELAY, 12500000

.equ RED, 0xE0
.equ GREEN, 0x1C
.equ BLUE, 0x3

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
    addi    a0, zero, RED
    addi    a1, zero, GREEN
    addi    a2, zero, BLUE
    addi    t2, zero, 0
    li      t3, DELAY

    sb      t1, GPIO_OFF_PDDR(t0)

    sb      a0, GPIO_OFF_PDOR(t0)
loopred:
    addi    t2, t2, 0x1
    bne     t2, t3, loopred

    addi    t2, zero, 0

    sb      a1, GPIO_OFF_PDOR(t0)
loopgreen:
    addi    t2, t2, 0x1
    bne     t2, t3, loopgreen

    addi    t2, zero, 0

    sb      a2, GPIO_OFF_PDOR(t0)
loopblue:
    addi    t2, t2, 0x1
    bne     t2, t3, loopblue

    addi    t2, zero, 0

    sb      a0, GPIO_OFF_PDOR(t0)
    j   loopred

.section .data
