#define GPIO_BASE 0x40000
#define GPIO_OFF_PDOR 0x0
#define GPIO_OFF_PDDR 0x5

#define DELAY 12500000

#define RED 0b11100000
#define GREEN 0b00011100
#define BLUE 0b00000011

volatile unsigned char *gpio_pdor = (unsigned char *)(GPIO_BASE + GPIO_OFF_PDOR);
volatile unsigned char *gpio_pddr = (unsigned char *)(GPIO_BASE + GPIO_OFF_PDDR);
volatile int count = 0;

void delay(volatile int count)
{
    while (count--)
    {
        __asm__ volatile("nop");
    }
}

int main()
{
    // Configurar GPIO como salida
    *gpio_pddr = 0xFF;

    // GPIO todo en 0
    *gpio_pdor = 0x00;

    // unsigned char fib_n_minus_1 = 1; // Fibonacci n-1
    // unsigned char fib_n = 1;         // Fibonacci n

    while (1)
    {
        *gpio_pdor = RED;
        // delay(DELAY);

        while (count--)
        {
            __asm__ volatile("nop");
        }

        *gpio_pdor = GREEN;
        // delay(DELAY);

        while (count--)
        {
            __asm__ volatile("nop");
        }

        *gpio_pdor = BLUE;
        // delay(DELAY);

        while (count--)
        {
            __asm__ volatile("nop");
        }
    }

    return 0;
}
