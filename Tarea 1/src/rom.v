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
    reg [12:0] rom_memory [0:9];

    assign opcode = data[12:9];
    assign ab_select = data[8];   //A es cero y si quiero B es 1
    assign op_addr  = data[7:0];

  // Initial block para inicializar y cambiar después de cierto tiempo
  initial begin
    // Empieza con la primera prueba 
    rom_memory[0] <= 13'b0011_0_00000101; // Load A from 005
    rom_memory[1] <= 13'b0011_1_00001010; // Load B from 010
    rom_memory[2] <= 13'b1001_1_00000000; // ADD A + B y Store en B
    rom_memory[3] <= 13'b0100_0_00001111; // Store A at 015 
    rom_memory[4] <= 13'b0100_1_00010100; // Store B at 020
    rom_memory[5] <= 13'b0011_0_00010100; // LOAD A from 020
    rom_memory[6] <= 13'b0011_1_00011001; // LOAD B from 025
    rom_memory[7] <= 13'b0101_0_00000000; // EQUAL A to B
    #500; // Cambia las instrucciones después de 500 segundos

    //Segunda prueba
    rom_memory[0] <= 13'b0011_0_00000001;  // Load A from 001
    rom_memory[1] <= 13'b0011_1_00000110;  // Load B from 006
    rom_memory[2] <= 13'b1001_1_00000000;  // SUB A + B y Store en B
    rom_memory[3] <= 13'b0100_1_00000101;  // Store B at 005
    rom_memory[4] <= 13'b0011_0_00000010;  // Load A from 002
    rom_memory[5] <= 13'b0010_1_00000000;  // AND A && B y Store en B
    rom_memory[7] <= 13'b0100_0_00000111;  // Store A at 007
    rom_memory[8] <= 13'b0100_1_00001110;  // Store B at 014
    rom_memory[6] <= 13'b0001_0_00000000;  // OR A || B y Store en A
    rom_memory[9] <= 13'b0101_0_00000000;  // EQUAL A to B
  end

  always @(posedge clock) begin
    if (request_rom && reset) begin
        data <= rom_memory[prog_addr];
    end else begin
      data <= '0;
    end
  end
endmodule





