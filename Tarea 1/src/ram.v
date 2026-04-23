module ram (/*AUTOARG*/
   //Inputs
    clock, reset, reques_ram, mem_control, mem_addr, mem_data_out,
   
   //Outputs
    mem_data_in
    );

//Mi carnet es C27645
    initial begin
      memory[0] <= 8'b00000111;  //Primera posición del carnet 7
      memory[1] <= 8'b00000110;  //Segunda posición del carnet 6
      memory[2] <= 8'b00000100;  //Tercera posición del carnet 4
      memory[3] <= 8'b00000101;  //Cuarta posición del carnet 5 
      memory[6] <= 8'b00000011;  //3
      memory[10] <= 8'b00001000; //8
      memory[15] <= 8'b00000010; //2
      memory[20] <= 8'b00001001; //9 
    end

    localparam write = 0;
    localparam read = 1;

    input  clock, reset, reques_ram, mem_control;
    input [11:0] mem_addr;
    input [7:0] mem_data_out;
    output reg [7:0] mem_data_in;

    reg [7:0] memory[31:0];

    always @(posedge clock) begin
      if (reques_ram && reset)      //Solo si ambos son verdaderos
        case (mem_control)
          write: memory[mem_addr] <= mem_data_out;  //Según la dirección de memoria se escribe el dato que sale del CPU.
          read: mem_data_out <= memory[mem_addr];   //Según la posición de memoria que sale del CPU se asigna el dato que esta en esa dirección en la RAM. 
        endcase
      end
      else begin
        mem_data_in <= '0'   
      end
    end
endmodule



    

   
