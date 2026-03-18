`timescale 1ns/1ps
module sipm_ME(vout, Iout, clk);

output real vout;
output real Iout;
input clk;

// Definir Parametrs

parameter real N = 1000; // Numero de microceldas
parameter real Rq = 500e3; //Resistencia quenching
parameter real Cq = 40e-15; // Capacitancia de la microcelda
parameter real Cd = 90e-15; // Capacitancia parásita
parameter real Cg = 100e-12; // Capacitancia de la carga
parameter real Rpar = 10;
parameter real Lpar = 2e-9;
parameter real Vbias = 33 ; // Voltaje de polarización
parameter real Vbd = 28 ; // Voltaje de ruptura


// Calcular capacitancia equivalente
real dt;
real Ceq;
real int_prev;
integer k;
real dv;
real di;

real trigger; // Tiempo de disparo
real drop ; // Caída de voltaje en la microcelda
integer trigger_index; // Índice de disparo en función del paso de tiempo



real vout_prev;

initial begin
    dt = 0.05e-9;
  Ceq = Cg + N*(Cd + Cq);

  trigger = 5e-9;
   k = 0;
   dv = 0;  
    di = 0;
    drop = Vbias - Vbd;
vout_prev = Vbias;
int_prev = 0;
trigger_index =$rtoi( trigger / (dt));
end

// Iteracion con euler
always @(posedge clk) begin
   if (k == trigger_index) begin
    vout_prev= vout_prev - drop;
   end
    dv = (1.0/Ceq) * (int_prev - (N/Rq)*vout_prev);
    di = (1.0/Lpar) * (Vbias -Rpar*int_prev - vout_prev);
// Actulizar salidas

    vout= vout_prev + dv*dt;
    Iout= int_prev + di*dt;
    //actualizo variables anteriores
    vout_prev = vout;
    int_prev  = Iout;

     k ++;
end 


endmodule
