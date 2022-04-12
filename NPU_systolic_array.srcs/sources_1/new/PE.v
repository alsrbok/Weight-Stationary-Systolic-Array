`timescale 1ns/1ps

module PE(clk, reset, ready_data_in, ready_weight, select_weight, select_weight_bf, 
data_in, psum_in, weight_in, ready_data_out, data_out, psum_out);

 parameter Data_Width = 8;        //Use 8bits for one number -> change during quantization

 input wire clk, reset, ready_data_in, ready_weight, select_weight, select_weight_bf;
 input wire [Data_Width-1:0] data_in, psum_in, weight_in;

 output reg ready_data_out;
 output reg [Data_Width-1:0] data_out, psum_out;

 reg ready_psum;
 reg [Data_Width-1:0] weight0, weight1, psum_reg;

 always @(*) begin
     if(select_weight == 1'b0)      //action() when some of these values are changed! : @(*)
         psum_reg = psum_in + data_in * weight0;
     else if(select_weight == 1'b1)
         psum_reg = psum_in + data_in * weight1;
 end

 always @(*) begin
     ready_psum = ready_data_in && ready_weight;
     //$monitor(ready_psum, "[$monitor] time = %0t, ready_psum = %b", $time, ready_psum);
 end

 always @(posedge clk) begin
     if(select_weight_bf == 1'b0 && ready_weight)
        weight0 <= weight_in;
     else if(select_weight_bf == 1'b1 && ready_weight)
        weight1 <= weight_in;
 end

 always @(negedge clk) begin
     ready_data_out <= ready_data_in;
     if(reset == 1'b1) begin
         ready_data_out = 1'b0;
         data_out = 0;
         psum_out = 0;
         ready_psum = 0;
         weight0 = 0;
         weight1 = 0;
         psum_reg = 0;
     end
    else begin 
        if(ready_data_in == 1'b1) begin
            data_out <= data_in;
            //ready_data_out <= ready_data_in;
            //$monitor(data_in, "[$monitor] time = %0t, data_in = %b", $time, data_in);
            //$monitor(ready_data_in, "[$monitor] time = %0t, ready_data_in = %b", $time, ready_data_in);
        end

        if(ready_psum == 1'b1) begin
            psum_out <= psum_reg;
            //$display("[$display] time = %0t, psum_reg = %d, psum_in = %d, data_in = %d weight0 = %d, ready_psum = %b", $time, psum_reg, psum_in, data_in, weight0, ready_psum);
        end
        
        else begin
            psum_out <= 0;
            psum_reg = 0;
            //$display("[$display] time = %0t, psum_reg = %d, psum_in = %d, data_in = %d weight0 = %d, ready_psum = %b", $time, psum_reg, psum_in, data_in, weight0, ready_psum);
        end
        
    end
 end

endmodule