#include <stdint.h>

#define GPIO_BASE 0x40000000 // Base offset for GPIO peripheral
#define GPIO_OFF_PDOR 0x0
#define GPIO_OFF_PSOR 0x1
#define GPIO_OFF_PCOR 0x2
#define GPIO_OFF_PTOR 0x3
#define GPIO_OFF_PDIR 0x4
#define GPIO_OFF_PDDR 0x5

#define GPIO_PDOR (*(volatile uint8_t *)(GPIO_BASE + GPIO_OFF_PDOR))
#define GPIO_PDDR (*(volatile uint8_t *)(GPIO_BASE + GPIO_OFF_PDDR))

int global_variable = 14, asd1, asd2, asd3 = 22;

int main()
{
    GPIO_PDDR = 0xFF; // Configurar GPIO como salida
    GPIO_PDOR = 0x00; // Todo el GPIO en 0

    int local_variable_a = 0, local_variable_b = 3;

    local_variable_a = global_variable;
    global_variable = local_variable_b;

    while (1)
    {
        __asm__ volatile("nop");
    }

    return 0;
}
