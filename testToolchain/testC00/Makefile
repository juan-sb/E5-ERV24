# Nombres de los archivos fuente y objeto
ASM_FILE = start.S
SRC_FILE = main.c
ASM_OBJ_FILE = start.o
OBJ_FILE = main.o
ELF_FILE = main.elf
BIN_FILE = main.bin
HEX_FILE = main.hex
ASM_OUTPUT = main.s
DISASSEMBLY_OUTPUT = main.dis
LINKER_SCRIPT = loader.ld

# Comandos de compilación
AS = riscv32-unknown-elf-as
CC = riscv32-unknown-elf-gcc
LD = riscv32-unknown-elf-ld
OBJCOPY = riscv32-unknown-elf-objcopy
OBJDUMP = riscv32-unknown-elf-objdump

# Opciones de compilación y vinculación
CFLAGS = -r
LDFLAGS = -T $(LINKER_SCRIPT) -m elf32lriscv -nostdlib --no-relax
OBJCOPYFLAGS = -O binary

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

# Regla para generar el archivo binario a partir del ELF
$(BIN_FILE): $(ELF_FILE)
	$(OBJCOPY) $(OBJCOPYFLAGS) $< $@

# Regla para generar el archivo hexadecimal a partir del binario
$(HEX_FILE): $(BIN_FILE)
	hexdump -e '"%08x\n"' $< > $@

# Regla para generar el ensamblador intermedio de main.c
$(ASM_OUTPUT): $(SRC_FILE)
	$(CC) -march=rv32i -mabi=ilp32 -S $< -o $@

# Regla para desensamblar el archivo ELF
$(DISASSEMBLY_OUTPUT): $(ELF_FILE)
	$(OBJDUMP) -d $< > $@

# Limpiar archivos generados
clean:
	rm -f $(ASM_OBJ_FILE) $(OBJ_FILE) $(ELF_FILE) $(BIN_FILE) $(HEX_FILE) $(ASM_OUTPUT) $(DISASSEMBLY_OUTPUT)

.PHONY: all clean
