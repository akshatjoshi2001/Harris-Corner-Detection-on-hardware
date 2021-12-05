module gradient1(input reset,input win_valid,input clk, input [7:0] window[0:5][0:5], output signed [127:0] Harris_R);

     reg signed [8:0]dx1[4:0][4:0];
	 reg signed [8:0]dy1[4:0][4:0];
	 genvar i;
	 generate
		for(i=0; i<=4; i=i+1) begin:HRd
			 always@(posedge clk) begin
				if(1) begin
					dx1[0][i] <= $signed({1'b0, window[1][i+1]}) - $signed({1'b0, window[1][i]});  // unsigned number add a 0 sign bit and treat it as signed number
					dx1[1][i] <= $signed({1'b0, window[2][i+1]}) - $signed({1'b0, window[2][i]});
					dx1[2][i] <= $signed({1'b0, window[3][i+1]}) - $signed({1'b0, window[3][i]});
					dx1[3][i] <= $signed({1'b0, window[4][i+1]}) - $signed({1'b0, window[4][i]});
					dx1[4][i] <= $signed({1'b0, window[5][i+1]}) - $signed({1'b0, window[5][i]});
					
					dy1[i][0] <= $signed({1'b0, window[i+1][1]}) - $signed({1'b0, window[i][1]});
					dy1[i][1] <= $signed({1'b0, window[i+1][2]}) - $signed({1'b0, window[i][2]});
					dy1[i][2] <= $signed({1'b0, window[i+1][3]}) - $signed({1'b0, window[i][3]});
					dy1[i][3] <= $signed({1'b0, window[i+1][4]}) - $signed({1'b0, window[i][4]});
					dy1[i][4] <= $signed({1'b0, window[i+1][5]}) - $signed({1'b0, window[i][5]});

				end
			 end
		end
	 endgenerate
	 
	 reg signed [17:0]dx2_1[4:0][4:0];
	 reg signed [17:0]dy2_1[4:0][4:0];
	 reg signed [17:0]dxdy_1[4:0][4:0];
	 genvar j;
	 generate
		for(j=0; j<=4; j=j+1) begin: HRsq
			always@(posedge clk) begin
				if(1) begin
					dx2_1[0][j] <= dx1[0][j]*dx1[0][j];
					dx2_1[1][j] <= dx1[1][j]*dx1[1][j];
					dx2_1[2][j] <= dx1[2][j]*dx1[2][j];
					dx2_1[3][j] <= dx1[3][j]*dx1[3][j];
					dx2_1[4][j] <= dx1[4][j]*dx1[4][j];
					
					dy2_1[0][j] <= dy1[0][j]*dy1[0][j];
					dy2_1[1][j] <= dy1[1][j]*dy1[1][j];
					dy2_1[2][j] <= dy1[2][j]*dy1[2][j];
					dy2_1[3][j] <= dy1[3][j]*dy1[3][j];
					dy2_1[4][j] <= dy1[4][j]*dy1[4][j];
					
					dxdy_1[0][j] <= dx1[0][j]*dy1[0][j];
					dxdy_1[1][j] <= dx1[1][j]*dy1[1][j];
					dxdy_1[2][j] <= dx1[2][j]*dy1[2][j];
					dxdy_1[3][j] <= dx1[3][j]*dy1[3][j];
					dxdy_1[4][j] <= dx1[4][j]*dy1[4][j];
				end
			end
		end
	 endgenerate
	 



    reg signed [22:0]A00_mid1_1[12:0];
	 reg signed [22:0]A11_mid1_1[12:0];
	 reg signed [22:0]A01_mid1_1[12:0];
	 
	 reg signed [22:0]A00_mid2_1[6:0];
	 reg signed [22:0]A11_mid2_1[6:0];
	 reg signed [22:0]A01_mid2_1[6:0];
	 
	 reg signed [22:0]A00_mid3_1[3:0];
	 reg signed [22:0]A11_mid3_1[3:0];
	 reg signed [22:0]A01_mid3_1[3:0];
	 
	 reg signed [22:0]A00_mid4_1[1:0];
	 reg signed [22:0]A11_mid4_1[1:0];
	 reg signed [22:0]A01_mid4_1[1:0];
	 
	 reg signed [42:0]A00_1;
	 reg signed [42:0]A11_1;
	 reg signed [42:0]A01_1;
	 
	 always@(posedge clk) begin
		if(1) begin
			// s1
			A00_mid1_1[0] <= dx2_1[0][0] + dx2_1[0][1];
			A00_mid1_1[1] <= dx2_1[0][2] + dx2_1[0][3];
			A00_mid1_1[2] <= dx2_1[0][4] + dx2_1[1][0];
			A00_mid1_1[3] <= dx2_1[1][1] + dx2_1[1][2];
			A00_mid1_1[4] <= dx2_1[1][3] + dx2_1[1][4];
			A00_mid1_1[5] <= dx2_1[2][0] + dx2_1[2][1];
			A00_mid1_1[6] <= dx2_1[2][2] + dx2_1[2][3];
			A00_mid1_1[7] <= dx2_1[2][4] + dx2_1[3][0];
			A00_mid1_1[8] <= dx2_1[3][1] + dx2_1[3][2];
			A00_mid1_1[9] <= dx2_1[3][3] + dx2_1[3][4];
			A00_mid1_1[10] <= dx2_1[4][0] + dx2_1[4][1];
			A00_mid1_1[11] <= dx2_1[4][2] + dx2_1[4][3];
			A00_mid1_1[12] <= dx2_1[4][4];
			
			A11_mid1_1[0] <= dy2_1[0][0] + dy2_1[0][1];
			A11_mid1_1[1] <= dy2_1[0][2] + dy2_1[0][3];
			A11_mid1_1[2] <= dy2_1[0][4] + dy2_1[1][0];
			A11_mid1_1[3] <= dy2_1[1][1] + dy2_1[1][2];
			A11_mid1_1[4] <= dy2_1[1][3] + dy2_1[1][4];
			A11_mid1_1[5] <= dy2_1[2][0] + dy2_1[2][1];
			A11_mid1_1[6] <= dy2_1[2][2] + dy2_1[2][3];
			A11_mid1_1[7] <= dy2_1[2][4] + dy2_1[3][0];
			A11_mid1_1[8] <= dy2_1[3][1] + dy2_1[3][2];
			A11_mid1_1[9] <= dy2_1[3][3] + dy2_1[3][4];
			A11_mid1_1[10] <= dy2_1[4][0] + dy2_1[4][1];
			A11_mid1_1[11] <= dy2_1[4][2] + dy2_1[4][3];
			A11_mid1_1[12] <= dy2_1[4][4];
			
			A01_mid1_1[0] <= dxdy_1[0][0] + dxdy_1[0][1];
			A01_mid1_1[1] <= dxdy_1[0][2] + dxdy_1[0][3];
			A01_mid1_1[2] <= dxdy_1[0][4] + dxdy_1[1][0];
			A01_mid1_1[3] <= dxdy_1[1][1] + dxdy_1[1][2];
			A01_mid1_1[4] <= dxdy_1[1][3] + dxdy_1[1][4];
			A01_mid1_1[5] <= dxdy_1[2][0] + dxdy_1[2][1];
			A01_mid1_1[6] <= dxdy_1[2][2] + dxdy_1[2][3];
			A01_mid1_1[7] <= dxdy_1[2][4] + dxdy_1[3][0];
			A01_mid1_1[8] <= dxdy_1[3][1] + dxdy_1[3][2];
			A01_mid1_1[9] <= dxdy_1[3][3] + dxdy_1[3][4];
			A01_mid1_1[10] <= dxdy_1[4][0] + dxdy_1[4][1];
			A01_mid1_1[11] <= dxdy_1[4][2] + dxdy_1[4][3];
			A01_mid1_1[12] <= dxdy_1[4][4];
			
			// s2
			A00_mid2_1[0] <= A00_mid1_1[0] + A00_mid1_1[1];
			A00_mid2_1[1] <= A00_mid1_1[2] + A00_mid1_1[3];
			A00_mid2_1[2] <= A00_mid1_1[4] + A00_mid1_1[5];
			A00_mid2_1[3] <= A00_mid1_1[6] + A00_mid1_1[7];
			A00_mid2_1[4] <= A00_mid1_1[8] + A00_mid1_1[9];
			A00_mid2_1[5] <= A00_mid1_1[10] + A00_mid1_1[11];
			A00_mid2_1[6] <= A00_mid1_1[12];
			
			A11_mid2_1[0] <= A11_mid1_1[0] + A11_mid1_1[1];
			A11_mid2_1[1] <= A11_mid1_1[2] + A11_mid1_1[3];
			A11_mid2_1[2] <= A11_mid1_1[4] + A11_mid1_1[5];
			A11_mid2_1[3] <= A11_mid1_1[6] + A11_mid1_1[7];
			A11_mid2_1[4] <= A11_mid1_1[8] + A11_mid1_1[9];
			A11_mid2_1[5] <= A11_mid1_1[10] + A11_mid1_1[11];
			A11_mid2_1[6] <= A11_mid1_1[12];
			
			A01_mid2_1[0] <= A01_mid1_1[0] + A01_mid1_1[1];
			A01_mid2_1[1] <= A01_mid1_1[2] + A01_mid1_1[3];
			A01_mid2_1[2] <= A01_mid1_1[4] + A01_mid1_1[5];
			A01_mid2_1[3] <= A01_mid1_1[6] + A01_mid1_1[7];
			A01_mid2_1[4] <= A01_mid1_1[8] + A01_mid1_1[9];
			A01_mid2_1[5] <= A01_mid1_1[10] + A01_mid1_1[11];
			A01_mid2_1[6] <= A01_mid1_1[12];
			
			// s3
			A00_mid3_1[0] <= A00_mid2_1[0] + A00_mid2_1[1];
			A00_mid3_1[1] <= A00_mid2_1[2] + A00_mid2_1[3];
			A00_mid3_1[2] <= A00_mid2_1[4] + A00_mid2_1[5];
			A00_mid3_1[3] <= A00_mid2_1[6];
			
			A11_mid3_1[0] <= A11_mid2_1[0] + A11_mid2_1[1];
			A11_mid3_1[1] <= A11_mid2_1[2] + A11_mid2_1[3];
			A11_mid3_1[2] <= A11_mid2_1[4] + A11_mid2_1[5];
			A11_mid3_1[3] <= A11_mid2_1[6];
			
			A01_mid3_1[0] <= A01_mid2_1[0] + A01_mid2_1[1];
			A01_mid3_1[1] <= A01_mid2_1[2] + A01_mid2_1[3];
			A01_mid3_1[2] <= A01_mid2_1[4] + A01_mid2_1[5];
			A01_mid3_1[3] <= A01_mid2_1[6];
			
			// s4
			A00_mid4_1[0] <= A00_mid3_1[0] + A00_mid3_1[1];
			A00_mid4_1[1] <= A00_mid3_1[2] + A00_mid3_1[3];
			
			A11_mid4_1[0] <= A11_mid3_1[0] + A11_mid3_1[1];
			A11_mid4_1[1] <= A11_mid3_1[2] + A11_mid3_1[3];
			
			A01_mid4_1[0] <= A01_mid3_1[0] + A01_mid3_1[1];
			A01_mid4_1[1] <= A01_mid3_1[2] + A01_mid3_1[3];
			
			// s5
			A00_1 <= A00_mid4_1[0] + A00_mid4_1[1];
			A11_1 <= A11_mid4_1[0] + A11_mid4_1[1];
			A01_1 <= A01_mid4_1[0] + A01_mid4_1[1];
		end
	 end

	 reg signed [85:0]A00mulA11_1;
	 reg signed [85:0]A01mulA10_1;
	 reg signed [43:0]A00plusA11_1;
	 always@(posedge clk) begin
		if(1) begin
			A00mulA11_1 <= A00_1 * A11_1;
			A01mulA10_1 <= A01_1 * A01_1; // A01 and A10 are the same
			A00plusA11_1 <= A00_1 + A11_1;
		end
	 end
	 
		 
	 reg signed [85:0]A00mulA11_sub_A01mulA10_1;
	 reg signed [43:0]A00plusA11_div25_1;
	 reg signed [127:0]Harris_R;
	 reg is_feat;
	 wire signed [48:0]A00plusA11_1_mul5;
	 assign A00plusA11_1_mul5 = A00plusA11_1 * $signed(3'd5);
	 always@(posedge clk) begin
		if(1) begin
			A00mulA11_sub_A01mulA10_1 <= A00mulA11_1 - A01mulA10_1;
			//A00plusA11_div25_1 <= A00plusA11_1 / $signed(5'd25);
			A00plusA11_div25_1 <= A00plusA11_1_mul5[26:7];  // 5/128 = 0.39
			
			Harris_R <= A00mulA11_sub_A01mulA10_1 - A00plusA11_div25_1;  // det(A) - 0.04*trace(A)
            //Harris_R <= (Harris_R >> 16);
		end

        //$display("Det = %d, Trace = %d, Harris Score = %d", A00mulA11_sub_A01mulA10_1, A00plusA11_div25_1, Harris_R);
	 end
     
endmodule