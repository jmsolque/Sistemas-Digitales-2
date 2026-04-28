module ram (/*AUTOARG*/
   //Inputs
    clock, reset, request_ram, mem_control, mem_addr, mem_data_out,
   
   //Outputs
    mem_data_in
    );

    input  clock, reset, request_ram, mem_control;
    input [11:0] mem_addr;
    input [7:0] mem_data_out;
    output reg [7:0] mem_data_in;

    localparam write = 0;
    localparam read = 1;

    reg [7:0] memory [0:31];  //Declaración del arreglo 
    integer i;


    initial begin
      // Inicializa todo a 0
        for (i = 0; i < 32; i = i + 1) memory[i] = 8'b0;  //Inicializar todo en 0

      //Mi carnet es C27645
      memory[0] = 8'b00000111;  // 7
      memory[1] = 8'b00000110;  // 6
      memory[2] = 8'b00000100;  // 4
      memory[3] = 8'b00000101;  // 5
      memory[5] = 8'b00000000;  // 0   Para LOAD de prueba
      memory[6] = 8'b00000011;  // 3
      memory[10] = 8'b00001000; // 8
      memory[15] = 8'b00000010; // 2
      memory[20] = 8'b00001001; // 9
      memory[25] = 8'b00000000; // 0
    end



    always @(posedge clock) begin
      if (request_ram && reset) begin     //Solo si ambos son verdaderos
        if (mem_control == read) begin
          mem_data_in <= memory[mem_addr];
        end
        else if (mem_control == write) begin
          memory[mem_addr] <= mem_data_out;
          mem_data_in <= 8'b0;
        end
        else begin
          mem_data_in <= 8'b0;
        end
      end
      else begin
        mem_data_in <= 8'b0;
      end
  end

endmodule



    

   
