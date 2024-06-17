# Nombres de los archivos fuente y objeto
ASM_FILE = boot.s
SRC_FILE = main.c
ASM_OBJ_FILE = boot.o
OBJ_FILE = main.o
ELF_FILE = main.elf
BIN_FILE = main.bin
HEX_FILE = main.hex
C_TO_ASM = main.s
LIST_FILE = main.lst
MAP_FILE = main.map
LINKER_SCRIPT = loader.ld

# Comandos de compilación
AS = riscv32-unknown-elf-as
CC = riscv32-unknown-elf-gcc
LD = riscv32-unknown-elf-ld
OBJCOPY = riscv32-unknown-elf-objcopy
OBJDUMP = riscv32-unknown-elf-objdump

# Opciones de compilación y vinculación
ASFLAGS = -march=rv32i
CFLAGS = -O0 -g -Wall -fcommon -ffreestanding -march=rv32i -mabi=ilp32
LDFLAGS = -T $(LINKER_SCRIPT) -Map=$(MAP_FILE) -m elf32lriscv -gc-sections -static -nostdlib --no-relax --entry=_start
OBJCOPYFLAGS = -O binary

# Regla por defecto
all: $(HEX_FILE) $(LIST_FILE) $(MAP_FILE)

# Regla para ensamblar boot.S
$(ASM_OBJ_FILE): $(ASM_FILE)
	$(AS) $(ASFLAGS) $< -o $@

# Regla para compilar main.c
$(OBJ_FILE): $(SRC_FILE)
	$(CC) $(CFLAGS) -c $< -o $@

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
$(C_TO_ASM): $(SRC_FILE)
	$(CC) $(CFLAGS) -S $< -o $@

# Regla para generar el archivo .lst
$(LIST_FILE): $(ELF_FILE)
	$(OBJDUMP) -S $< > $@

# Regla de ayuda
help:
	@echo "Comandos disponibles:"
	@echo "  all:                 Compila todo y genera los archivos $(HEX_FILE), $(LIST_FILE) y $(MAP_FILE)."
	@echo "  $(ASM_OBJ_FILE):     Ensambla $(ASM_FILE) en $(ASM_OBJ_FILE)."
	@echo "  $(OBJ_FILE):         Compila $(SRC_FILE) en $(OBJ_FILE)."
	@echo "  $(ELF_FILE):         Enlaza $(ASM_OBJ_FILE) y $(OBJ_FILE) en $(ELF_FILE)."
	@echo "  $(BIN_FILE):         Genera el archivo binario $(BIN_FILE) a partir de $(ELF_FILE)."
	@echo "  $(HEX_FILE):         Genera el archivo hexadecimal $(HEX_FILE) a partir de $(BIN_FILE)."
	@echo "  $(C_TO_ASM):         Genera el ensamblador intermedio $(C_TO_ASM) a partir de $(SRC_FILE)."
	@echo "  $(LIST_FILE):        Genera el archivo $(LIST_FILE) con el ensamblado intercalado con el código fuente."
	@echo "  clean:               Limpia todos los archivos generados."

# Limpiar archivos generados
clean:
	rm -f $(ASM_OBJ_FILE) $(OBJ_FILE) $(ELF_FILE) $(BIN_FILE) $(HEX_FILE) $(C_TO_ASM) $(LIST_FILE) $(MAP_FILE)

.PHONY: all clean help
