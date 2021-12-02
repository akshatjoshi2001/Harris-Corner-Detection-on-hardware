module(input [7:0] Gx[0:3][0:3], input clk, input [7:0] Gy[0:3][0:3], output reg [32:0] R, output rdy);

reg [15:0] Matrix[0:1][0:1];
wire [15:0]  det
wire [15:0] trace;


integer i;
integer j;
parameter k = 0.1;

always@(*) begin
Matrix[0][0] = 0;
Matrix[0][1] = 0;
Matrix[1][0] = 0;
Matrix[1][1] = 0;
rdy = 0;

for (i=0; i<=3; i=i+1) begin
  for (j=0; j<=3; j=j+1) begin
  Matrix[0][0] = Gx[i][j]*Gx[i][j] + Matrix[0][0];
  Matrix[0][1] = Gx[i][j]*Gy[i][j] + Matrix[0][1];
  Matrix[1][0] = Gx[i][j]*Gy[i][j] + Matrix[1][0];
  Matrix[1][1] = Gy[i][j]*Gy[i][j] + Matrix[1][1];
  end
end
end


always @(*) begin
det = Matrix[0][0]*Matrix[1][1] - Matrix[0][1]*Matrix[1][0];
trace = Matrix[0][0] + Matrix[1][1];
end


always@(posedge clk) begin
R <= (det - k*trace*trace);
rdy <= 'd1;
end

endmodule