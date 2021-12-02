`timescale 1ns / 1ps
module harris_tb();

reg clk;
reg reset;
reg[7:0] pixel;
reg pixel_valid;
reg ImageData;
integer file;
initial
 begin
    clk = 1'b0;

 end
always #5 clk = ~clk;

initial begin
    file = $fopen("android.bin","rb");
    
    reset = 0;
    #10
    $display("reset initiated");
    reset = 0;


 
   



end

always@(posedge clk) begin
    $display("clk");
    if(!reset) begin    
        pixel <= $fgetc(file);
        pixel_valid <= 1;
          $display(pixel);

    end
  
   
end



harrisDetector hd(.clk(clk),.reset(reset),.pixel(pixel),.pixel_valid(pixel_valid));


endmodule