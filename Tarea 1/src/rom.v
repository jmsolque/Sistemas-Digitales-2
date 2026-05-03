module rom (/*AUTOARG*/
    // Inputs
   clock, reset, request_rom, prog_addr,
  

   // Outputs
   data, opcode, ab_select, op_addr
   );

   //Inputs 
   input clock, reset, request_rom;
   input [11:0] prog_addr;

   //Outputs
   output reg [12:0] data;
   output [3:0] opcode;
   output ab_select;
   output [7:0] op_addr; 

   // Memoria para almacenar las instrucciones
    reg [12:0] rom_memory [0:31];
	
   // Asignacion de salidas 
    assign opcode = data[12:9];
    assign ab_select = data[8];   
    assign op_addr  = data[7:0];

  // Initial block para inicializar y cambiar después de cierto tiempo
  initial begin
     // Programa de ejemplo de la Tabla #2
    rom_memory[0] = 13'b0011_0_00000101; // LOAD A from 005   Formato de instruccion "13'b operacion_a/b_direccion de la RAM" 
    rom_memory[1] = 13'b0011_1_00001010; // LOAD B from 010
    rom_memory[2] = 13'b1001_1_00000000; // ADD A+B in B
    rom_memory[3] = 13'b0100_0_00001111; // STORE A at 015
    rom_memory[4] = 13'b0100_1_00010100; // STORE B at 020
    rom_memory[5] = 13'b0011_0_00010100; // LOAD A from 020
    rom_memory[6] = 13'b0011_1_00011001; // LOAD B from 025
    rom_memory[7] = 13'b0101_0_00000000; // Equal A to B
    #940
    // Prueba con resta (Sub) y AND logica
    rom_memory[0] = 13'b0011_0_00000000; // Load A from 000 (primer digito del carnet)
    rom_memory[1] = 13'b0011_1_00000001; // Load B from 001 (segundo digito del carnet)
    rom_memory[2] = 13'b1010_0_00000000; // Sub A=A-B
    rom_memory[3] = 13'b0010_1_00000000; // AND B=A&B
    rom_memory[4] = 13'b0101_1_00000000; // Equal A to B 
    #940
    // Prueba con OR logica
    rom_memory[0] = 13'b0011_0_00000010; // LOAD A from 002 (tercer digito del carnet)
    rom_memory[1] = 13'b0011_1_00000011; // LOAD B from 003 (cuarto digito del carnet)
    rom_memory[2] = 13'b0001_0_00000000; // OR A=A|B 
    rom_memory[3] = 13'b0100_0_00011100; // STORE A on 028 
    rom_memory[4] = 13'b0101_0_00000000; // Equal A to B 
  end



  
  always @(posedge clock) begin
    if (!reset) begin // Reset activo en bajo, lo que quiere decir que cuando es 0 se reinicia todo
        data <= 13'b0;
    end else if (request_rom) begin
        if (prog_addr < 20)     // Se verifica que no exceda el tamano correspondiente 
            data <= rom_memory[prog_addr];
        else
            data <= 13'b0;
    end else begin
        data <= 13'b0;
    end
  end


endmodule 





