module harris_score(input [15:0] Gx[0:3][0:3], input clk, input [15:0] Gy[0:3][0:3], output reg [63:0] R, output rdy);

reg [63:0] Matrix[0:1][0:1];
reg [63:0]  det;
reg [63:0] trace;
reg rdy;

integer i;
integer j;

always@(*) begin
Matrix[0][0] = 0;
Matrix[0][1] = 0;
Matrix[1][0] = 0;
Matrix[1][1] = 0;
rdy = 0;

for (i=0; i<=3; i=i+1) begin
  for (j=0; j<=3; j=j+1) begin
  Matrix[0][0] = $signed(Gx[i][j]*Gx[i][j] + Matrix[0][0]);
  Matrix[0][1] = $signed(Gx[i][j]*Gy[i][j] + Matrix[0][1]);
  Matrix[1][0] = $signed(Gx[i][j]*Gy[i][j] + Matrix[1][0]);
  Matrix[1][1] = $signed(Gy[i][j]*Gy[i][j] + Matrix[1][1]);
  end
end
end


always @(*) begin
det = Matrix[0][0]*Matrix[1][1] - Matrix[0][1]*Matrix[1][0];
trace = Matrix[0][0] + Matrix[1][1];
end


always@(posedge clk) begin
  $display("Det = %d, Trace = %d", det, trace);
  R <= $signed(det - (5*trace*trace)>>7);
  rdy <= 'd1;
end

endmodule