.globl _boot
.section .text

.equ DELAY, 50000

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

    addi    t2, zero, 0x1                   # t2 en 0x1 (bit inicial)
    addi    t3, zero, 0x1                   # t3 en 0x1 (contador de delay)
    addi    t5, zero, 0x0                   # t5 para indicar dirección, 0 a izq, 1 a der
    addi    a1, zero, 0x0
    li      t4, DELAY

loop:
    nop
    addi    t3, t3, 0x1
    nop
    bne     t3, t4, loop

    sb      t2, GPIO_OFF_PDOR(t0)           # Escribir t2 al GPIO

    # Cambiar dirección si alcanza el bit 7 o bit 0
    andi    a1, t2, 0x80                    # Chequear si t2 es 0x80 (bit 7)
    nop
    bne    a1, zero, change_dir_right            # Si es 0x80, cambia a derecha
    nop
    andi    a1, t2, 0x00                    # Chequear si t2 es 0x01 (bit 0)
    nop
    bne    a1, zero, change_dir_left             # Si es 0x01, cambia a izquierda
    nop

shift:
    bne    t5, zero, shift_right                 # Si t5 es 0, shift izquierda
    nop
    sll     t2, t2, 1                       # Shift izquierda
    j       update

shift_right:
    nop
    srl     t2, t2, 1                       # Shift derecha
    nop

update:
    addi    t3, zero, 0x1                   # Reset contador de delay
    j       loop

change_dir_left:
    addi    t5, zero, 0x0                   # Cambiar dirección a izquierda
    j       shift

change_dir_right:
    addi    t5, zero, 0x1                   # Cambiar dirección a derecha
    j       shift

.section .data
