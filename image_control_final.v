module imageControl(
input                    clk,
input                    reset,
input [7:0]              pixel,
input                    pixel_valid,
output reg [7:0]         window[0:5][0:5],
output                   window_valid,
output reg[63:0]         count
);

// reg 

initial begin
    count = 0;
end

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
                count <= count+1;
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

            pixelCounter <= (pixelCounter + 1)%480;
           // $display("Pixel Count: %d",pixelCounter);
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
    //$display("lineBuffDataValid: %d \n currentWriteLineBufferNum: %d",lineBuffDataValid,currentWriteLineBufferNum);
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
            rdCounter <= (rdCounter + 1)%480;
           // $display("Read Counter %d",rdCounter);
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
            currentReadLineBufferNum <= (currentReadLineBufferNum + 1)%7;
         
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
assign window_valid = read_line_buffer;

//assign window = window_tmp;


integer k;

always @(*)
begin

    for(k=0;k<=5;k=k+1) begin
        for(q=0; q<=5; q=q+1)begin
           window[k][q] = lbOut[(currentReadLineBufferNum+k+1)%7][q]; 
        end
    end
        
end


genvar i;

generate   
    for(i=0;i<=6;i=i+1) begin:lbArray
        wire[7:0] lb_out[0:5];

        assign lbOut[i][0] = lb_out[0]; 
        assign lbOut[i][1] = lb_out[1]; 
        assign lbOut[i][2] = lb_out[2]; 
        assign lbOut[i][3] = lb_out[3]; 
        assign lbOut[i][4] = lb_out[4]; 
        assign lbOut[i][5] = lb_out[5];
        
          
        
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