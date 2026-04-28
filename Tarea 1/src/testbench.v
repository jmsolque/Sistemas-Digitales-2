`include "rom.v"
`include "ram.v"
`include "cmos_cells.v"
`include "tester.v"
`include "cpu.v"

module cpu_tb;
    
    // Wires
    wire clock;
    wire reset;
    wire ab_select;
    wire mem_control;
    wire equal;
    wire request_rom;
    wire request_ram;
    wire [12:0] data;
    wire [11:0] mem_addr;
    wire [7:0] mem_data_out;
    wire [7:0] mem_data_in;
    wire [7:0] op_addr;
    wire [3:0] opcode;
    wire [11:0] prog_addr;

    initial begin 
        $dumpfile("resultados.vcd");
        $dumpvars(0, cpu_tb);
    end

    // Instancia de ROM
    rom u_rom (
        .clock         (clock),
        .reset         (reset),
        .request_rom   (request_rom),
        .prog_addr     (prog_addr),
        .data          (data),
        .opcode        (opcode),
        .ab_select     (ab_select),
        .op_addr       (op_addr)
    );

    // Instancia de RAM
    ram u_ram (
        .clock        (clock),
        .reset        (reset),
        .request_ram  (request_ram),
        .mem_control  (mem_control),
        .mem_addr     (mem_addr),
        .mem_data_out (mem_data_out),
        .mem_data_in  (mem_data_in)
    );

    // Instancia de CPU
    cpu u_cpu (
        .clock        (clock),
        .reset        (reset),
        .opcode       (opcode),
        .ab_select    (ab_select),
        .op_addr      (op_addr),
        .mem_data_in  (mem_data_in),
        .prog_addr    (prog_addr),
        .mem_control  (mem_control),
        .mem_addr     (mem_addr),
        .equal        (equal),
        .request_rom  (request_rom),
        .request_ram  (request_ram),
        .mem_data_out (mem_data_out)
    );

    // Instancia de Tester
    tester u_tester (
        .clock   (clock),
        .reset   (reset)
    );

endmodule





      


