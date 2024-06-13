/* Thanks https://github.com/darklife/darkriscv */
__heap_size     = 0x200;  /* required amount of heap */
__stack_size    = 0x800;  /* required amount of stack */

MEMORY
{
    ROM (rwx) : ORIGIN = 0x00000000, LENGTH = 0x02000
    RAM (rwx) : ORIGIN = 0x00010000, LENGTH = 0x02000
}
SECTIONS
{
    .text :
    {
        . = ALIGN(4);
        start.o (.text)
        *(.text)
        *(.rodata*)
    } > ROM

    .data :
    {
        
        *(.data)
        *(.bss)
        *(.sbss)
        *(COMMON)
    } > RAM

    .heap :
    {
        . = ALIGN(4);
        PROVIDE ( end = . );
        _sheap = .;
        . = . + __heap_size;
        . = ALIGN(4);
        _eheap = .;
    } >RAM

    .stack :
    {
        . = ALIGN(4);
        _estack = .;
        . = . + __stack_size;
        . = ALIGN(4);
        _sstack = .;
    } >RAM
}
                        