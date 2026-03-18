`timescale 1ps/1ps

module tb;

    logic clk = 0;
    real v, i;

    // clk = 50 ps
    always #25 clk = ~clk;

    sipm_ME dut(
        .vout(v),
        .Iout(i),
        .clk(clk)
    );

    initial begin
        $monitor ("%0t|Clock = %5.f|Voltaje=%.5f|Corriente=%.5f, K=%d, iteracion = %d",$time,clk,v,i, dut.trigger_index,dut.k);
        #20025 $finish;   // 20 ns
    end

endmodule
