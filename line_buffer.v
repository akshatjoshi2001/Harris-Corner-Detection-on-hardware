module lineBuffer(
input   i_clk,
input   i_rst,
input [7:0] i_data,
input   i_data_valid,
output [7:0] o_data[0:5],
input i_rd_data
);

reg [7:0] line [511:0]; //line buffer
reg [8:0] wrPntr;
reg [8:0] rdPntr;

always @(posedge i_clk)
begin
    if(i_data_valid)
        line[wrPntr] <= i_data;
end

always @(posedge i_clk)
begin
    if(i_rst)
        wrPntr <= 'd0;
    else if(i_data_valid)
        wrPntr <= (wrPntr + 'd1);
end

assign o_data[0] = line[rdPntr];
assign o_data[1] = line[rdPntr+1];
assign o_data[2] = line[rdPntr+2];
assign o_data[3] = line[rdPntr+3];
assign o_data[4] = line[rdPntr+4];
assign o_data[5] = line[rdPntr+5];

always @(posedge i_clk)
begin
    if(i_rst)
        rdPntr <= 'd0;
    else if(i_rd_data)
        rdPntr <= (rdPntr + 'd1);
end


endmodule

module lineBuffer_32(
input   i_clk,
input   i_rst,
input [`opsize:0] i_data,
input   i_data_valid,
output [`opsize:0] o_data[0:2],
input i_rd_data
);

reg [`opsize:0] line [511:0]; //line buffer
reg [8:0] wrPntr;
reg [8:0] rdPntr;

always @(posedge i_clk)
begin
    if(i_data_valid)
        line[wrPntr] <= i_data;
end

always @(posedge i_clk)
begin
    if(i_rst)
        wrPntr <= 'd0;
    else if(i_data_valid)
        wrPntr <= (wrPntr + 'd1);
end

assign o_data[0] = line[rdPntr];
assign o_data[1] = line[rdPntr+1];
assign o_data[2] = line[rdPntr+2];

always @(posedge i_clk)
begin
    if(i_rst)
        rdPntr <= 'd0;
    else if(i_rd_data)
        rdPntr <= (rdPntr + 'd1);
end


endmodule