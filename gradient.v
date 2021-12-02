 
module gradient(input reset,input win_valid,input clk, input [7:0] window[0:5][0:5], output [15:0] Gx[0:3][0:3], output [15:0] Gy[0:3][0:3]);
  

    genvar i;
    genvar j;
    integer p;
    integer q;
    
    wire[15:0] Gx_[0:3][0:3]; // Output wire from combinational block
    wire[15:0] Gy_[0:3][0:3];

    reg[15:0] Gx_reg[0:3][0:3]; // pipeline registers
    reg[15:0] Gy_reg[0:3][0:3];


    generate   // Computing gradient entries in parallel (Combinational logic)
        for(i=2'd0;i<=2'd3;i=i+2'd1) begin
            for(j=2'd0;j<=2'd3;j=j+2'd1) begin
                
                win_multiply wm(.i(i[1:0]),.j(j[1:0]),.window(window),.resultx(Gx_[i][j]),.resulty(Gy_[i][j]));
            end
        end

    endgenerate

    always@(posedge clk) begin // Updating Pipeline registers at clock edge
                 
       for(p=0;p<4;p=p+1) begin
            for(q=0;q<4;q=q+1) begin
                if(reset) begin
                    Gx_reg[p][q] <= 0;
                    Gy_reg[p][q] <= 0;
                end
                else if(win_valid) begin
                    Gx_reg[p][q] <= Gx_[p][q];
                    Gy_reg[p][q] <= Gy_[p][q];
                end
                else begin
                    Gx_reg[p][q] <= 0;
                    Gy_reg[p][q] <= 0;
                
                end
              
            end 
        end
    end     
   
    assign Gx = Gx_reg; // Assigning output wires to pipeline registers
    assign Gy = Gy_reg;

endmodule

module win_multiply(input[1:0] i,input[1:0] j,input[7:0] window[0:5][0:5],output[15:0] resultx,output[15:0] resulty);

    assign resultx = 1*(window[i+0][j+0]) -1*window[i+0][j+2] + 2*(window[i+1][j+0]) -2*window[i+1][j+2] + 1*(window[i+2][j+0]) -1*window[i+2][j+2];
    assign resulty = 1*(window[i+0][j+0]) -1*window[i+2][j+0] + 2*(window[i+0][j+1]) -2*window[i+2][j+1] + 1*(window[i+0][j+2]) -1*window[i+2][j+2];
    
endmodule



