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

    reg [7:0] memory [0:31];  //Declaración del arreglo, utilizo 32 bits  
    integer i;


    initial begin
      // Inicializa todo a 0
        for (i = 0; i < 32; i = i + 1) memory[i] = 8'b0;  //Inicializar todo en 0

      //Mi carnet es C27645
      memory[0] = 8'd7;  // Primer dígito
      memory[1] = 8'd6;  // Segundo dígito
      memory[2] = 8'd4;  // Tercer dígito
      memory[3] = 8'd5;  // Cuarto dígito 
      memory[5]  = 8'd12; // Valor para LOAD A from 005
      // Espacios en 0
      memory[10] = 8'd13; // Valor para LOAD B from 010
      memory[25] = 8'd25; // Valor para comparación EQUAL 
      // Espacios en 0 hasta memory[31] 
    end




    always @(posedge clock) begin          //Logica para escribir en la memoria ram, se debe sincronizar con el clock
	    if (request_ram && reset && mem_control == 1'b0) begin
		    memory[mem_addr[5:0]] <= mem_data_out;  //Escribe lo que viene de mem_data_our en la direccion de memoria mem_addr 
	    end
    end


    always @(*) begin     //Logica para leer de la memoria ram, no requiere sincronizar el clock
      if (request_ram && reset && mem_control == 1'b1) begin     //Solo si ambos son verdaderos
          mem_data_in = memory[mem_addr[5:0]];     //Lee con mem_data_in lo que esta en la direccion mem_addr
        end
        else begin
		mem_data_in = 8'b0;
	end
    end




endmodule



    

   
