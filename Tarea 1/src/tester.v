module tester (/*AUTOARG*/

            // Outputs
            clock, reset
            );

            output reg clock;
            output reg reset;

            initial begin 
              clock = 0;
              reset = 0;
              #10 reset = 1;  //Reset en 10s

              #20 reset = 0;
              #10 reset = 1;



              #2000 $finish;  //Termina la simulación a los 2000 segundos
            end

            always begin
              #10 clock = !clock;
            end

endmodule 







