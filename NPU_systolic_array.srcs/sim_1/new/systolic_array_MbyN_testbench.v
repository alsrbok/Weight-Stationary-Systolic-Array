`timescale 1ns/1ps

module systolic_array_MbyN_testbench;

 parameter Data_Width = 8;
 parameter pe_array_width = 4;
 parameter pe_array_height = 4;

 //Inputs
 reg clk, reset;
 reg [pe_array_height*Data_Width-1:0] data_in;
 reg [pe_array_height-1:0] ready_data_in;
 reg [pe_array_height*pe_array_width*Data_Width-1:0] weight_in;
 reg [Data_Width-1:0] first_row_psum_in;
 reg select_weight, select_weight_bf, ready_weight;
 

 //Outputs
 wire [pe_array_width*Data_Width-1:0] psum_out;

 systolic_array_MbyN #(
     .Data_Width(Data_Width), 
    .pe_array_width(pe_array_width), 
    .pe_array_height(pe_array_height)
    )
    dut(clk, reset, data_in, ready_data_in, weight_in, first_row_psum_in, 
    ready_weight, select_weight, select_weight_bf, psum_out);
 
 initial begin
  forever #5 clk = ~clk;
 end

 initial begin
     clk = 0;
     reset = 0;
     data_in = 0;
     ready_data_in = 0;
     weight_in = 0;
     first_row_psum_in = 0;
     select_weight = 0;
     select_weight_bf = 0;
     ready_weight = 1;
     
     #5 reset = 1;
     #5 reset = 0;

      // Should be start from MSB
     weight_in = {8'd1, 8'd1, 8'd1, 8'd1, 
                  8'd4, 8'd3, 8'd2, 8'd1,
                  8'd1, 8'd1, 8'd1, 8'd1,
                  8'd4, 8'd3, 8'd2, 8'd1};
     #5; // t=15
     data_in = {8'd0, 8'd0, 8'd0, 8'd1};
     ready_data_in = 4'b0001;
     
     #10; //t=25
     data_in = {8'd0, 8'd0, 8'd2, 8'd2};
     ready_data_in = 4'b0011;

     #10; //t=35
     data_in = {8'd0, 8'd1, 8'd3, 8'd1};
     ready_data_in = 4'b0111;

     #10; // t=45
     data_in = {8'd4, 8'd1, 8'd1, 8'd2};
     ready_data_in = 4'b1111;

     #6 $display("%0t ns : psum0 / psum1 / psum2 / psum3 = %d / %d / %d / %d", $time, psum_out[7:0], psum_out[15:8], psum_out[23:16], psum_out[31:24]);

     #4; // t=55
     data_in = {8'd4, 8'd1, 8'd2, 8'd0};
     ready_data_in = 4'b1110;

     #6 $display("%0t ns : psum0 / psum1 / psum2 / psum3 = %d / %d / %d / %d", $time, psum_out[7:0], psum_out[15:8], psum_out[23:16], psum_out[31:24]);

     #4; // t=65
     data_in = {8'd1, 8'd1, 8'd0, 8'd0};
     ready_data_in = 4'b1100;

     #6 $display("%0t ns : psum0 / psum1 / psum2 / psum3 = %d / %d / %d / %d", $time, psum_out[7:0], psum_out[15:8], psum_out[23:16], psum_out[31:24]);

     #4; // t=75
     data_in = {8'd1, 8'd0, 8'd0, 8'd0};
     ready_data_in = 4'b1000;
     
     //for t=80
     #6 $display("%0t ns : psum0 / psum1 / psum2 / psum3 = %d / %d / %d / %d", $time, psum_out[7:0], psum_out[15:8], psum_out[23:16], psum_out[31:24]);
     
     #4; // t=85
     data_in = {8'd0, 8'd0, 8'd0, 8'd0};
     ready_data_in = 4'b0000;
     
     //for t=90
     #6 $display("%0t ns : psum0 / psum1 / psum2 / psum3 = %d / %d / %d / %d", $time, psum_out[7:0], psum_out[15:8], psum_out[23:16], psum_out[31:24]);
     #4;
     
     //for t=100
     #6 $display("%0t ns : psum0 / psum1 / psum2 / psum3 = %d / %d / %d / %d", $time, psum_out[7:0], psum_out[15:8], psum_out[23:16], psum_out[31:24]);
     #4;

     //for t=110
     #6 $display("%0t ns : psum0 / psum1 / psum2 / psum3 = %d / %d / %d / %d", $time, psum_out[7:0], psum_out[15:8], psum_out[23:16], psum_out[31:24]);
     #4;
     
     //for t=120
     #6 $display("%0t ns : psum0 / psum1 / psum2 / psum3 = %d / %d / %d / %d", $time, psum_out[7:0], psum_out[15:8], psum_out[23:16], psum_out[31:24]);
     #4;

     //for t=130
     reset = 1;
     #6 $display("%0t ns : psum0 / psum1 / psum2 / psum3 = %d / %d / %d / %d", $time, psum_out[7:0], psum_out[15:8], psum_out[23:16], psum_out[31:24]);
     #4;

     #10;
     $stop;
 end
endmodule