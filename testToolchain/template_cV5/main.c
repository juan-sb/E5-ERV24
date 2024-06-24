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

// volatile uint8_t *const GPIO_PDOR = (volatile uint8_t *)(GPIO_BASE + GPIO_OFF_PDOR);
// volatile uint8_t *const GPIO_PDDR = (volatile uint8_t *)(GPIO_BASE + GPIO_OFF_PDDR);

int global_variable = 14, asd1, asd2, asd3 = 22;

int global_noinit;

int main()
{
    GPIO_PDDR = 0xFF; // Configurar GPIO como salida
    GPIO_PDOR = 0x00; // Todo el GPIO en 0

    int local_noinit;
    int local_init = 15;

    global_noinit = 7;

    int local_variable_a = 0, local_variable_b = 3;

    uint64_t testing64 = 8;
    float testingFloat1 = 3.14, testingFloat2 = 0.0;

    testing64 += local_variable_a;

    local_variable_a = local_variable_b * 5;

    testingFloat2 += 3.14 * 1.4142;

    testingFloat1 = local_variable_a * testingFloat2;

    testingFloat2 = testingFloat1 / 3;

    local_variable_a = global_variable;
    global_variable = local_variable_b;

    while (1)
    {
        __asm__ volatile("nop");
    }

    return 0;
}
