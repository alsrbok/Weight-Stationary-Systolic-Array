`timescale 1ns/1ps

module systolic_array_2by2(clk, reset, first_row_psum_in, select_weight, select_weight_bf,ready_weight,
rd1, d1, rd3, d3, w1, w2, w3, w4, ps3, ps4);

  parameter Data_Width = 8;
  input wire clk, reset, select_weight, select_weight_bf,ready_weight;
  input wire [Data_Width-1:0] first_row_psum_in, rd1,d1,rd3,d3,w1,w2,w3,w4;
  output wire[Data_Width-1:0] ps3,ps4;

  wire rd12, rd34, rd2, rd4;
  wire [Data_Width-1:0] d12, d34, ps13, ps24, d2, d4;

  PE #(
    .Data_Width(Data_Width)
    ) 
    pe1(.clk(clk), .reset(reset), .ready_data_in(rd1), .ready_weight(ready_weight), .select_weight(select_weight), 
  .select_weight_bf(select_weight_bf), .data_in(d1), .psum_in(first_row_psum_in), .weight_in(w1), 
  .ready_data_out(rd12), .data_out(d12), .psum_out(ps13));

  PE #(
    .Data_Width(Data_Width)
    )
    pe2(.clk(clk), .reset(reset), .ready_data_in(rd12), .ready_weight(ready_weight), .select_weight(select_weight), 
  .select_weight_bf(select_weight_bf), .data_in(d12), .psum_in(first_row_psum_in), .weight_in(w2), 
  .ready_data_out(rd2), .data_out(d2), .psum_out(ps24));

  PE #(
    .Data_Width(Data_Width)
    ) 
    pe3(.clk(clk), .reset(reset), .ready_data_in(rd3), .ready_weight(ready_weight), .select_weight(select_weight), 
  .select_weight_bf(select_weight_bf), .data_in(d3), .psum_in(ps13), .weight_in(w3), 
  .ready_data_out(rd34), .data_out(d34), .psum_out(ps3));

  PE #(
    .Data_Width(Data_Width)
    )
    pe4(.clk(clk), .reset(reset), .ready_data_in(rd34), .ready_weight(ready_weight), .select_weight(select_weight), 
  .select_weight_bf(select_weight_bf), .data_in(d34), .psum_in(ps24), .weight_in(w4), 
  .ready_data_out(rd4), .data_out(d4), .psum_out(ps4));

endmodule