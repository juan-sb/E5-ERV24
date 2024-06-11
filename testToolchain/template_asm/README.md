# exasm02

## `loader.ld`

> explanation by chatgpt

Este es un script de vinculación (linker script) utilizado para definir la disposición de las diferentes secciones del programa en la memoria de un sistema embebido basado en la arquitectura RISC-V. Aquí está la explicación detallada de cada parte del script:

### Definición de tamaño de pila y montón

```c
__heap_size     = 0x200;  /* required amount of heap */
__stack_size    = 0x800;  /* required amount of stack */
```
- `__heap_size` define el tamaño del montón (heap) en 0x200 bytes (512 bytes).
- `__stack_size` define el tamaño de la pila (stack) en 0x800 bytes (2048 bytes).

### Definición de la memoria

```c
MEMORY
{
    ROM (rwx) : ORIGIN = 0x00000000, LENGTH = 0x02000
    RAM (rwx) : ORIGIN = 0x00010000, LENGTH = 0x02000
}
```
- **ROM**:
  - `ORIGIN = 0x00000000`: Comienza en la dirección 0x00000000.
  - `LENGTH = 0x02000`: Tiene una longitud de 0x02000 bytes (8 KB).
  - `rwx`: Indicando que puede ser de lectura, escritura y ejecución.
- **RAM**:
  - `ORIGIN = 0x00010000`: Comienza en la dirección 0x00010000.
  - `LENGTH = 0x02000`: Tiene una longitud de 0x02000 bytes (8 KB).
  - `rwx`: Indicando que puede ser de lectura, escritura y ejecución.

### Definición de las secciones del programa

```c
SECTIONS
{
    .text :
    {
        *(.text)
        *(.rodata*)
    } > ROM

    .data :
    {
        *(.data)
        *(.bss)
        *(.sbss)
        *(COMMON)
    } > RAM

    .heap :
    {
        . = ALIGN(4);
        PROVIDE ( end = . );
        _sheap = .;
        . = . + __heap_size;
        . = ALIGN(4);
        _eheap = .;
    } >RAM

    .stack :
    {
        . = ALIGN(4);
        _estack = .;
        . = . + __stack_size;
        . = ALIGN(4);
        _sstack = .;
    } >RAM
}
```

#### Sección `.text`

```c
.text :
{
    *(.text)
    *(.rodata*)
} > ROM
```
- La sección `.text` se ubica en la región `ROM`.
- Incluye las secciones:
  - `.text`: Contiene el código ejecutable del programa.
  - `.rodata*`: Contiene datos de solo lectura, como literales de cadenas y constantes.

#### Sección `.data`

```c
.data :
{
    *(.data)
    *(.bss)
    *(.sbss)
    *(COMMON)
} > RAM
```
- La sección `.data` se ubica en la región `RAM`.
- Incluye las secciones:
  - `.data`: Contiene variables inicializadas.
  - `.bss`: Contiene variables no inicializadas.
  - `.sbss`: Contiene variables no inicializadas en pequeñas secciones.
  - `COMMON`: Sección común utilizada para variables globales no inicializadas.

#### Sección `.heap`

```c
.heap :
{
    . = ALIGN(4);
    PROVIDE ( end = . );
    _sheap = .;
    . = . + __heap_size;
    . = ALIGN(4);
    _eheap = .;
} >RAM
```
- Define el área de memoria para el montón (heap) en la región `RAM`.
- Alinea el inicio de la sección a una dirección múltiplo de 4.
- `PROVIDE (end = .)`: Define `end` como la dirección actual.
- `_sheap = .;`: Marca el inicio del montón.
- `. = . + __heap_size;`: Incrementa la dirección actual por `__heap_size`.
- `_eheap = .;`: Marca el final del montón.

#### Sección `.stack`

```c
.stack :
{
    . = ALIGN(4);
    _estack = .;
    . = . + __stack_size;
    . = ALIGN(4);
    _sstack = .;
} >RAM
```
- Define el área de memoria para la pila (stack) en la región `RAM`.
- Alinea el inicio de la sección a una dirección múltiplo de 4.
- `_estack = .;`: Marca el inicio de la pila.
- `. = . + __stack_size;`: Incrementa la dirección actual por `__stack_size`.
- `_sstack = .;`: Marca el final de la pila.

### Resumen

Este script de vinculación organiza las diferentes secciones del programa en las regiones de memoria `ROM` y `RAM`, asegurando que el código, los datos y las áreas de pila y montón se ubiquen correctamente. Esto es esencial para el correcto funcionamiento de programas embebidos en sistemas con recursos de memoria limitados.