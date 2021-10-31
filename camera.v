
`define ROWSIZE 640
`define COLSIZE 480
`define MEMORY "memory"

module camera(input clk, output [7:0] Rpixel,output[7:0] Gpixel,output[7:0] Bpixel);
    
    reg[7:0] RMem[0:639][0:479];
    reg[7:0] GMem[0:639][0:479];
    reg[7:0] BMem[0:639][0:479];

    reg[7:0] Rpixel_;
    reg[7:0] Gpixel_;
    reg[7:0] Bpixel_;


    reg[31:0] x;
    reg[31:0] y;

    assign Rpixel = Rpixel_;
    assign Gpixel = Gpixel_;
    assign Bpixel = Bpixel_;

    initial begin
        // Read from image file

        x = 0;
        y = 0;

       $readmemh({`MEMORY,"/r_image.mem"},RMem); 
        $readmemh({`MEMORY,"/g_image.mem"},GMem);
       $readmemh({`MEMORY,"/b_image.mem"},BMem);
        


    end

    always @(posedge clk) begin


        Rpixel_ = RMem[x][y];
        Gpixel_ = GMem[x][y];
        Bpixel_ = BMem[x][y];


        // Modify x,y
     
        x = (x+1);
        if(x==`COLSIZE) begin
            x = 0;
            y = y+1;
        end
        

    

    end



endmodule