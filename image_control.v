module imageControl(
input                    i_clk,
input                    i_rst,
input [7:0]              i_pixel_data,
input                    i_pixel_data_valid,
//output reg [287:0]       o_pixel_data,
output reg [7:0]         o_2d_pixel_data[0:5][0:5],
output                   o_pixel_data_valid,
output reg               o_intr
);
//counters
reg [8:0] pixelCounter;
reg [8:0] rdCounter;
reg [12:0] totalPixelCounter;


//line buffer pointer
reg [2:0] currentWrLineBuffer;
reg [2:0] currentRdLineBuffer;
reg [6:0] lineBuffDataValid;
reg [6:0] lineBuffRdData;

//width = 6
wire [47:0] lb0data;
wire [47:0] lb1data;
wire [47:0] lb2data;
wire [47:0] lb3data;
wire [47:0] lb4data;
wire [47:0] lb5data;
wire [47:0] lb6data;

reg rd_line_buffer;
reg rdState;

assign o_pixel_data_valid = rd_line_buffer;


localparam IDLE = 'b0,
           RD_BUFFER = 'b1;


always @(posedge i_clk)
begin
    if(i_rst)
        totalPixelCounter <= 0;
    else
    begin
        if(i_pixel_data_valid & !rd_line_buffer)
            totalPixelCounter <= totalPixelCounter + 1;
        else if(!i_pixel_data_valid & rd_line_buffer)
            totalPixelCounter <= totalPixelCounter - 1;
    end
end

always @(posedge i_clk)
begin
    if(i_rst)
    begin
        rdState <= IDLE;
        rd_line_buffer <= 1'b0;
        o_intr <= 1'b0;
    end
    else
    begin
        case(rdState)
            IDLE:begin
                o_intr <= 1'b0;
                if(totalPixelCounter >= 2880)
                begin
                    rd_line_buffer <= 1'b1;
                    rdState <= RD_BUFFER;
                end
            end
            RD_BUFFER:begin
                if(rdCounter == 479)
                begin
                    rdState <= IDLE;
                    rd_line_buffer <= 1'b0;
                    o_intr <= 1'b1;
                end
            end
        endcase
    end
end

always @(posedge i_clk)
begin
    if(i_rst)
        pixelCounter <= 0;
    else 
    begin
        if(i_pixel_data_valid)
            pixelCounter <= pixelCounter + 1;
    end
end

always @(posedge i_clk)
begin
    if(i_rst)
        currentWrLineBuffer <= 0;
    else
    begin
        if(pixelCounter == 479 & i_pixel_data_valid)
            currentWrLineBuffer <= currentWrLineBuffer+1;
    end
end

always @(posedge i_clk)
begin
    if(i_rst)
    begin
        currentRdLineBuffer <= 0;
    end
    else
    begin
        if(rdCounter == 479 & rd_line_buffer)
            currentRdLineBuffer <= currentRdLineBuffer + 1;
    end
end



always @(*)
begin
    lineBuffDataValid = 7'h0;
    lineBuffDataValid[currentWrLineBuffer] = i_pixel_data_valid;
end

always @(*)
begin
    case(currentRdLineBuffer)
        0:begin
            o_pixel_data = {lb5data, lb4data, lb3data, lb2data, lb1data, lb0data};
        end
        1:begin
            o_pixel_data = {lb6data, lb5data, lb4data, lb3data, lb2data, lb1data};
        end
        2:begin
            o_pixel_data = {lb0data, lb6data, lb5data, lb4data, lb3data, lb2data};
        end
        3:begin
            o_pixel_data = {lb1data, lb0data, lb6data, lb5data, lb4data, lb3data};
        end
        4:begin
            o_pixel_data = {lb2data, lb1data, lb0data, lb6data, lb5data, lb4data};
        end
        5:begin
            o_pixel_data = {lb3data, lb2data, lb1data, lb0data, lb6data, lb5data};
        end
        6:begin
            o_pixel_data = {lb2data, lb3data, lb2data, lb1data, lb0data, lb6data};
        end

    endcase
    
end

