`timescale 1ns / 1ps
module harris_tb();

reg clk;
reg reset;

reg[7:0] pixel;
reg pixel_valid;

integer file, i;
integer sentSize;


initial
 begin
    clk = 1'b0;
    forever
    begin
        #5 clk = ~clk;
    end
 
 end

initial begin
    reset = 0;
    pixel_valid = 0;

    #100
    reset  = 1;
    #100
    file = $fopen("android.bin","rb");

    for(i=0; i<7*480; i=i+1) 
    begin
    @(posedge clk);
    $fscanf(file, "%c", pixel);
    pixel_valid <= 1;
    end

    sentSize  = 7*480;


    @(posedge clk)
    pixel_valid <= 1'b0;

    while (sentSize < 640*480)begin
    @(posedge intrpt)                 // Need to define an output interrupt signal

    for(i=0 ;i<480; i=i+1)begin
    @(posedge clk);
    $fscanf(file, "%c", pixel);
    pixel_valid <= 1;
    end

    @(posedge clk)
    pixel_valid <= 1'b0;
    sentSize = sentSize + 480;
    end

    $fclose(file)
end

// always@(posedge clk) begin
//     pixel <= $fgetc(file);
// end


harris_score hs()
harrisDetector hd(.clk(clk),.reset(reset),.pixel(pixel),.pixel_valid(pixel_valid), .harris_score());


endmodule
