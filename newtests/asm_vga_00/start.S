.globl _boot
.section .text

.equ GPIO_BASE, 0x40000
.equ GPIO_OFF_PDOR, 0x0
.equ GPIO_OFF_PSOR, 0x1
.equ GPIO_OFF_PCOR, 0x2
.equ GPIO_OFF_PTOR, 0x3
.equ GPIO_OFF_PDIR, 0x4
.equ GPIO_OFF_PDDR, 0x5

.equ UART_BASE, 0x48000
.equ UART_OFF_TXR, 0x0
.equ UART_OFF_RXR, 0x1
.equ UART_OFF_CTR, 0x2  # [x x x x rxrst txrst rxen txen]

.equ VGA_BASE, 0x50000
.equ VGA_OFF_C_FG, 0x0
.equ VGA_OFF_C_BG, 0x1
.equ VGA_OFF_I_WX, 0x2
.equ VGA_OFF_I_HY, 0x4

_boot:
    lui     t0, GPIO_BASE
    addi    t1, zero, 0xFF
    addi    t2, zero, 0x55

    sb      t1, GPIO_OFF_PDDR(t0)
    sb      t2, GPIO_OFF_PDOR(t0)

    lui     t2, VGA_BASE

    li      t3, 0xFCF0FFF0 #  fondo blanco, foreground azul, ancho maximo, top left en X
    sw      t3, VGA_OFF_C_FG(t2)

    li      t3, 0xFCF0      # alto maximo, top left en Y
    sh      t3, VGA_OFF_I_HY(t2)


    # addi    t3, zero, 0b11100000 # RED
    # sb      t3, VGA_OFF_C_FG(t2)

    # addi    t3, zero, 0b00011100 # VERDE
    # sb      t3, VGA_OFF_C_BG(t2)

    # li      t3, 0b1111110000000000 # 111111 0100000000, 15 de ancho, 0 de coordenada x
    # sh      t3, VGA_OFF_I_WX(t2)

    # li      t3, 0b1111110000000000 # 111111 0100000000, 15 de alto, 0 de coordenada y
    # sh      t3, VGA_OFF_I_HY(t2)

    lb      t4, VGA_OFF_C_FG(t2)    # lectura de foreground escrito
    sb      t4, GPIO_OFF_PDOR(t0)   # escritura de foreground en GPIOs (LED)
    
loop:   j   loop

.section .data
