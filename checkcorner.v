module checkCorner(input clk, input reset ,input[`opsize:0] window[0:2][0:2],output isCorner);


    wire [`opsize:0] mid = window[1][1];
    reg isCorner_;
    assign isCorner = isCorner_;
    always @(posedge clk) begin
        if($signed(mid) > (1<<32) & $signed(mid) > $signed(window[0][0]) & $signed(mid) > $signed(window[0][1]) & $signed(mid) > $signed(window[0][2]) & $signed(mid) > $signed(window[1][0]) & $signed(mid) > $signed(window[1][2]) & $signed(mid) > $signed(window[2][0]) & $signed(mid) > $signed(window[2][1]) & $signed(mid) > $signed(window[2][2]))begin
            isCorner_ <= 1'b1;
        end
        else begin
            isCorner_ <= 1'b0;
        end
        
    end




endmodule