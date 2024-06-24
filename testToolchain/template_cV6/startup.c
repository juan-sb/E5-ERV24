#include <stdint.h>
#include <string.h>
#include "utils.h"

typedef void (*function_t)(void);

extern uint8_t metal_segment_bss_target_start;
extern uint8_t metal_segment_bss_target_end;
extern const uint8_t metal_segment_data_source_start;
extern uint8_t metal_segment_data_target_start;
extern uint8_t metal_segment_data_target_end;

extern void _enter(void) __attribute__((naked, section(".text.metal.init.enter")));

extern void _start(void) __attribute__((noreturn));
void _Exit(int exit_code) __attribute__((noreturn, noinline));

extern int main(void);

void _enter(void)
{
    __asm__ volatile(
        ".option push;"
        ".option norelax;"
        "la gp, __global_pointer$;"
        "la sp, _sp;"
        ".option pop;"
        "j _start;"
    );
}

void _start(void)
{
    // Initialize .data section
    memcpy(&metal_segment_data_target_start, &metal_segment_data_source_start,
           &metal_segment_data_target_end - &metal_segment_data_target_start);

    // Zero .bss section
    memset(&metal_segment_bss_target_start, 0,
           &metal_segment_bss_target_end - &metal_segment_bss_target_start);

    // Call main
    int ret = main();

    _Exit(ret);
}

void _Exit(int exit_code)
{
    while (1)
    {
        // Infinite loop to hang the program
    }
}
