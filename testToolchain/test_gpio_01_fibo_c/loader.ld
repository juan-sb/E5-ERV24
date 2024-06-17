/* Thanks https://github.com/darklife/darkriscv */
__heap_size     = 0x200;  /* required amount of heap */
__stack_size    = 0x800;  /* required amount of stack */

MEMORY
{
    ROM (x!rw) : ORIGIN = 0x00000000, LENGTH = 0x02000
    RAM (rw!x) : ORIGIN = 0x00002000, LENGTH = 0x02000
}
SECTIONS
{
    .text :
    {
        *start*.o(.text)
        *(.text*)
        *(.rodata*)
    } > ROM

    .data :
    {
        
        *(.data)
        *(.bss)
        *(.sbss)
        *(.rela*)
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
                        