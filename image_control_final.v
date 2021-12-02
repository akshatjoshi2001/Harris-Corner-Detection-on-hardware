module imageControl(
input                    clk,
input                    reset,
input [7:0]              pixel,
input                    pixel_valid,
output reg [7:0]         window[0:5][0:5],
output                   window_valid
);

// reg 
reg [8:0] pixelCounter;
reg [8:0] rdCounter;
reg [2:0] currentWriteLineBufferNum;
reg [2:0] currentReadLineBufferNum;
reg[7:0] lbOut[0:6][0:5];
reg [6:0] lineBuffDataValid;
reg read_line_buffer;
reg [6:0] lineBuffReadData;
reg [12:0] totalPixelCounter;
reg rdState;

localparam IDLE = 'b0,
           RD_BUFFER = 'b1;

always @(posedge clk)
begin
    if(reset)
        totalPixelCounter <= 0;
    else
    begin
        if(pixel_valid & !read_line_buffer)
            totalPixelCounter <= totalPixelCounter + 1;
        else if(!pixel_valid & read_line_buffer)
            totalPixelCounter <= totalPixelCounter - 1;
    end
end

always @(posedge clk)
begin
    if(reset)
    begin
        rdState <= IDLE;
        read_line_buffer <= 1'b0;
    end
    else
    begin
        case(rdState)
            IDLE:begin
                if(totalPixelCounter >= 2880)
                begin
                    read_line_buffer <= 1'b1;
                    rdState <= RD_BUFFER;
                end
            end
            RD_BUFFER:begin
                if(rdCounter == 479)
                begin
                    rdState <= IDLE;
                    read_line_buffer <= 1'b0;
                end
            end
        endcase
    end
end


//---Write

//handle the column pointer
always @(posedge clk)
begin
    if(reset)
        pixelCounter <= 0;
    else 
    begin
        if(pixel_valid)
            pixelCounter <= pixelCounter + 1;
    end
end



//select the line buffer number to which we have to write
always @(posedge clk)
begin
    if(reset)
        currentWriteLineBufferNum <= 0;
    else
    begin
        if(pixelCounter == 479 & pixel_valid)
            currentWriteLineBufferNum <= (currentWriteLineBufferNum + 1)%7;
    end
end

// write enable for line buffer selected by currentWriteLineBufferNum
always @(*)
begin
    lineBuffDataValid = 7'h0;
    lineBuffDataValid[currentWriteLineBufferNum] = pixel_valid;
end

//---Write



//----Read
//update read counter
always @(posedge clk)
begin
    if(reset)
        rdCounter <= 0;
    else 
    begin
        if(read_line_buffer)
            rdCounter <= rdCounter + 1;
    end
end

// select the set of lines from which to read
always @(posedge clk)
begin
    if(reset)
    begin
        currentReadLineBufferNum <= 0;
    end
    else
    begin
        if(rdCounter == 479 & read_line_buffer)
            currentReadLineBufferNum <= currentReadLineBufferNum + 1;
    end
end
integer p, q;
always @(*)
begin
    for(p=0;p<=6;p=p+1) begin
        if(currentReadLineBufferNum == (p+1)%7) begin
            lineBuffReadData[p] = 1'b0;
        end
        else begin
            lineBuffReadData[p] = read_line_buffer;
        end
    end
end
//----Read

//asign output to window
always @(*)
begin

    for(p=0;p<=5;p=p+1) begin
        for(q=0; q<=5; q=q+1)begin
           window[p][q] = lbOut[(currentReadLineBufferNum+p)%7][q]; 
        end
    end
        
end

assign window_valid = read_line_buffer;


genvar i;

generate   
    for(i=0;i<=6;i=i+1) begin:lbArray
        wire[7:0] lb_out[0:5];

        assign lb_out[0] = lbOut[i][0];
        assign lb_out[1] = lbOut[i][1];
        assign lb_out[2] = lbOut[i][2];
        assign lb_out[3] = lbOut[i][3];
        assign lb_out[4] = lbOut[i][4];
        assign lb_out[5] = lbOut[i][5];
        
        
        lineBuffer lB(
            .i_clk(clk),
            .i_rst(reset),
            .i_data(pixel),
            .i_data_valid(lineBuffDataValid[i]),
            .o_data(lb_out),            
            .i_rd_data(lineBuffReadData[i])
        ); 
    end
  

endgenerate




endmodule