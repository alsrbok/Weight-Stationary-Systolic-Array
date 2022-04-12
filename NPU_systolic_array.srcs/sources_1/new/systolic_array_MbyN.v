`timescale 1ns/1ps

module systolic_array_MbyN(clk, reset, data_in, ready_data_in, weight_in, first_row_psum_in, 
ready_weight, select_weight, select_weight_bf, psum_out);
 
 //default value of parameter
 parameter Data_Width = 8;
 parameter pe_array_width = 4;
 parameter pe_array_height = 4;

 input wire clk, reset;
 input wire [pe_array_height*Data_Width-1:0] data_in;
 input wire [pe_array_height-1:0] ready_data_in;
 input wire [pe_array_height*pe_array_width*Data_Width-1:0] weight_in;
 input wire [Data_Width-1:0] first_row_psum_in;
 input wire select_weight, select_weight_bf, ready_weight;

 output wire [pe_array_width*Data_Width-1:0] psum_out;

 wire [Data_Width-1:0] data_connect[0:pe_array_height-1][0:pe_array_width-1];
 wire ready_data_connect[0:pe_array_height-1][0:pe_array_width-1];
 wire [Data_Width-1:0] psum_connect[0:pe_array_height-2][0:pe_array_width-1];

 genvar i,j;

 generate
     for(i=0; i<pe_array_height;i=i+1) begin : Row
        for(j=0;j<pe_array_width;j=j+1) begin : Col
            if(j==0) begin :jz
                if(i==0)begin :iz
                    PE#(.Data_Width(Data_Width)) pe(clk,reset,ready_data_in[i],ready_weight,select_weight,select_weight_bf,
                    data_in[(i+1)*Data_Width-1:i*Data_Width], first_row_psum_in, 
                    weight_in[i*pe_array_width*Data_Width+(j+1)*Data_Width-1:i*pe_array_width*Data_Width+j*Data_Width],
                    ready_data_connect[i][j], data_connect[i][j], psum_connect[i][j]);
                end

                else if(i!=pe_array_height-1) begin :imed
                    PE#(.Data_Width(Data_Width)) pe(clk,reset,ready_data_in[i],ready_weight,select_weight,select_weight_bf,
                    data_in[(i+1)*Data_Width-1:i*Data_Width], psum_connect[i-1][j], 
                    weight_in[i*pe_array_width*Data_Width+(j+1)*Data_Width-1:i*pe_array_width*Data_Width+j*Data_Width],
                    ready_data_connect[i][j], data_connect[i][j], psum_connect[i][j]);
                end

                else begin :ilast
                    PE#(.Data_Width(Data_Width)) pe(clk,reset,ready_data_in[i],ready_weight,select_weight,select_weight_bf,
                    data_in[(i+1)*Data_Width-1:i*Data_Width], psum_connect[i-1][j], 
                    weight_in[i*pe_array_width*Data_Width+(j+1)*Data_Width-1:i*pe_array_width*Data_Width+j*Data_Width],
                    ready_data_connect[i][j], data_connect[i][j], psum_out[(j+1)*Data_Width-1:j*Data_Width]);
                end
            end

            else begin :jnz
                if(i==0)begin :iz
                    PE#(.Data_Width(Data_Width)) pe(clk,reset,ready_data_connect[i][j-1],ready_weight,select_weight,select_weight_bf,
                    data_connect[i][j-1], first_row_psum_in, 
                    weight_in[i*pe_array_width*Data_Width+(j+1)*Data_Width-1:i*pe_array_width*Data_Width+j*Data_Width],
                    ready_data_connect[i][j], data_connect[i][j], psum_connect[i][j]);
                end

                else if(i!=pe_array_height-1) begin :imed
                    PE#(.Data_Width(Data_Width)) pe(clk,reset,ready_data_connect[i][j-1],ready_weight,select_weight,select_weight_bf,
                    data_connect[i][j-1], psum_connect[i-1][j], 
                    weight_in[i*pe_array_width*Data_Width+(j+1)*Data_Width-1:i*pe_array_width*Data_Width+j*Data_Width],
                    ready_data_connect[i][j], data_connect[i][j], psum_connect[i][j]);
                end

                else begin :ilast
                    PE#(.Data_Width(Data_Width)) pe(clk,reset,ready_data_connect[i][j-1],ready_weight,select_weight,select_weight_bf,
                    data_connect[i][j-1], psum_connect[i-1][j], 
                    weight_in[i*pe_array_width*Data_Width+(j+1)*Data_Width-1:i*pe_array_width*Data_Width+j*Data_Width],
                    ready_data_connect[i][j], data_connect[i][j], psum_out[(j+1)*Data_Width-1:j*Data_Width]);
                end
            end
        end
     end
 endgenerate


endmodule