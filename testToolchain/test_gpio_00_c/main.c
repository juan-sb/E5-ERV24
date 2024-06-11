int main()
{
    int anumber = 5;
    int another = 30;

    int result = anumber + another;

    // Acceder al GPIO
    volatile unsigned char *gpio_base = (unsigned char *)0x40000000; // Dirección base del GPIO
    volatile unsigned char *pdor = gpio_base + 0x0;              // Registro PDOR del GPIO
    volatile unsigned char *pddr = gpio_base + 0x5;

    // Encender un bit en el registro PDOR
    // *pdor |= (1 << 0); // Encender el primer bit del GPIO

    *pddr = 0xFF;
    *pdor = 0b10010011;

    return 0;
}
