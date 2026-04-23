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
output reg mem_data_out;

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

  if (!reset) begin   // Reset activo en bajo, si se pone en cero se resetea todo.
    state <= send_ROM;
    prog_addr <= 12'b0;
    mem_control <= 0;
    mem_addr <= 12'b0;
    mem_data_out <= 8'b0;
    equal <= 0;
    a <= 8'b0;
    b <= 8'b0;
    request_rom <= 0;
    request_ram <= 0;
    reg_opcode <= 4'b0;
    reg_ab_select <= 0;
    reg_op_addr <= 8'b0;

  end else begin
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

    if (next_state == send_ROM && state != send_ROM) begin 
      prog_addr <=prog_addr + 1 ;
    end
  end 
end 



// Lógica convinacional 
always @(*) begin 

  // Valores por defecto a la hora de inciar 
  next_state = state;
  next_A = A;
  next_B = B;
  mem_control_next = 0;
  mem_addr_next = 12'b0;
  mem_data_out_next = 8'b0;
  request_rom_next = 0;
  request_ram_next = 0;
  reg_opcode_next = 0;
  reg_opcode_next = reg_opcode;
  reg_ab_select_next = reg_ab_select;
  reg_op_addr_next = reg_op_addr;
  equal_next = equal; 

  //Máquina de estados
  case (state)
    send_ROM: begin
      request_rom_next = 1;   //Activa la señal que solicita info a la Rom.
      next_state = wait_ROM;  //Pasa al próximo estado.
      equal_next = 0;         // El próximo estado es diferente de equal. 

    end

    wait_ROM: begin
      case (op_addr) 
        reg_op_addr: next_state = read_ROM;  // Si hay instrucción se sigue a read_ROM.
        default: next_state = wait_ROM;  // No hay instrucción se va a wait_ROM.
      endcase
    end

    read_ROM: begin
      reg_opcode_next = opcode;         //Se guarda opcode para no perderlo.
      reg_ab_select_next = ab_select;   //Se guarda ab_select para no perderlo.
      reg_op_addr_next = op_addr;       //Se guarda op_addr para no perderlo.

      case (opcode)
        load: begin
          next_state = Instruction;   //Se va para el estado Instruction si es Load.
        end

        store: begin
          next_state = Instruction;   //Se va al estado de Instruction si es Store.
        end

        default: begin
          next_state = logic_operation;  //Si no es Load o Store hace la operación Lógica.
        end
      endcase
    end

    logic_operation: begin
      case (reg_opcode)

        add: begin
          if (reg_ab_select) begin  
            next_A = A + B;          //Si el registro es A, la operacion se guarda en A.
          end
          else begin
            next_B = A + B;          //Si el registro es B, la operación se guarda en B.
          end
          next_state = send_ROM;     //Una vez hace la operación se devuleve al incio. 
        end

        sub: begin                  // En este caso solo se toma la resta de A - B ya que no hay como saber si se resta A - B o B - A. 
          if (reg_ab_select) begin
            next_A = A - B;         //El próximo valor de A va ser la resta A - B.
          end
          else begin
            next_B = A - B;         //El próximo valor de B es la resta de A -B.
          end
          next_state = send_ROM;    //Cuando termina la operación se devuelve al inicio.
        end

        and_: begin 
          if (reg_ab_select)  begin
            next_A = A & B;          //Se guarda el resultado de la AND en A.
          end
          else begin
            next_B = A & B;         //Se guarda el resultado de la AND en B.
          end
          next_state = send_ROM;    //Cuando temrina se va al inico.
        end

        or_: begin
          if (reg_ab_select) begin
            next_A = A | B;         //El resultado se guarda en A.
          end
          else begin
            next_B = A | B;         //El resultado se guarda en B.
          end
          next_state = send_ROM;    //Cuando termina se devuelve al inicio. 
        end

        default: begin
          next_state = send_ROM;
        end
      endcase
    end

    End: begin
      equal_next = 1;     //Si la operación es Equal, se va al estado End en donde termina la ejecución.
    end
    default: begin
      next_state = send_ROM;   //Si no es Equal, se devuelve a send_ROM para volver a empezar.
    end

    Instruction: begin
      request_ram_next = 1;   //En el siguiente flanco de reloj activa el request_ram.
      mem_addr_next = reg_op_addr;  //Indica la dirección de memeoria de la RAM que dio la ROM.
      case (reg_opcode)
        load: begin
          mem_control_next = 1;    //El siguiente valor de mem_control = 1, va a leer.
          next_state = wait_RAM;   //Espera a que lea la memeoria. 
        end

        store: begin
          mem_control_next = 0;   //Con mem_control = 0 va a escribir en la RAM.
          if (reg_ab_select) begin
            mem_data_out_next = B;  //Se escribe en el registro B.
          end
          else begin
            mem_data_out_next = A;  //Se escribe en el registro A.
          end
          next_state = wait_RAM;    //Una vez que da la instrucción debe esperar a que escriba en la RAM.
        end
      endcase
    end

    wait_RAM: begin
      mem_control_next = mem_control;     //Aqui mantiene el mismo valor de mem_control.
      mem_addr_next = mem_addr;           //Se mantiene la dirección de memeoria.
      mem_data_out_next = mem_data_out;   //Se mantiene el dato que sale del CPU y entra a la RAM.

      case(reg_opcode)
        store: begin
          next_state = send_ROM;    //Luego de guardar el dato, se devuelve al inicio.
        end

        load: begin
          next_state = load_register;   //Luego de leer el dato se va a cargarlo. 
        end
      endcase
    end

    load_register: begin
      if (reg_ab_select) begin  //Indica la variable del registro.
        next_A = mem_data_in;   //El valor de A despues del flanco sera el que viene de la RAM.
      end
      else begin
        next_B = mem_data_in      //El valor de B despues del flanco sera el que viene de la RAM.
      end
        next_state = send_ROM;      //Una vez termina de leer el dato, se devuelve al incio.
    end
  endcase
end


endmodule 





















































    













