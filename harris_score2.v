module harris_score(input signed [15:0] Gx[0:3][0:3], input clk, input signed [15:0] Gy[0:3][0:3], output reg [63:0] R, output rdy);

wire signed [63:0] Matrix[0:1][0:1];
wire signed [63:0]  det;
wire signed [63:0] trace;
wire signed [63:0] R_;
wire signed [63:0] trace_sq;
wire signed [63:0] trace_sq_scaled;


reg rdy;

integer i;
integer j;



assign Matrix[0][0] = Gx[0][0]*Gx[0][0] + Gx[0][1]*Gx[0][1] + Gx[0][2]*Gx[0][2] + Gx[0][3]*Gx[0][3] + Gx[1][0]*Gx[1][0] + Gx[1][1]*Gx[1][1] + Gx[1][2]*Gx[1][2] + Gx[1][3]*Gx[1][3] + Gx[2][0]*Gx[2][0] + Gx[2][1]*Gx[2][1] + Gx[2][2]*Gx[2][2] + Gx[2][3]*Gx[2][3] + Gx[3][0]*Gx[3][0] + Gx[3][1]*Gx[3][1] + Gx[3][2]*Gx[3][2] + Gx[3][3]*Gx[3][3];
assign Matrix[0][1] = Gx[0][0]*Gy[0][0] + Gx[0][1]*Gy[0][1] + Gx[0][2]*Gy[0][2] + Gx[0][3]*Gy[0][3] + Gx[1][0]*Gy[1][0] + Gx[1][1]*Gy[1][1] + Gx[1][2]*Gy[1][2] + Gx[1][3]*Gy[1][3] + Gx[2][0]*Gy[2][0] + Gx[2][1]*Gy[2][1] + Gx[2][2]*Gy[2][2] + Gx[2][3]*Gy[2][3] + Gx[3][0]*Gy[3][0] + Gx[3][1]*Gy[3][1] + Gx[3][2]*Gy[3][2] + Gx[3][3]*Gy[3][3];
assign Matrix[1][0] = Gx[0][0]*Gy[0][0] + Gx[0][1]*Gy[0][1] + Gx[0][2]*Gy[0][2] + Gx[0][3]*Gy[0][3] + Gx[1][0]*Gy[1][0] + Gx[1][1]*Gy[1][1] + Gx[1][2]*Gy[1][2] + Gx[1][3]*Gy[1][3] + Gx[2][0]*Gy[2][0] + Gx[2][1]*Gy[2][1] + Gx[2][2]*Gy[2][2] + Gx[2][3]*Gy[2][3] + Gx[3][0]*Gy[3][0] + Gx[3][1]*Gy[3][1] + Gx[3][2]*Gy[3][2] + Gx[3][3]*Gy[3][3];
assign Matrix[1][1] = Gy[0][0]*Gy[0][0] + Gy[0][1]*Gy[0][1] + Gy[0][2]*Gy[0][2] + Gy[0][3]*Gy[0][3] + Gy[1][0]*Gy[1][0] + Gy[1][1]*Gy[1][1] + Gy[1][2]*Gy[1][2] + Gy[1][3]*Gy[1][3] + Gy[2][0]*Gy[2][0] + Gy[2][1]*Gy[2][1] + Gy[2][2]*Gy[2][2] + Gy[2][3]*Gy[2][3] + Gy[3][0]*Gy[3][0] + Gy[3][1]*Gy[3][1] + Gy[3][2]*Gy[3][2] + Gy[3][3]*Gy[3][3];

assign det = Matrix[0][0]*Matrix[1][1] - Matrix[0][1]*Matrix[1][0];
assign trace = Matrix[0][0]+ Matrix[1][1];
assign trace_sq = 5*trace*trace;
assign trace_sq_scaled = trace_sq[63:7];




assign R_ = det-trace_sq_scaled;



integer p;
integer q;

always@(posedge clk) begin
  
  R <=  R_;
  // for (p=0; p<2; p=p+1) begin
  //   for (q=0; q<2; q=q+1) begin
  //     $write("%d ",Matrix[p][q]);
  //   end
  //   $write("\n");
  // end
  //$display("Determinant = %d, Trace = %d, R=%d ", $signed(det), $signed(trace_sq_scaled),$signed(R_));
  rdy <= 'd1;
end

endmodule