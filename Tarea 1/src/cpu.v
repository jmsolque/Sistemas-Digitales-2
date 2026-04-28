module cpu ( /*AUTOOUTPUT*/
             /*AUTOARG*/
            // Inputs
            clock, reset, opcode, ab_select, op_addr, mem_data_in,

            //Outputs
              prog_addr, mem_control, mem_addr, equal, mem_data_out, request_rom, request_ram
            );

//Inputs   
input clock, reset;
input [3:0]opcode;   // Puede ser un parametro
input ab_select;     // Puede ser un parametro
input [7:0]op_addr;  // Puede ser un parametro 
input [7:0]mem_data_in;

//Outputs
output reg [11:0]prog_addr;
output reg mem_control;
output reg [11:0]mem_addr;
output reg equal, request_rom, request_ram;
output reg [7:0]mem_data_out;

//States
localparam send_ROM = 4'b0000;
localparam wait_ROM = 4'b0001;
localparam read_ROM = 4'b0010;
localparam logic_operation = 4'b0011;
localparam Instruction = 4'b0100;
localparam wait_RAM = 4'b0101;
localparam load_register = 4'b0110;
localparam End =4'b0111;
// 4'b1000;

//Operations
localparam store = 4'b0100;
localparam load  = 4'b0011;
localparam add   = 4'b1001;
localparam sub   = 4'b1010;
localparam and_  = 4'b0010;
localparam or_   = 4'b0001;
localparam equal_operation = 4'b0101;

//Declaración de variables para los estados
reg [3:0] state, next_state;
reg [7:0] A, next_A, B, next_B;

//Reg para recibir datos
reg reg_ab_select, reg_ab_select_next; 
reg [3:0] reg_opcode, reg_opcode_next;
reg [7:0] reg_op_addr, reg_op_addr_next;

reg mem_control_next, request_rom_next, request_ram_next, equal_next;
reg [11:0] mem_addr_next;
reg [11:0] prog_addr_next;
reg [7:0] mem_data_out_next;


// Lógica secuencial(flip-flops)
always @(posedge clock) begin
  if (!reset) begin   //Reset=0, se hace todo cero y comienza en send_ROM.
    state <= send_ROM;
    prog_addr <= 12'b0;
    mem_control <= 0;
    mem_addr <= 12'b0;
    mem_data_out <= 8'b0;
    equal <= 0;
    A <= 8'b0;
    B <= 8'b0;
    request_rom <= 0;
    request_ram <= 0;
    reg_opcode <= 4'b0;
    reg_ab_select <= 0;
    reg_op_addr <= 8'b0;
  end else begin    //Reset=1, sigue la lógica de la maquina de estados. 
    state <= next_state;
    mem_control <= mem_control_next;
    mem_addr <= mem_addr_next;
    mem_data_out <=mem_data_out_next;
    equal <= equal_next;
    A <= next_A;
    B <= next_B;
    request_rom <= request_rom_next;
    request_ram <= request_ram_next;
    reg_opcode <= reg_opcode_next;
    reg_ab_select <= reg_ab_select_next;
    reg_op_addr <= reg_op_addr_next;
    prog_addr <= prog_addr_next;
  end
end


// Lógica combinacional 
always @(*) begin 
  // Valores por defecto a la hora de inciar 
  next_state = state;
  next_A = A;
  next_B = B;
  mem_control_next = mem_control;
  mem_addr_next = mem_addr;
  mem_data_out_next = mem_data_out;
  request_rom_next = 0;
  request_ram_next = 0;
  reg_opcode_next = reg_opcode;
  reg_ab_select_next = reg_ab_select;
  reg_op_addr_next = reg_op_addr;
  equal_next = equal;
  prog_addr_next = prog_addr;

  //Máquina de estados
  case (state)
    //Estado 0 = Solicitar la instrucción a la ROM. 
    send_ROM: begin
      request_rom_next = 1;   //Activa la señal que solicita info a la Rom.
      next_state = wait_ROM;  //Pasa al próximo estado.
    end
    
    //Estado 1 = Esoera a que la ROM entregue los datos. 
    wait_ROM: begin
      request_rom_next = 1;   //Espera un ciclo de clock para que la ROM responda. 
      next_state = read_ROM;
    end
    
    //Estado 2 = Lee la instrucción que llega de la ROm 
    read_ROM: begin
      reg_opcode_next = opcode;
      reg_ab_select_next = ab_select;
      reg_op_addr_next = op_addr;
      prog_addr_next = prog_addr + 1;    //Incrementa la instrucción desde aquí.

      case (opcode)
        load, store: next_state = Instruction;
        default: next_state = logic_operation;
      endcase
    end


    //Estado 3 = Operaciones lógicas 
    logic_operation: begin
      case (reg_opcode)
        add: begin
          if (reg_ab_select) 
            next_A = A + B;
          else 
            next_B = A + B;
            next_state = send_ROM;
        end

        sub: begin 
          if (reg_ab_select) 
            next_A = A - B;
          else 
            next_B = A - B;
            next_state = send_ROM;
        end

        and_: begin 
          if (reg_ab_select)
            next_A = A & B;
          else
            next_B = A & B;
            next_state = send_ROM;
        end

        or_: begin
          if (reg_ab_select)
            next_A = A | B;
          else
            next_B = A | B;
            next_state = send_ROM;
        end

        equal_operation: begin 
          equal_next = (A == B);
          next_state = End;
        end
        default: next_state = send_ROM;
      endcase
    end


    //Estado 4 = Acceso a la memoria RAM.
    Instruction: begin
      request_ram_next = 1;
      mem_addr_next = {4'b0, reg_op_addr};

      if (reg_opcode == load) begin
        mem_control_next = 1;   //Indica que se va hacer lectura.
        next_state = wait_RAM;
      end
      else if (reg_opcode == store) begin
        mem_control_next = 0;  //Indica que se va hacer escritura.
        if (reg_ab_select)
          mem_data_out_next = B;
        else
          mem_data_out_next = A;
          next_state = wait_RAM;
        end 
      end


      //Estado 5 = Esperar el acceso a la RAM.
      wait_RAM: begin
        request_ram_next = 1;
        mem_control_next = mem_control;
        mem_addr_next = mem_addr;

        if (reg_opcode == load) begin
          next_state = load_register;
        end
        else if (reg_opcode == store) begin
          next_state = send_ROM;
        end
      end


      //Estado 6 = Cargar el dato en la RAM.
      load_register: begin 
        if (reg_ab_select)begin
          next_A = mem_data_in;
        end
        else begin
          next_B = mem_data_in;
        end
        next_state = send_ROM;
      end


        //Estado = Fin del programa.
        End: begin
          next_state = End;
          equal_next = (A == B);
          request_rom_next = 0;
          request_ram_next = 0;
        end
        default: next_state = send_ROM;
    endcase
end


endmodule 
        

        





















































    













