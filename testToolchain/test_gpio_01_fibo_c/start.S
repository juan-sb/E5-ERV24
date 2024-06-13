.globl _boot
.section .text

.equ RAM_BASE, 0x00010000
.equ STACK_SIZE, 0x800

_boot:
    # Configurar stack
    lui     sp, %hi(RAM_BASE + STACK_SIZE)
    addi    sp, sp, %lo(RAM_BASE + STACK_SIZE)

    # Llamar a main
    call    main

    # Bucle infinito después de main
loop:
    j loop

.section .data
