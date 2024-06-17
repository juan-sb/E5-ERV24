MEMORY
{
        ROM (x!rw) : ORIGIN = 0x00000000, LENGTH = 0x400
        RAM (rw!x) : ORIGIN = 0x0000500, LENGTH = 0x2000
}
SECTIONS
{
    .text :
    {
        *boot*.o(.text)
        _text = .;
        *(.text*)
        _etext = .;
    } > ROM
    .data :
    {
        *boot*.o(.rodata)
        _data = .;
        *(.rodata*)
        *(.data*)
        _global = . + 0x800;
        *(.sbss*)
        *(.bss*)
        *(.sdata*)
        *(.*)
     _edata = .;
    } > RAM
   PROVIDE ( _stack = ORIGIN(RAM) + LENGTH(RAM) );
}
