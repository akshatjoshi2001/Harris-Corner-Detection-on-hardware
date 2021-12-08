module lineBuffer(
input   clk,
input   reset,
input [7:0] input_data,
input   input_valid,
output [7:0] output_data[0:5],
input input_read_data
);

reg [7:0] line [511:0]; //line buffer
reg [8:0] writePtr;
reg [8:0] readPtr;

always @(posedge clk)
begin
    if(input_valid)
        line[writePtr] <= input_data;
end

always @(posedge clk)
begin
    if(reset)
        writePtr <= 'd0;
    else if(input_valid)
        writePtr <= (writePtr + 'd1);
end

assign output_data[0] = line[readPtr];
assign output_data[1] = line[readPtr+1];
assign output_data[2] = line[readPtr+2];
assign output_data[3] = line[readPtr+3];
assign output_data[4] = line[readPtr+4];
assign output_data[5] = line[readPtr+5];

always @(posedge clk)
begin
    if(reset)
        readPtr <= 'd0;
    else if(input_read_data)
        readPtr <= (readPtr + 'd1);
end


endmodule