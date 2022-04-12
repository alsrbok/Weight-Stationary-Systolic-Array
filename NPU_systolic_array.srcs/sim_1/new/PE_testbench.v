`timescale 1ns/1ps

module PE_testbench;

 // Change this value to use another Data_Width 
 parameter Data_Width = 8;

 //Inputs
 reg clk, reset, ready_data_in, ready_weight, select_weight, select_weight_bf;
 reg [Data_Width-1:0] data_in, psum_in, weight_in;

 //Outputs
 wire ready_data_out;
 wire [Data_Width-1:0] data_out, psum_out;
 
 
 PE#(.Data_Width(Data_Width)) dut(.clk(clk), .reset(reset), .ready_data_in(ready_data_in), .ready_weight(ready_weight), 
 .select_weight(select_weight), .select_weight_bf(select_weight_bf), .data_in(data_in), .psum_in(psum_in), 
 .weight_in(weight_in), .ready_data_out(ready_data_out), .data_out(data_out), .psum_out(psum_out));

 always
    #5 clk = ~clk;

 initial begin
    clk = 0;
    reset = 0;

    #5 reset = 1;
    #5 reset = 0; ready_weight = 1; 

    //First cycle
    #5; ready_data_in = 1; ready_weight = 1; select_weight = 0; select_weight_bf = 0; data_in = 3; psum_in = 0; weight_in = 2;
    //$display("%0t ns = ready data_out : %b, data_out = %d, psum_out = %d, weight_out", $time, ready_data_out, data_out, psum_out, weight_out);

    #10; ready_data_in = 1; ready_weight = 1; select_weight = 0; select_weight_bf = 0; data_in = 4; psum_in = 3; weight_in = 2;
    //$display("%0t ns = ready data_out : %b, data_out = %d, psum_out = %d, weight_out", $time, ready_data_out, data_out, psum_out, weight_out);

 end


endmodule