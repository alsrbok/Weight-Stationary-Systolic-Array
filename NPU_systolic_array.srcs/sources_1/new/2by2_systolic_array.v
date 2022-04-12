`timescale 1ns/1ps

module systolic_array_2by2(clk, reset, first_row_psum_in, select_weight, select_weight_bf,ready_weight,
rd1, d1, rd3, d3, w1, w2, w3, w4, ps3, ps4);

  parameter Data_Width = 8;
  input wire clk, reset, first_row_psum_in, select_weight, select_weight_bf,ready_weight;
  input wire [Data_Width-1:0] rd1,d1,rd3,d3,w1,w2,w3,w4;
  output wire[Data_Width-1:0] ps3,ps4;

  wire rd12, rd34;
  wire [Data_Width-1:0] d12, d34, ps13, ps24;

endmodule