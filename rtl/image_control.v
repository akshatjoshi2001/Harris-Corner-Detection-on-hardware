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

reg [12:0] totalPixelCounter;
reg [8:0] pixelCounter;
reg [8:0] rdCounter;

reg [2:0] currentWriteLineBufferNum;
reg [2:0] currentReadLineBufferNum;

reg [6:0] lineBuffDataValid;
reg [6:0] lineBuffReadData;
reg readLineBuffer;

reg readState;
integer p, q, k;


wire [7:0] lb0data[0:5];
wire [7:0] lb1data[0:5];
wire [7:0] lb2data[0:5];
wire [7:0] lb3data[0:5];
wire [7:0] lb4data[0:5];
wire [7:0] lb5data[0:5];
wire [7:0] lb6data[0:5];

localparam IDLE_STATE = 'b0,
           RD_BUFFER_STATE = 'b1;

always @(posedge clk)
begin
    if(reset)
        totalPixelCounter <= 0;
    else
    begin
        if(pixel_valid & !readLineBuffer)
            totalPixelCounter <= totalPixelCounter + 1;
        else if(!pixel_valid & readLineBuffer)
            totalPixelCounter <= totalPixelCounter - 1;
    end
end

always @(posedge clk)
    begin
        if(reset)
        begin
            readState <= IDLE_STATE;
            readLineBuffer <= 1'b0;
        end
        else
        begin
            case(readState)
                IDLE_STATE:begin
                    if(totalPixelCounter >= 3072)
                        begin
                            readLineBuffer <= 1'b1;
                            readState <= RD_BUFFER_STATE;
                        end
                    end
                RD_BUFFER_STATE:begin
                    count <= count+1;
                    if(rdCounter == 511)
                        begin
                            readState <= IDLE_STATE;
                            readLineBuffer <= 1'b0;
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
                    pixelCounter <= (pixelCounter + 1);
            end
    end



//select the line buffer number to which we have to write
always @(posedge clk)
    begin
        if(reset)
            currentWriteLineBufferNum <= 0;
        else
            begin
                if(pixelCounter == 511 & pixel_valid)
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
                if(readLineBuffer)
                    rdCounter <= (rdCounter + 1);
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
                if(rdCounter == 511 & readLineBuffer)
                    currentReadLineBufferNum <= (currentReadLineBufferNum + 1)%7;         
            end
    end

always @(*)
    begin
        for(p=0;p<=6;p=p+1) begin
            if(currentReadLineBufferNum == (p+1)%7) begin
                lineBuffReadData[p] = 1'b0;
            end
            else begin
                lineBuffReadData[p] = readLineBuffer;
            end
        end
    end
//----Read

//asign output to window
assign window_valid = readLineBuffer;

