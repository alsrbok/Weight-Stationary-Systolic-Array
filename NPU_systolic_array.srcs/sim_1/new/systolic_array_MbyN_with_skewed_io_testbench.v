`timescale 1ns/1ps

module systolic_array_MbyN_with_skewed_io_testbench;

 parameter Data_Width = 8;
 parameter pe_array_width = 4;
 parameter pe_array_height = 4;
 parameter throughput_size = 4;

//Inputs
 reg clk, reset;
 reg [pe_array_height*throughput_size*Data_Width-1:0] input_buffer_wire;
 reg [pe_array_height*pe_array_width*Data_Width-1:0] weight_in;
 reg select_weight, select_weight_bf, ready_weight;

//Outputs
 wire [pe_array_width*throughput_size*Data_Width-1:0] output_buffer;

 systolic_array_MbyN_with_skewed_io #(
     .Data_Width(Data_Width), .pe_array_width(pe_array_width), 
     .pe_array_height(pe_array_height), .throughput_size(throughput_size)) dut(
     clk, reset, input_buffer_wire, weight_in, ready_weight, select_weight, select_weight_bf, output_buffer);

 initial begin
  forever #5 clk = ~clk;
 end

 initial begin
     clk = 0;
     reset = 0;
     input_buffer_wire = 0;
     weight_in = 0;
     select_weight = 0;
     select_weight_bf = 0;
     ready_weight = 1;
     
     #5;
     input_buffer_wire = {8'd1, 8'd1, 8'd2, 8'd2, 8'd1, 8'd1, 8'd1, 8'd1, 8'd4, 8'd1, 8'd3, 8'd2, 8'd4, 8'd1, 8'd2, 8'd1};
     reset = 1;
     #5 reset = 0; // t=10

      // Should be start from MSB
     weight_in = {8'd1, 8'd1, 8'd1, 8'd1, 
                  8'd4, 8'd3, 8'd2, 8'd1,
                  8'd1, 8'd1, 8'd1, 8'd1,
                  8'd4, 8'd3, 8'd2, 8'd1};
    
    
    
     #41; // t=51
     
     $display("%d, %d, %d, %d\n%d, %d, %d, %d\n%d, %d, %d, %d\n%d, %d, %d, %d\n",output_buffer[7:0], output_buffer[15:8], 
     output_buffer[23:16], output_buffer[31:24], output_buffer[39:32], output_buffer[47:40], output_buffer[55:48], output_buffer[63:56],
     output_buffer[71:64], output_buffer[79:72], output_buffer[87:80], output_buffer[95:88], output_buffer[103:96], output_buffer[111:104],
     output_buffer[119:112], output_buffer[127:120]);

     #10; // t=61
     $display("%d, %d, %d, %d\n%d, %d, %d, %d\n%d, %d, %d, %d\n%d, %d, %d, %d\n",output_buffer[7:0], output_buffer[15:8], 
     output_buffer[23:16], output_buffer[31:24], output_buffer[39:32], output_buffer[47:40], output_buffer[55:48], output_buffer[63:56],
     output_buffer[71:64], output_buffer[79:72], output_buffer[87:80], output_buffer[95:88], output_buffer[103:96], output_buffer[111:104],
     output_buffer[119:112], output_buffer[127:120]);

     #10; // t=71
     $display("%d, %d, %d, %d\n%d, %d, %d, %d\n%d, %d, %d, %d\n%d, %d, %d, %d\n",output_buffer[7:0], output_buffer[15:8], 
     output_buffer[23:16], output_buffer[31:24], output_buffer[39:32], output_buffer[47:40], output_buffer[55:48], output_buffer[63:56],
     output_buffer[71:64], output_buffer[79:72], output_buffer[87:80], output_buffer[95:88], output_buffer[103:96], output_buffer[111:104],
     output_buffer[119:112], output_buffer[127:120]);

     #10; // t=81
     $display("%d, %d, %d, %d\n%d, %d, %d, %d\n%d, %d, %d, %d\n%d, %d, %d, %d\n",output_buffer[7:0], output_buffer[15:8], 
     output_buffer[23:16], output_buffer[31:24], output_buffer[39:32], output_buffer[47:40], output_buffer[55:48], output_buffer[63:56],
     output_buffer[71:64], output_buffer[79:72], output_buffer[87:80], output_buffer[95:88], output_buffer[103:96], output_buffer[111:104],
     output_buffer[119:112], output_buffer[127:120]);

     #10; // t=91
     $display("%d, %d, %d, %d\n%d, %d, %d, %d\n%d, %d, %d, %d\n%d, %d, %d, %d\n",output_buffer[7:0], output_buffer[15:8], 
     output_buffer[23:16], output_buffer[31:24], output_buffer[39:32], output_buffer[47:40], output_buffer[55:48], output_buffer[63:56],
     output_buffer[71:64], output_buffer[79:72], output_buffer[87:80], output_buffer[95:88], output_buffer[103:96], output_buffer[111:104],
     output_buffer[119:112], output_buffer[127:120]);

     #10; // t=101
     $display("%d, %d, %d, %d\n%d, %d, %d, %d\n%d, %d, %d, %d\n%d, %d, %d, %d\n",output_buffer[7:0], output_buffer[15:8], 
     output_buffer[23:16], output_buffer[31:24], output_buffer[39:32], output_buffer[47:40], output_buffer[55:48], output_buffer[63:56],
     output_buffer[71:64], output_buffer[79:72], output_buffer[87:80], output_buffer[95:88], output_buffer[103:96], output_buffer[111:104],
     output_buffer[119:112], output_buffer[127:120]);

     #10; // t=111
     $display("%d, %d, %d, %d\n%d, %d, %d, %d\n%d, %d, %d, %d\n%d, %d, %d, %d\n",output_buffer[7:0], output_buffer[15:8], 
     output_buffer[23:16], output_buffer[31:24], output_buffer[39:32], output_buffer[47:40], output_buffer[55:48], output_buffer[63:56],
     output_buffer[71:64], output_buffer[79:72], output_buffer[87:80], output_buffer[95:88], output_buffer[103:96], output_buffer[111:104],
     output_buffer[119:112], output_buffer[127:120]);
     
     #10; // t=121
     $display("%d, %d, %d, %d\n%d, %d, %d, %d\n%d, %d, %d, %d\n%d, %d, %d, %d\n",output_buffer[7:0], output_buffer[15:8], 
     output_buffer[23:16], output_buffer[31:24], output_buffer[39:32], output_buffer[47:40], output_buffer[55:48], output_buffer[63:56],
     output_buffer[71:64], output_buffer[79:72], output_buffer[87:80], output_buffer[95:88], output_buffer[103:96], output_buffer[111:104],
     output_buffer[119:112], output_buffer[127:120]);

     #10; reset = 1;
     $display("%d, %d, %d, %d\n%d, %d, %d, %d\n%d, %d, %d, %d\n%d, %d, %d, %d\n",output_buffer[7:0], output_buffer[15:8], 
     output_buffer[23:16], output_buffer[31:24], output_buffer[39:32], output_buffer[47:40], output_buffer[55:48], output_buffer[63:56],
     output_buffer[71:64], output_buffer[79:72], output_buffer[87:80], output_buffer[95:88], output_buffer[103:96], output_buffer[111:104],
     output_buffer[119:112], output_buffer[127:120]);

    $stop;

 end

endmodule