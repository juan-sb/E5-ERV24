.globl _boot
.section .text

_boot:
    li      sp, 0x400          # allocate space for stack
    call    main
    ebreak