//store data from line buffers into the window
always @(*)
begin
    case(currentReadLineBufferNum)
        0:begin
            for(q=0; q<=5; q=q+1)begin
                window[0][q] = lb0data[q];
            end
            for(q=0; q<=5; q=q+1)begin
                window[1][q] = lb1data[q];
            end
            for(q=0; q<=5; q=q+1)begin
                window[2][q] = lb2data[q];
            end
            for(q=0; q<=5; q=q+1)begin
                window[3][q] = lb3data[q];
            end
            for(q=0; q<=5; q=q+1)begin
                window[4][q] = lb4data[q];
            end
            for(q=0; q<=5; q=q+1)begin
                window[5][q] = lb5data[q];
            end
        end
        1:begin
            for(q=0; q<=5; q=q+1)begin
                window[0][q] = lb1data[q];
            end
            for(q=0; q<=5; q=q+1)begin
                window[1][q] = lb2data[q];
            end
            for(q=0; q<=5; q=q+1)begin
                window[2][q] = lb3data[q];
            end
            for(q=0; q<=5; q=q+1)begin
                window[3][q] = lb4data[q];
            end
            for(q=0; q<=5; q=q+1)begin
                window[4][q] = lb5data[q];
            end
            for(q=0; q<=5; q=q+1)begin
                window[5][q] = lb6data[q];
            end
        end
        2:begin
            for(q=0; q<=5; q=q+1)begin
                window[0][q] = lb2data[q];
            end
            for(q=0; q<=5; q=q+1)begin
                window[1][q] = lb3data[q];
            end
            for(q=0; q<=5; q=q+1)begin
                window[2][q] = lb4data[q];
            end
            for(q=0; q<=5; q=q+1)begin
                window[3][q] = lb5data[q];
            end
            for(q=0; q<=5; q=q+1)begin
                window[4][q] = lb6data[q];
            end
            for(q=0; q<=5; q=q+1)begin
                window[5][q] = lb0data[q];
            end
        end
        3:begin
            for(q=0; q<=5; q=q+1)begin
                window[0][q] = lb3data[q];
            end
            for(q=0; q<=5; q=q+1)begin
                window[1][q] = lb4data[q];
            end
            for(q=0; q<=5; q=q+1)begin
                window[2][q] = lb5data[q];
            end
            for(q=0; q<=5; q=q+1)begin
                window[3][q] = lb6data[q];
            end
            for(q=0; q<=5; q=q+1)begin
                window[4][q] = lb0data[q];
            end
            for(q=0; q<=5; q=q+1)begin
                window[5][q] = lb1data[q];
            end
        end
        4:begin
            for(q=0; q<=5; q=q+1)begin
                window[0][q] = lb4data[q];
            end
            for(q=0; q<=5; q=q+1)begin
                window[1][q] = lb5data[q];
            end
            for(q=0; q<=5; q=q+1)begin
                window[2][q] = lb6data[q];
            end
            for(q=0; q<=5; q=q+1)begin
                window[3][q] = lb0data[q];
            end
            for(q=0; q<=5; q=q+1)begin
                window[4][q] = lb1data[q];
            end
            for(q=0; q<=5; q=q+1)begin
                window[5][q] = lb2data[q];
            end
        end
        5:begin
            for(q=0; q<=5; q=q+1)begin
                window[0][q] = lb5data[q];
            end
            for(q=0; q<=5; q=q+1)begin
                window[1][q] = lb6data[q];
            end
            for(q=0; q<=5; q=q+1)begin
                window[2][q] = lb0data[q];
            end
            for(q=0; q<=5; q=q+1)begin
                window[3][q] = lb1data[q];
            end
            for(q=0; q<=5; q=q+1)begin
                window[4][q] = lb2data[q];
            end
            for(q=0; q<=5; q=q+1)begin
                window[5][q] = lb3data[q];
            end
        end
        6:begin
            for(q=0; q<=5; q=q+1)begin
                window[0][q] = lb6data[q];
            end
            for(q=0; q<=5; q=q+1)begin
                window[1][q] = lb0data[q];
            end
            for(q=0; q<=5; q=q+1)begin
                window[2][q] = lb1data[q];
            end
            for(q=0; q<=5; q=q+1)begin
                window[3][q] = lb2data[q];
            end
            for(q=0; q<=5; q=q+1)begin
                window[4][q] = lb3data[q];
            end
            for(q=0; q<=5; q=q+1)begin
                window[5][q] = lb4data[q];
            end
        end

    endcase
end

lineBuffer lB0(
    .clk(clk),
    .reset(reset),
    .input_data(pixel),
    .input_valid(lineBuffDataValid[0]),
    .output_data(lb0data),
    .input_read_data(lineBuffReadData[0])
 ); 

 lineBuffer lB1(
     .clk(clk),
    .reset(reset),
    .input_data(pixel),
     .input_valid(lineBuffDataValid[1]),
     .output_data(lb1data),
     .input_read_data(lineBuffReadData[1])
  ); 

  lineBuffer lB2(
      .clk(clk),
    .reset(reset),
    .input_data(pixel),
      .input_valid(lineBuffDataValid[2]),
      .output_data(lb2data),
      .input_read_data(lineBuffReadData[2])
   ); 

   lineBuffer lB3(
       .clk(clk),
    .reset(reset),
    .input_data(pixel),
       .input_valid(lineBuffDataValid[3]),
       .output_data(lb3data),
       .input_read_data(lineBuffReadData[3])
    );

    lineBuffer lB4(
       .clk(clk),
    .reset(reset),
    .input_data(pixel),
       .input_valid(lineBuffDataValid[4]),
       .output_data(lb4data),
       .input_read_data(lineBuffReadData[4])
    );

    lineBuffer lB5(
       .clk(clk),
    .reset(reset),
    .input_data(pixel),
       .input_valid(lineBuffDataValid[5]),
       .output_data(lb5data),
       .input_read_data(lineBuffReadData[5])
    );

    lineBuffer lB6(
       .clk(clk),
    .reset(reset),
    .input_data(pixel),
       .input_valid(lineBuffDataValid[6]),
       .output_data(lb6data),
       .input_read_data(lineBuffReadData[6])
    );

endmodule
