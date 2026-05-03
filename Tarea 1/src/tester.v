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

              #20 reset = 0;  //Reset a los 20s desde el anterior 
              #10 reset = 1;  // Tiempo del reset es de 10s 

	      #950 reset = 0; // A los 950s del ultimo reset se vuelve a activar, para la sincronizacion con la ROM
	      #10 reset = 1; 

	      #650 reset = 0; // A los 650s del ultimo reset, se activa para que se pueda ejecutar la ultima prueba 
	      #10 reset = 1;



              #700 $finish;  //Termina la simulacion 700s de de la ultima interacion del reset 
            end
	

            always begin
              #10 clock = !clock;  // Cada flanco de reloj dura 10s 
            end

endmodule 







