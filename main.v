module harrisDetector(input clk,
input reset,
input[7:0] pixel,
input pixel_valid,
output[31:0] harris_score);

wire[7:0] window[0:5][0:5]; 
wire window_valid;
wire[15:0] Gx[0:3][0:3];
wire[15:0] Gy[0:3][0:3];

wire[63:0] R;
wire rdy;
wire[63:0] count;



imageControl ic(.clk(clk),.reset(reset),.pixel(pixel),.pixel_valid(pixel_valid),.window(window),.window_valid(window_valid),.count(count));

gradient g(.clk(clk),.reset(reset),.win_valid(window_valid),.window(window),.Gx(Gx),.Gy(Gy));

harris_score h(.clk(clk), .Gx(Gx), .Gy(Gy), .R(R), .rdy(rdy));

display d(.clk(clk),.window(window),.Gx(Gx),.Gy(Gy), .R(R),.count(count));

assign R32 = R[63:32];

imageControl2 ic2(.clk(clk),.reset(reset),.pixel(R32),.pixel_valid(pixel_valid),.window(window2),.window_valid(window_valid), .count1(count1));

checkCorner cc(.clk(clk),.reset(reset),.window(window2),.isCorner(isCorner));


display d(.clk(clk),.window(window),.Gx(Gx),.Gy(Gy), .R(R),.count(count1), .isCorner(isCorner));


endmodule