`timescale 1ns/1ps

module systolic_array_MbyN_with_skewed_io(clk, reset, input_buffer_wire, weight_in, ready_weight, select_weight, select_weight_bf, output_buffer);

 //default value of parameter
 parameter Data_Width = 8;
 parameter pe_array_width = 4;
 parameter pe_array_height = 4;
 parameter throughput_size = 4;

 input wire clk, reset;
 input wire [pe_array_height*throughput_size*Data_Width-1:0] input_buffer_wire;
 input wire [pe_array_height*pe_array_width*Data_Width-1:0] weight_in;
 input wire select_weight, select_weight_bf, ready_weight;

 output reg [pe_array_width*throughput_size*Data_Width-1:0] output_buffer;
 
 wire [pe_array_width*Data_Width-1:0] output_buffer_wire;
 reg [pe_array_height*throughput_size*Data_Width-1:0]input_buffer;
 //reg [pe_array_width*throughput_size*Data_Width-1:0] output_buffer;
 reg [pe_array_height-1:0] buffer_re;
 reg [pe_array_width-1:0] buffer_we;
 reg [Data_Width-1:0] initial_psum;
 
 systolic_array_MbyN#(.Data_Width(Data_Width), .pe_array_width(pe_array_width), .pe_array_height(pe_array_height)) npu(.clk(clk), .reset(reset), 
 .data_in(input_buffer[pe_array_height*Data_Width-1:0]), .ready_data_in(buffer_re), .weight_in(weight_in), .first_row_psum_in(initial_psum),
 .ready_weight(ready_weight), .select_weight(select_weight), .select_weight_bf(select_weight_bf), .psum_out(output_buffer_wire));

// posedge clk is time of weight assign and updated input
 always @(posedge clk) begin
     if(reset == 1'b1) begin
         //initialize for input_buffer, output_buffer, re, we, initial_psum
        input_buffer = input_buffer_wire;
        output_buffer = 0;
        buffer_re = 1;
        buffer_we = 0;
        initial_psum = 0;
        /*
        $display("%0t ns :\n%d, %d, %d, %d\n%d, %d, %d, %d\n%d, %d, %d, %d\n%d, %d, %d, %d\n",$time, input_buffer[7:0], input_buffer[15:8], 
        input_buffer[23:16], input_buffer[31:24], input_buffer[39:32], input_buffer[47:40], input_buffer[55:48], input_buffer[63:56],
        input_buffer[71:64], input_buffer[79:72], input_buffer[87:80], input_buffer[95:88], input_buffer[103:96], input_buffer[111:104],
        input_buffer[119:112], input_buffer[127:120]);
        */
     end

     else begin
         /*
         if(buffer_re == 0 && buffer_we == 0) begin //first posedge clk
             buffer_re <= 1;
         end
         */
         //else begin
             if(buffer_re[pe_array_height-1] == 0 && buffer_we[pe_array_width-1] == 0) begin //state of we = 0
                 buffer_re <= buffer_re << 1;
                 buffer_re[0] <= 1;
             end
             else begin // state of some psum calculation finished
                 buffer_re <= buffer_re << 1;
                 buffer_we <= buffer_we << 1;
                 buffer_we[0] <= buffer_re[pe_array_height-1];
             end
         //end
         for(integer j=0; j<pe_array_height; j=j+1) begin // update the input_buffer
            if(buffer_re[j] == 1) begin
                for(integer i=0; i<throughput_size-1; i=i+1)begin
                    input_buffer[(i*pe_array_height+j)*Data_Width +: Data_Width] <=
                     input_buffer[((i+1)*pe_array_height+j)*Data_Width +: Data_Width];
                end
                input_buffer[((throughput_size-1)*pe_array_height+j)*Data_Width +: Data_Width] <= 0;
            end
         end
         /*
         $display("%0t ns :\n%d, %d, %d, %d\n%d, %d, %d, %d\n%d, %d, %d, %d\n%d, %d, %d, %d\n",$time, input_buffer[7:0], input_buffer[15:8], 
            input_buffer[23:16], input_buffer[31:24], input_buffer[39:32], input_buffer[47:40], input_buffer[55:48], input_buffer[63:56],
            input_buffer[71:64], input_buffer[79:72], input_buffer[87:80], input_buffer[95:88], input_buffer[103:96], input_buffer[111:104],
            input_buffer[119:112], input_buffer[127:120]);
         $display("%0t ns :\n RE : %b, WE : %b", $time, buffer_re, buffer_we);
         */
     end
 end

//negedge clk is time which psum_out came out
 always @(negedge clk) begin
     for(integer j=0; j<pe_array_width; j=j+1) begin
         if(buffer_we[j] == 1'b1) begin
             //output_buffer[(0*pe_array_width+j)*Data_Width +: Data_Width] = output_buffer_wire[j*Data_Width +: Data_Width];
             for(integer i=0; i<throughput_size-1; i=i+1) begin
                  output_buffer[(i*pe_array_width+j)*Data_Width +: Data_Width] =
                    output_buffer[((i+1)*pe_array_width+j)*Data_Width +: Data_Width];
             end
             output_buffer[((throughput_size-1)*pe_array_width+j)*Data_Width +: Data_Width] = output_buffer_wire[j*Data_Width +: Data_Width];
         end
     end
     /*
     $display("[re, we] %0t ns :\n RE : %b, WE : %b", $time, buffer_re, buffer_we);
     $display("[output_buffer_wire] %0t ns :\n%d, %d, %d, %d",$time, output_buffer_wire[7:0], output_buffer_wire[15:8], output_buffer_wire[23:16], output_buffer_wire[31:24]);
    */
     /*
     $display("[output_buffer] %0t ns :\n%d, %d, %d, %d\n%d, %d, %d, %d\n%d, %d, %d, %d\n%d, %d, %d, %d\n",$time, output_buffer[7:0], output_buffer[15:8], 
     output_buffer[23:16], output_buffer[31:24], output_buffer[39:32], output_buffer[47:40], output_buffer[55:48], output_buffer[63:56],
     output_buffer[71:64], output_buffer[79:72], output_buffer[87:80], output_buffer[95:88], output_buffer[103:96], output_buffer[111:104],
     output_buffer[119:112], output_buffer[127:120]);
     */
 end

 endmodule