always @(*)
begin
    case(currentRdLineBuffer)
        0:begin
            lineBuffRdData[0] = rd_line_buffer;
            lineBuffRdData[1] = rd_line_buffer;
            lineBuffRdData[2] = rd_line_buffer;
            lineBuffRdData[3] = rd_line_buffer;
            lineBuffRdData[4] = rd_line_buffer;
            lineBuffRdData[5] = rd_line_buffer;
            lineBuffRdData[6] = 1'b0;
        end
       1:begin
            lineBuffRdData[0] = 1'b0;
            lineBuffRdData[1] = rd_line_buffer;
            lineBuffRdData[2] = rd_line_buffer;
            lineBuffRdData[3] = rd_line_buffer;
            lineBuffRdData[4] = rd_line_buffer;
            lineBuffRdData[5] = rd_line_buffer;
            lineBuffRdData[6] = rd_line_buffer;
        end
       2:begin
             lineBuffRdData[0] = rd_line_buffer;
            lineBuffRdData[1] = 1'b0;
            lineBuffRdData[2] = rd_line_buffer;
            lineBuffRdData[3] = rd_line_buffer;
            lineBuffRdData[4] = rd_line_buffer;
            lineBuffRdData[5] = rd_line_buffer;
            lineBuffRdData[6] = rd_line_buffer;
       end  
      3:begin
             lineBuffRdData[0] = rd_line_buffer;
            lineBuffRdData[1] = rd_line_buffer;
            lineBuffRdData[2] = 1'b0;
            lineBuffRdData[3] = rd_line_buffer;
            lineBuffRdData[4] = rd_line_buffer;
            lineBuffRdData[5] = rd_line_buffer;
            lineBuffRdData[6] = rd_line_buffer;
       end   
       4:begin
             lineBuffRdData[0] = rd_line_buffer;
            lineBuffRdData[1] = rd_line_buffer;
            lineBuffRdData[2] = rd_line_buffer;
            lineBuffRdData[3] = 1'b0;
            lineBuffRdData[4] = rd_line_buffer;
            lineBuffRdData[5] = rd_line_buffer;
            lineBuffRdData[6] = rd_line_buffer;
       end   
       5:begin
             lineBuffRdData[0] = rd_line_buffer;
            lineBuffRdData[1] = rd_line_buffer;
            lineBuffRdData[2] = rd_line_buffer;
            lineBuffRdData[3] = rd_line_buffer;
            lineBuffRdData[4] = 1'b0;
            lineBuffRdData[5] = rd_line_buffer;
            lineBuffRdData[6] = rd_line_buffer;
       end   
       6:begin
             lineBuffRdData[0] = rd_line_buffer;
            lineBuffRdData[1] = rd_line_buffer;
            lineBuffRdData[2] = rd_line_buffer;
            lineBuffRdData[3] = rd_line_buffer;
            lineBuffRdData[4] = rd_line_buffer;
            lineBuffRdData[5] = 1'b0;
            lineBuffRdData[6] = rd_line_buffer;
       end        
    endcase
end

lineBuffer lB0(
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_data(i_pixel_data),
    .i_data_valid(lineBuffDataValid[0]),
    .o_data(lb0data),
    .i_rd_data(lineBuffRdData[0])
 ); 
 
 lineBuffer lB1(
     .i_clk(i_clk),
     .i_rst(i_rst),
     .i_data(i_pixel_data),
     .i_data_valid(lineBuffDataValid[1]),
     .o_data(lb1data),
     .i_rd_data(lineBuffRdData[1])
  ); 
  
  lineBuffer lB2(
      .i_clk(i_clk),
      .i_rst(i_rst),
      .i_data(i_pixel_data),
      .i_data_valid(lineBuffDataValid[2]),
      .o_data(lb2data),
      .i_rd_data(lineBuffRdData[2])
   ); 
   
   lineBuffer lB3(
       .i_clk(i_clk),
       .i_rst(i_rst),
       .i_data(i_pixel_data),
       .i_data_valid(lineBuffDataValid[3]),
       .o_data(lb3data),
       .i_rd_data(lineBuffRdData[3])
    );

    lineBuffer lB4(
       .i_clk(i_clk),
       .i_rst(i_rst),
       .i_data(i_pixel_data),
       .i_data_valid(lineBuffDataValid[4]),
       .o_data(lb4data),
       .i_rd_data(lineBuffRdData[4])
    );

    lineBuffer lB5(
       .i_clk(i_clk),
       .i_rst(i_rst),
       .i_data(i_pixel_data),
       .i_data_valid(lineBuffDataValid[5]),
       .o_data(lb5data),
       .i_rd_data(lineBuffRdData[5])
    );

    lineBuffer lB6(
       .i_clk(i_clk),
       .i_rst(i_rst),
       .i_data(i_pixel_data),
       .i_data_valid(lineBuffDataValid[6]),
       .o_data(lb6data),
       .i_rd_data(lineBuffRdData[6])
    );
  
    
endmodule
