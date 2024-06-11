# test_gpio_00_asm
# Prende LEDs 7 a 1, configurando GPIO[7..1] como salida (PDDR) y escribiendo 0xFE al PDOR

.globl _boot
.section .text

.equ GPIO_BASE, 0x40000
.equ GPIO_OFF_PDOR, 0x0
.equ GPIO_OFF_PSOR, 0x1
.equ GPIO_OFF_PCOR, 0x2
.equ GPIO_OFF_PTOR, 0x3
.equ GPIO_OFF_PDIR, 0x4
.equ GPIO_OFF_PDDR, 0x5

_boot:
    lui     t0, GPIO_BASE
    addi    t1, zero, 0xFE

    sb      t1, GPIO_OFF_PDDR(t0)
    sb      t1, GPIO_OFF_PDOR(t0)

loop:   j   loop

.section .data
