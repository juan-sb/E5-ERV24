#define GPIO_BASE 0x40000
#define GPIO_OFF_PDOR 0x0
#define GPIO_OFF_PDDR 0x5

#define DELAY 100000

volatile unsigned char *gpio_pdor = (unsigned char *)(GPIO_BASE + GPIO_OFF_PDOR);
volatile unsigned char *gpio_pddr = (unsigned char *)(GPIO_BASE + GPIO_OFF_PDDR);

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
    *gpio_pdor = 0x00;

    unsigned char fib_n_minus_1 = 1; // Fibonacci n-1
    unsigned char fib_n = 1;         // Fibonacci n

    while (1)
    {
        delay(DELAY);

        // Reflejar Fibonacci actual en el GPIO
        *gpio_pdor = fib_n;

        // Calcular siguiente número de Fibonacci
        unsigned char next_fib = fib_n_minus_1 + fib_n;
        fib_n_minus_1 = fib_n;
        fib_n = next_fib;
    }

    return 0;
}
