module checkCorner(input clk, input reset ,input[31:0] window[0:2][0:2],output isCorner);


    wire [31:0] mid = window[1][1];
    reg isCorner_;
    assign isCorner = isCorner_;
    always @(posedge clk) begin
        if($signed(mid) > 1 & mid > window[0][0] & mid > window[0][1] & mid > window[0][2] & mid > window[1][0] & mid > window[1][2] & mid > window[2][0] & mid > window[2][1] & mid > window[2][2])begin
            isCorner_ <= 1'b1;
        end
        else begin
            isCorner_ <= 1'b0;
        end
        
    end




endmodule