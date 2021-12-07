
  
`timescale 1ns / 1ps
`define opsize 63
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
    $dumpfile("test.vcd");
    $dumpvars(0,harris_tb);
    file = $fopen("chess.bin","rb");
    reset = 1;
    #6
    reset = 0;
    #1000000
    $finish;
    
    
    

    


 
   



end



always@(posedge clk) begin
    /*count = count+1;
    if(count > 1000) begin
        $finish;
    end
    */
    if(!reset) begin    
        pixel <= $fgetc(file);
        pixel_valid <= 1;
        
                 

    end else begin 
        pixel <= 0;
        pixel_valid <= 0;
       
    end
  
   
end



harrisDetector hd(.clk(clk),.reset(reset),.pixel(pixel),.pixel_valid(pixel_valid));


endmodule