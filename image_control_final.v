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

wire [7:0] lb0data[0:5];
wire [7:0] lb1data[0:5];
wire [7:0] lb2data[0:5];
wire [7:0] lb3data[0:5];
wire [7:0] lb4data[0:5];
wire [7:0] lb5data[0:5];
wire [7:0] lb6data[0:5];

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
                if(totalPixelCounter >= 3072)
                begin
                    read_line_buffer <= 1'b1;
                    rdState <= RD_BUFFER;
                end
            end
            RD_BUFFER:begin
                count <= count+1;
                if(rdCounter == 511)
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

            pixelCounter <= (pixelCounter + 1);
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
        if(pixelCounter == 511 & pixel_valid)
            currentWriteLineBufferNum <= (currentWriteLineBufferNum + 1)%7;
            //$display("Current Write Line Buffer Num %d",currentWriteLineBufferNum);
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
            rdCounter <= (rdCounter + 1);
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
        if(rdCounter == 511 & read_line_buffer)
            currentReadLineBufferNum <= (currentReadLineBufferNum + 1)%7;
            //$display("Current Read Line Buffer Num %d",currentReadLineBufferNum);
         
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

// always @(*)
// begin

//     for(k=0;k<=5;k=k+1) begin
//         for(q=0; q<=5; q=q+1)begin
//            window[k][q] = lbOut[(currentReadLineBufferNum+k)%7][q]; 
//         end
//     end
        
// end


// genvar i;

// generate   
//     for(i=0;i<=6;i=i+1) begin:lbArray
//         wire[7:0] lb_out[0:5];

//         assign lbOut[i][0] = lb_out[0]; 
//         assign lbOut[i][1] = lb_out[1]; 
//         assign lbOut[i][2] = lb_out[2]; 
//         assign lbOut[i][3] = lb_out[3]; 
//         assign lbOut[i][4] = lb_out[4]; 
//         assign lbOut[i][5] = lb_out[5];
        
        
          
        
//         lineBuffer lB(
//             .i_clk(clk),
//             .i_rst(reset),
//             .i_data(pixel),
//             .i_data_valid(lineBuffDataValid[i]),
//             .o_data(lb_out),            
//             .i_rd_data(lineBuffReadData[i])
//         ); 
//     end
  

// endgenerate

lineBuffer lB0(
    .i_clk(clk),
    .i_rst(reset),
    .i_data(pixel),
    .i_data_valid(lineBuffDataValid[0]),
    .o_data(lb0data),
    .i_rd_data(lineBuffReadData[0])
 ); 

 lineBuffer lB1(
     .i_clk(clk),
    .i_rst(reset),
    .i_data(pixel),
     .i_data_valid(lineBuffDataValid[1]),
     .o_data(lb1data),
     .i_rd_data(lineBuffReadData[1])
  ); 

  lineBuffer lB2(
      .i_clk(clk),
    .i_rst(reset),
    .i_data(pixel),
      .i_data_valid(lineBuffDataValid[2]),
      .o_data(lb2data),
      .i_rd_data(lineBuffReadData[2])
   ); 

   lineBuffer lB3(
       .i_clk(clk),
    .i_rst(reset),
    .i_data(pixel),
       .i_data_valid(lineBuffDataValid[3]),
       .o_data(lb3data),
       .i_rd_data(lineBuffReadData[3])
    );

    lineBuffer lB4(
       .i_clk(clk),
    .i_rst(reset),
    .i_data(pixel),
       .i_data_valid(lineBuffDataValid[4]),
       .o_data(lb4data),
       .i_rd_data(lineBuffReadData[4])
    );

    lineBuffer lB5(
       .i_clk(clk),
    .i_rst(reset),
    .i_data(pixel),
       .i_data_valid(lineBuffDataValid[5]),
       .o_data(lb5data),
       .i_rd_data(lineBuffReadData[5])
    );

    lineBuffer lB6(
       .i_clk(clk),
    .i_rst(reset),
    .i_data(pixel),
       .i_data_valid(lineBuffDataValid[6]),
       .o_data(lb6data),
       .i_rd_data(lineBuffReadData[6])
    );





endmodule