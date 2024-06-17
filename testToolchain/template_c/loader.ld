/* Thanks https://github.com/darklife/darkriscv */
__heap_size     = 0x200;  /* required amount of heap */
__stack_size    = 0x800;  /* required amount of stack */

ENTRY( _start )

MEMORY
{
    ROM (x!rw) : ORIGIN = 0x00000000, LENGTH = 0x400    /* 0x400 <-> 1kBy */
    RAM (rw!x) : ORIGIN = 0x00000500, LENGTH = 0x2000   /* 0x2000 <-> 8kBy */
}
SECTIONS
{
    .text :
    {
        *_start*.o(.text)
        *(.text*)
        *(.rodata*)
    } > ROM

    .data :
    {
        
        *(.data)
        *(.sdata)
        *(.bss)
        *(.sbss)
        *(.rela*)
        *(COMMON)
    } > RAM

    .stack :
    {
        . = ALIGN(4);
        _estack = .;
        . = . + __stack_size;
        . = ALIGN(4);
        _sstack = .;
    } >RAM

    PROVIDE ( _stack = ORIGIN(RAM) + LENGTH(RAM) );
}
                        