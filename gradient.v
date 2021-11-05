module gradient(input [7:0] window[0:5][0:5], output [7:0] Gx[0:3][0:3], output [7:0] Gy[0:3][0:3],output rdy);
  

    genvar i;
    genvar j;
    
    generate   // Computing gradient entries in parallel
        for(i=2'd0;i<=2'd3;i=i+2'd1) begin
            for(j=2'd0;j<=2'd3;j=j+2'd1) begin
                
                win_multiply wm(.i(i[1:0]),.j(j[1:0]),.window(window),.resultx(Gx[i][j]),.resulty(Gy[i][j]));
            end
        end

    endgenerate

endmodule

module win_multiply(input[1:0] i,input[1:0] j,input[7:0] window[0:5][0:5],output[7:0] resultx,output[7:0] resulty);

    assign resultx = 1*(window[i+0][j+0]) -1*window[i+0][j+2] + 2*(window[i+1][j+0]) -2*window[i+1][j+2] + 1*(window[i+2][j+0]) -1*window[i+2][j+2];
    assign resulty = 1*(window[i+0][j+0]) -1*window[i+2][j+0] + 2*(window[i+0][j+1]) -2*window[i+2][j+1] + 1*(window[i+0][j+2]) -1*window[i+2][j+2];
    
endmodule


// TODO: Write Test Bench to verify sobel filter. 
module grad_tb();
    wire[7:0] Gx[0:3][0:3];
    wire[7:0] Gy[0:3][0:3];
    wire rdy;
   
    reg[7:0] arr [0:5][0:5];
    integer i;
    integer j;
    initial begin 
       
        for(i=0;i<6;i=i+1) begin
            for(j=0;j<6;j=j+1) begin
                if((i+j)%3 == 0) begin
                   
                    arr[i][j] = 5;
                end
                else begin
                    arr[i][j] = -3;
                end
            end
        end

    end
   
    
    gradient grad(.window(arr),.Gx(Gx),.Gy(Gy),.rdy(rdy));
    display disp(.Gx(Gx),.Gy(Gy));

endmodule


module display(input[7:0] Gx[0:3][0:3],input[7:0] Gy[0:3][0:3]);
    integer i;
    integer j;
    
    always@(*) begin
        $display("---Gx---");
        for(i=0;i<4;i=i+1) begin
            
            for(j=0;j<4;j=j+1) begin
                $write("%d ",$signed(Gx[i][j]));
            end
            $write("\n");
        
        end
        $display("\n---Gy---");
        for(i=0;i<4;i=i+1) begin
            
            for(j=0;j<4;j=j+1) begin
                $write("%d ",$signed(Gy[i][j]));
            end
            $write("\n");
        
        end
    end

    
endmodule
