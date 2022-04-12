`timescale 1ns/1ps

module systolic_array_2by2_testbench;
 
 parameter Data_Width = 8;
 parameter pe_array_width = 2;
 parameter pe_array_height = 2;
 //parameter throughput_size = 2;
 
 //Buffers
 //This Buffers will be assigned from Control_buffer module
 /*
 reg [Data_Width-1:0] input_buffer[0:pe_array_height-1][0:throughput_size-1];
 reg [Data_Width-1:0] psum_buffer[0:throughput_size-1][0:pe_array_width-1];
 */
 //This will be change to wire if external module existed
 reg [Data_Width-1:0] input_buffer[0:pe_array_height-1];
 reg ready_data_in[0:pe_array_height-1];
 wire [Data_Width-1:0] psum_buffer0;
 wire [Data_Width-1:0] psum_buffer1;
 reg [Data_Width-1:0] weight_buffer[0:pe_array_height-1][0:pe_array_width-1];

 //Inputs
 reg clk, reset, select_weight, select_weight_bf, ready_weight;
 reg [Data_Width-1:0] first_row_psum_in;

 systolic_array_2by2 #(
     .Data_Width(Data_Width)
     ) 
     dut(
         .clk(clk), 
         .reset(reset), 
         .first_row_psum_in(first_row_psum_in), 
         .select_weight(select_weight), 
         .select_weight_bf(select_weight_bf), 
         .ready_weight(ready_weight), 
         .rd1(ready_data_in[0]), 
         .d1(input_buffer[0]), 
         .rd3(ready_data_in[1]), 
         .d3(input_buffer[1]), 
         .w1(weight_buffer[0][0]), 
         .w2(weight_buffer[0][1]), 
         .w3(weight_buffer[1][0]), 
         .w4(weight_buffer[1][1]), 
         .ps3(psum_buffer0), 
         .ps4(psum_buffer1)
         );

 always
    #5 clk = ~clk;

 initial begin
     clk = 0;
     reset = 0;
     first_row_psum_in = 0;
     select_weight = 0;
     select_weight_bf = 0;
     ready_weight = 1;
    
     for (integer i=0; i<pe_array_height; i=i+1) begin
         input_buffer[i] = 0;
     end
     for (integer i=0; i<pe_array_height; i=i+1) begin
         ready_data_in[i] = 0;
     end
     for (integer i=0; i<pe_array_height; i=i+1) begin
         for(integer j=0; j<pe_array_width; j=j+1) begin
             weight_buffer[i][j] = 0;
         end
     end


     #5 reset = 1;
     #5 reset = 0;

     //First cycle
     //Weight Buffer Assign
     for (integer i=0; i<pe_array_height; i=i+1) begin
         for(integer j=0; j<pe_array_width; j=j+1) begin
             weight_buffer[i][j] = i+j+1;
         end
     end
     #5
     //Input_Buffer_Assign
     input_buffer[0] = 8'd1; input_buffer[1] = 8'd2;
     //Control_Buffer
     ready_data_in[0] = 1'b1; ready_data_in[1] = 1'b0;

     #10;
     //Input_Buffer_Assign
     input_buffer[0] = 8'd3; input_buffer[1] = 8'd2;
     //Control_Buffer
     ready_data_in[0] = 1'b1; ready_data_in[1] = 1'b1;
     
     #10;
     //Input_Buffer_Assign
     input_buffer[0] = 8'd0; input_buffer[1] = {4'd0,4'd4};
     //Control_Buffer
     ready_data_in[0] = 1'b0; ready_data_in[1] = 1'b1;

     #10;
     //Input_Buffer_Assign
     input_buffer[0] = 8'd0; input_buffer[1] = 8'd0;
     //Control_Buffer
     ready_data_in[0] = 1'b0; ready_data_in[1] = 1'b0;
    #100;
     
     $stop;


 end


endmodule