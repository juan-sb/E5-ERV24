# Nombre del archivo de ensamblaje
ASM_FILE = start.S
# Nombre del archivo objeto
OBJ_FILE = start.o
# Nombre del archivo ELF
ELF_FILE = start.elf
# Nombre del archivo binario
BIN_FILE = start.bin
# Nombre del archivo hex
HEX_FILE = start.hex
# Nombre del archivo de desensamblado
DISASM_FILE = start.dis
# Archivo de script de vinculación
LINKER_SCRIPT = loader.ld

# Comandos de compilación
AS = riscv32-unknown-elf-as
LD = riscv32-unknown-elf-ld
OBJCOPY = riscv32-unknown-elf-objcopy
OBJDUMP = riscv32-unknown-elf-objdump
HEXDUMP = hexdump

# Opciones de compilación y vinculación
ASFLAGS = 
LDFLAGS = -T $(LINKER_SCRIPT) -m elf32lriscv -nostdlib --no-relax
OBJCOPYFLAGS = -O binary
OBJDUMPFLAGS = -d

# Regla por defecto
all: $(HEX_FILE) $(DISASM_FILE)

# Regla para generar el archivo objeto
$(OBJ_FILE): $(ASM_FILE)
	$(AS) $(ASFLAGS) $< -o $@

# Regla para generar el archivo ELF
$(ELF_FILE): $(OBJ_FILE)
	$(LD) $(LDFLAGS) $< -o $@

# Regla para generar el archivo binario
$(BIN_FILE): $(ELF_FILE)
	$(OBJCOPY) $(OBJCOPYFLAGS) $< $@

# Regla para generar el archivo hex
$(HEX_FILE): $(BIN_FILE)
	$(HEXDUMP) -e '"%08x\n"' $< > $@

# Regla para generar el archivo de desensamblado
$(DISASM_FILE): $(ELF_FILE)
	$(OBJDUMP) $(OBJDUMPFLAGS) $< > $@

# Limpiar archivos generados
clean:
	rm -f $(OBJ_FILE) $(ELF_FILE) $(BIN_FILE) $(HEX_FILE) $(DISASM_FILE)

.PHONY: all clean
