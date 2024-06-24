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

int global1;
int global2 = 3;

int main()
{
    GPIO_PDDR = 0xFF; // Configurar GPIO como salida
    GPIO_PDOR = 0x00; // Todo el GPIO en 0

    int local1;
    int local2 = 15;

    global1 = 7;
    local1 = 12;

    float localfloat = 1.4142;

    while (1)
    {
        __asm__ volatile("nop");
    }

    return 0;
}
