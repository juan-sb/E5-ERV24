OUTPUT_ARCH("riscv")

ENTRY(_enter)

MEMORY
{
    ram (arw!xi) : ORIGIN = 0x00002000, LENGTH = 0x2000
    rom (irx!wa) : ORIGIN = 0x00000000, LENGTH = 0x2000
}

PHDRS
{
    rom PT_LOAD;
    ram_init PT_LOAD;
    tls PT_TLS;
    ram PT_LOAD;
    text PT_LOAD;
}

SECTIONS
{
    __stack_size = DEFINED(__stack_size) ? __stack_size : 0x400;
    PROVIDE(__stack_size = __stack_size);

    __heap_size = DEFINED(__heap_size) ? __heap_size : 0x800;

    PROVIDE(__metal_boot_hart = 0);
    PROVIDE(__metal_chicken_bit = 1);
    PROVIDE(__metal_eccscrub_bit = 0);

    PROVIDE(metal_dtim_0_memory_start = 0x80000000);
    PROVIDE(metal_dtim_0_memory_end = 0x80000000 + 0x4000);

    .init : {
        KEEP (*(.text.metal.init.enter))
        KEEP (*(.text.metal.init.*))
        KEEP (*(SORT_NONE(.init)))
        KEEP (*(.text.libgloss.start))
    } >rom :rom

    .fini : {
        KEEP (*(SORT_NONE(.fini)))
    } >rom :rom

    .preinit_array : ALIGN(8) {
        PROVIDE_HIDDEN (__preinit_array_start = .);
        KEEP (*(.preinit_array))
        PROVIDE_HIDDEN (__preinit_array_end = .);
    } >rom :rom

    .init_array : ALIGN(8) {
        PROVIDE_HIDDEN (__init_array_start = .);
        KEEP (*(SORT_BY_INIT_PRIORITY(.init_array.*) SORT_BY_INIT_PRIORITY(.ctors.*)))
        KEEP (*(.init_array EXCLUDE_FILE (*crtbegin.o *crtbegin?.o *crtend.o *crtend?.o ) .ctors))
        PROVIDE_HIDDEN (__init_array_end = .);
        PROVIDE_HIDDEN ( metal_constructors_start = .);
        KEEP (*(SORT_BY_INIT_PRIORITY(.metal.init_array.*)));
        KEEP (*(.metal.init_array));
        PROVIDE_HIDDEN ( metal_constructors_end = .);
    } >rom :rom

    .fini_array : ALIGN(8) {
        PROVIDE_HIDDEN (__fini_array_start = .);
        KEEP (*(SORT_BY_INIT_PRIORITY(.fini_array.*) SORT_BY_INIT_PRIORITY(.dtors.*)))
        KEEP (*(.fini_array EXCLUDE_FILE (*crtbegin.o *crtbegin?.o *crtend.o *crtend?.o ) .dtors))
        PROVIDE_HIDDEN (__fini_array_end = .);
        PROVIDE_HIDDEN ( metal_destructors_start = .);
        KEEP (*(SORT_BY_INIT_PRIORITY(.metal.fini_array.*)));
        KEEP (*(.metal.fini_array));
        PROVIDE_HIDDEN ( metal_destructors_end = .);
    } >rom :rom

    .ctors : {
        KEEP (*crtbegin.o(.ctors))
        KEEP (*crtbegin?.o(.ctors))
        KEEP (*(EXCLUDE_FILE (*crtend.o *crtend?.o ) .ctors))
        KEEP (*(SORT(.ctors.*)))
        KEEP (*(.ctors))
        KEEP (*(.metal.ctors .metal.ctors.*))
    } >rom :rom

    .dtors : {
        KEEP (*crtbegin.o(.dtors))
        KEEP (*crtbegin?.o(.dtors))
        KEEP (*(EXCLUDE_FILE (*crtend.o *crtend?.o ) .dtors))
        KEEP (*(SORT(.dtors.*)))
        KEEP (*(.dtors))
        KEEP (*(.metal.dtors .metal.dtors.*))
    } >rom :rom

    .rodata : {
        *(.rdata)
        *(.rodata .rodata.*)
        *(.gnu.linkonce.r.*)
        . = ALIGN(8);
        *(.srodata.cst16)
        *(.srodata.cst8)
        *(.srodata.cst4)
        *(.srodata.cst2)
        *(.srodata .srodata.*)
    } >rom :rom

    .text : {
        *(.text.unlikely .text.unlikely.*)
        *(.text.startup .text.startup.*)
        *(.text .text.*)
        *(.gnu.linkonce.t.*)
    } >rom :text

    .data : ALIGN(8) {
        *(.data .data.*)
        *(.gnu.linkonce.d.*)
        . = ALIGN(8);
        PROVIDE( __global_pointer$ = . + 0x800 );
        *(.sdata .sdata.* .sdata2.*)
        *(.gnu.linkonce.s.*)
    } >ram AT>rom :ram_init

    .tdata : ALIGN(8) {
        PROVIDE( __tls_base = . );
        *(.tdata .tdata.* .gnu.linkonce.td.*)
    } >ram AT>rom :tls :ram_init

    PROVIDE( __tdata_source = LOADADDR(.tdata) );
    PROVIDE( __tdata_size = SIZEOF(.tdata) );

    PROVIDE( metal_segment_data_source_start = LOADADDR(.data) );
    PROVIDE( metal_segment_data_target_start = ADDR(.data) );
    PROVIDE( metal_segment_data_target_end = ADDR(.tdata) + SIZEOF(.tdata) );

    .tbss : ALIGN(8) {
        *(.tbss .tbss.* .gnu.linkonce.tb.*)
        *(.tcommon .tcommon.*)
        PROVIDE( __tls_end = . );
    } >ram AT>ram :tls :ram

    PROVIDE( __tbss_size = SIZEOF(.tbss) );
    PROVIDE( __tls_size = __tls_end - __tls_base );

    .tbss_space : ALIGN(8) {
        . = . + __tbss_size;
    } >ram :ram

    .bss (NOLOAD): ALIGN(8) {
        *(.sbss*)
        *(.gnu.linkonce.sb.*)
        *(.bss .bss.*)
        *(.gnu.linkonce.b.*)
        *(COMMON)
    } >ram :ram

    PROVIDE( metal_segment_bss_source_start = LOADADDR(.tbss) );
    PROVIDE( metal_segment_bss_target_start = ADDR(.tbss) );
    PROVIDE( metal_segment_bss_target_end = ADDR(.bss) + SIZEOF(.bss) );

    .stack (NOLOAD) : ALIGN(16) {
        PROVIDE(metal_segment_stack_begin = .);
        . += __stack_size; /* Hart 0 */
        PROVIDE( _sp = . );
        PROVIDE(metal_segment_stack_end = .);
    } >ram :ram

    .heap (NOLOAD) : ALIGN(8) {
        PROVIDE( __end = . );
        PROVIDE( __heap_start = . );
        PROVIDE( metal_segment_heap_target_start = . );
        . = DEFINED(__heap_max) ? MIN( LENGTH(ram) - ( . - ORIGIN(ram)) , 0x10000000) : __heap_size;
        PROVIDE( metal_segment_heap_target_end = . );
        PROVIDE( _heap_end = . );
        PROVIDE( __heap_end = . );
    } >ram :ram

    /DISCARD/ : {
        *(.eh_frame .eh_frame.*)
    }
}
