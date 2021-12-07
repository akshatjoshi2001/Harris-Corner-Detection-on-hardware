module harrisDetector(input clk,
input reset,
input[7:0] pixel,
input pixel_valid,
output[`opsize:0] harris_score);

wire[7:0] window[0:5][0:5]; 
wire[`opsize:0] window2[0:2][0:2]; 
wire window_valid;
wire[15:0] Gx[0:3][0:3];
wire[15:0] Gy[0:3][0:3];

wire[63:0] R;
wire[`opsize:0] R_;
wire rdy;
wire[63:0] count;
wire[63:0] count1;
wire isCorner;



imageControl ic(.clk(clk),.reset(reset),.pixel(pixel),.pixel_valid(pixel_valid),.window(window),.window_valid(window_valid),.count(count));

gradient g(.clk(clk),.reset(reset),.win_valid(window_valid),.window(window),.Gx(Gx),.Gy(Gy));

harris_score h(.clk(clk), .Gx(Gx), .Gy(Gy), .R(R), .rdy(rdy));


assign R_ = R[63:63-`opsize];

imageControl2 ic2(.clk(clk),.reset(reset),.pixel(R_),.pixel_valid(pixel_valid),.window(window2),.window_valid(window_valid), .count1(count1));

checkCorner cc(.clk(clk),.reset(reset),.window(window2),.isCorner(isCorner));


display d(.clk(clk),.window(window),.Gx(Gx),.Gy(Gy), .R(R),.count(count1), .isCorner(isCorner));


endmodule