# test_gpio_01_asm
# Guarda dos valores en registros, los suma y muestra el resultado en GPIO.

.globl _boot
.section .text

.equ N1, 128
.equ N2, 15

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

    addi    a0, zero, N1                    # Guarda N1 en a0
    addi    a1, zero, N2                    # Guarda N2 en a1

    add     a2, a1, a0                      # Guarda a1+a0 en a2

    sb      a2, GPIO_OFF_PDOR(t0)           # Refleja a2 en GPIO[7..0]

loop:   j   loop

.section .data
