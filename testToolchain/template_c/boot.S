.globl _start
.section .text

.equ RAM_BASE, 0x00001000
.equ STACK_SIZE, 0x800

_start:
    la      sp, _stack      # setup stack
    # la      gp, _global

    call    main

    j       _start
    