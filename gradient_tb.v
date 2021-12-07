// Test bench to verify sobel filter. 
//`timescale 1ns/1ns
`define ENABLE_TB 1'b1
/*
module grad_tb();
   
    reg clk;
    reg reset;
    reg winvalid;
   
    initial begin
        clk = 0;
        reset = 0;
        winvalid = 1;
    end
    always #0.5 clk = ~clk;
   
    wire[15:0] Gx[0:3][0:3];
    wire[15:0] Gy[0:3][0:3];
    
   
    reg[7:0] arr [0:5][0:5];
    integer i;
    integer j;
    always@(posedge clk) begin 
       
        for(i=0;i<6;i=i+1) begin
            for(j=0;j<6;j=j+1) begin
                arr[i][j] <= $urandom%256;
            end
        end
    end
   
    
    //gradient grad(.reset(reset),.win_valid(winvalid),.clk(clk),.window(arr),.Gx(Gx),.Gy(Gy));
    //display disp(.window(arr),.Gx(Gx),.Gy(Gy));
endmodule
*/

module display(input clk,input[7:0] window[0:5][0:5],input[15:0] Gx[0:3][0:3],input[15:0] Gy[0:3][0:3], input[63:0] R,input[63:0] count, input isCorner);
    integer i;
    integer j;
   
    
    always@(posedge clk) begin
        if(1) begin
            
            // $display("=====Window=====  Count = %d ",count);
            // for(i=0;i<6;i=i+1) begin
                    
            //         for(j=0;j<6;j=j+1) begin
            //             $write("%d,",window[i][j]);
            //         end
            //         $write("\n");
                
            //     end


                
                // $display("---Gx---");
                // for(i=0;i<4;i=i+1) begin
                    
                //     for(j=0;j<4;j=j+1) begin
                //         $write("%d ",$signed(Gx[i][j]));
                //     end
                //     $write("\n");
                
                // end
                // $display("\n---Gy---");
                // for(i=0;i<4;i=i+1) begin
                    
                //     for(j=0;j<4;j=j+1) begin
                //         $write("%d ",$signed(Gy[i][j]));
                //     end
                //     $write("\n");
                
                // end
                
            
            //$display("=====Harris Score=====");
            //$write(" %d \n",count);
            // if($signed(R) >= (1<<32))begin
            if(isCorner)begin
                //$write("HERE R = %d \n",$signed(R));
                $write(" %d \n",count);
            end
          
            


        end
    end

    
endmodule