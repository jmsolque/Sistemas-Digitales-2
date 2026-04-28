# Makefile para simulación del CPU

# Variables
SIM = iverilog
SIM_FLAGS = -o salida
VVP = vvp
WAVE = gtkwave
VCD_FILE = resultados.vcd

# Archivos fuente
SOURCES = cpu.v tester_cpu.v testbench_cpu.v

# Objetivo principal
all: simular

# Compilar y simular
simular: compilar ejecutar

# Compilar todos los módulos
compilar:
	$(SIM) $(SIM_FLAGS) $(SOURCES)

# Ejecutar la simulación
ejecutar:
	$(VVP) salida

# Ver formas de onda
ver:
	$(WAVE) $(VCD_FILE) plantilla.gtkw

# Limpiar archivos generados
clean:
	rm -f salida $(VCD_FILE)

# Ayuda
help:
	@echo "Comandos disponibles:"
	@echo "  make compilar  - Compilar los módulos Verilog"
	@echo "  make simular   - Compilar y ejecutar simulación"
	@echo "  make ver       - Abrir GTKWave para ver formas de onda"
	@echo "  make clean     - Limpiar archivos generados"

.PHONY: all simular compilar ejecutar ver clean help
