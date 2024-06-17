# Nombres de los archivos fuente y objeto
SRC_FILES = main.c startup.c utils.c #timer.c
OBJ_FILES = main.o startup.o utils.o #timer.o
ELF_FILE = main.elf
BIN_FILE = main.bin
HEX_FILE = main.hex
ASM_FILES = main.s startup.s utils.s #timer.s
LIST_FILE = main.lst
MAP_FILE = main.map
LINKER_SCRIPT = linker.ld

# Comandos de compilación
CC = riscv32-unknown-elf-gcc
LD = riscv32-unknown-elf-ld
OBJCOPY = riscv32-unknown-elf-objcopy
OBJDUMP = riscv32-unknown-elf-objdump

# Opciones de compilación y vinculación
CFLAGS = -march=rv32i -mabi=ilp32 -O0 -g -Wall -ffreestanding -nostartfiles
LDFLAGS = -T $(LINKER_SCRIPT) -m elf32lriscv -Map=$(MAP_FILE) -nostdlib --no-relax # -L="/opt/riscv/lib/gcc/riscv32-unknown-elf/13.2.0" -lgcc
OBJCOPYFLAGS = -O binary

# Regla por defecto
all: $(HEX_FILE) $(LIST_FILE) $(MAP_FILE)

# Regla para compilar los archivos .c a .o
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# Regla para generar los archivos .s a partir de los archivos .c
%.s: %.c
	$(CC) $(CFLAGS) -S $< -o $@

# Regla para enlazar los archivos objeto
$(ELF_FILE): $(OBJ_FILES)
	$(LD) $(OBJ_FILES) -o $@ $(LDFLAGS)

# Regla para generar el archivo binario a partir del ELF
$(BIN_FILE): $(ELF_FILE)
	$(OBJCOPY) $(OBJCOPYFLAGS) $< $@

# Regla para generar el archivo hexadecimal a partir del binario
$(HEX_FILE): $(BIN_FILE)
	hexdump -e '"%08x\n"' $< > $@

# Regla para generar el ensamblado intermedio de los archivos .c
asm: $(ASM_FILES)

# Regla para generar el archivo .lst
$(LIST_FILE): $(ELF_FILE)
	$(OBJDUMP) -S $< > $@

# Regla para generar el archivo .map
$(MAP_FILE): $(ELF_FILE)

# Regla de ayuda
help:
	@echo "Comandos disponibles:"
	@echo "  all:                 Compila todo y genera los archivos $(HEX_FILE), $(LIST_FILE) y $(MAP_FILE)."
	@echo "  clean:               Limpia todos los archivos generados."
	@echo "  asm:                 Genera los archivos ensamblador intermedios para cada archivo fuente."

# Limpiar archivos generados
clean:
	rm -f $(OBJ_FILES) $(ELF_FILE) $(BIN_FILE) $(HEX_FILE) $(ASM_FILES) $(LIST_FILE) $(MAP_FILE)

.PHONY: all clean help asm
