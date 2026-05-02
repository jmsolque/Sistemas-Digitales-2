# Makefile para simulación del CPU

all:
	yosys -s cpu.ys     # Genera el archivo con las compuertas que requiere el codigo 
	iverilog -g2005-sv testbench.v    # Esto ejecuta iverilog para todos los .v que hay dentro del testbench
	vvp a.out    # Ejecuta el a.out que se genera al ejecutar el testbench
	gtkwave resultados.vcd plantilla.gtkw   # Abre automaticamente gtkwave con las senales de importancia para verificar el sistema 

clear:
	rm *.vcd   # Elimina los .vcd cada vez que se genera uno nuevo
	rm a.out   # Elimina el a.out cada vez que se genera uno nuevo
	rm cpu_synth.v   #Elimina el verilog que se genera al ejecutar Yosys 
