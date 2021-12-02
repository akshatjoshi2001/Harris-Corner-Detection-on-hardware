module harrisDetector(input clk,
input reset,
input[7:0] pixel,
input pixel_valid,
output[31:0] harris_score);

wire[7:0] window[0:5][0:5]; 
wire window_valid;
wire[15:0] Gx[0:3][0:3];
wire[15:0] Gy[0:3][0:3];

imageControl ic(.clk(clk),.reset(reset),.pixel(pixel),.pixel_valid(pixel_valid),.window(window),.window_valid(window_valid));

gradient g(.clk(clk),.reset(reset),.win_valid(window_valid),.window(window),.Gx(Gx),.Gy(Gy));

display d(.window(window),.Gx(Gx),.Gy(Gy));


endmodule