# Nombres de los archivos fuente y objeto
ASM_FILE = start.S
SRC_FILE = main.c
ASM_OBJ_FILE = start.o
OBJ_FILE = main.o
ELF_FILE = main.elf
HEX_FILE = main.hex
LINKER_SCRIPT = loader.ld

# Comandos de compilación
AS = riscv32-unknown-elf-as
CC = riscv32-unknown-elf-gcc
LD = riscv32-unknown-elf-ld
ELF2HEX = riscv32-unknown-elf-elf2hex

# Opciones de compilación y vinculación
CFLAGS = -r
LDFLAGS = -T $(LINKER_SCRIPT) -m elf32lriscv -nostdlib --no-relax
ELF2HEXFLAGS = --bit-width 32 --input $(ELF_FILE) --output $(HEX_FILE)

# Regla por defecto
all: $(HEX_FILE)

# Regla para ensamblar start.S
$(ASM_OBJ_FILE): $(ASM_FILE)
	$(AS) $< -o $@

# Regla para compilar main.c
$(OBJ_FILE): $(SRC_FILE)
	$(CC) $(CFLAGS) $< -o $@

# Regla para enlazar los archivos objeto
$(ELF_FILE): $(ASM_OBJ_FILE) $(OBJ_FILE)
	$(LD) $(ASM_OBJ_FILE) $(OBJ_FILE) -o $@ $(LDFLAGS)

# Regla para generar el archivo hexadecimal
$(HEX_FILE): $(ELF_FILE)
	$(ELF2HEX) $(ELF2HEXFLAGS)

# Limpiar archivos generados
clean:
	rm -f $(ASM_OBJ_FILE) $(OBJ_FILE) $(ELF_FILE) $(HEX_FILE)

.PHONY: all clean
