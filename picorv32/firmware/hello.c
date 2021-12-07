
#include "firmware.h"



int getPixel(void);
int calculate_harris_score(int image[7][512],int x,int y);


int getPixel()
{
	
	volatile int* pixel_pointer = (int*) 0x30000010;
	
	return *(pixel_pointer);
}
int calculate_harris_score(int image[7][512],int x,int y)
{	
	
	int Gx[4][4];
	int Gy[4][4];
	int Matrix[2][2];

	for(int i=0;i<4;i++)
	{
		for(int j=0;j<4;j++)
		{
			Gx[i][j] = 1*image[(x+i)%7][y+j] -1*image[(x+i)%7][y+j+2]+2*image[(x+i+1)%7][y+j] -2*image[(x+i+1)%7][y+j+2] +1*image[(x+i+2)%7][y+j] -1*image[(x+i+2)%7][y+j+2];
			Gy[i][j] = 1*image[(x+i)%7][y+j] -1*image[(x+i+2)%7][y+j]+2*image[(x+i)%7][y+j+1] -2*image[(x+i+2)%7][y+j+1] +1*image[(x+i)%7][y+j+2] -1*image[(x+i+2)%7][y+j+2];
			
		
		}
	}
	Matrix[0][0] = 0;
	Matrix[0][1] = 0;
	Matrix[1][0] = 0;
	Matrix[1][1] = 0;

	for(int i=0;i<4;i++)
	{
		for(int j=0;j<4;j++)
		{
			Matrix[0][0] = Matrix[0][0] + Gx[i][j]*Gx[i][j];
			Matrix[0][1] = Matrix[0][1] + Gx[i][j]*Gy[i][j];
			Matrix[1][0] = Matrix[1][0] + Gy[i][j]*Gx[i][j];
			Matrix[1][1] = Matrix[1][1] + Gy[i][j]*Gy[i][j];
			
		}
	}
	
	int trace = (Matrix[0][0]+Matrix[1][1]);
	if(trace<0)
	{
		trace = -trace;
	}
	trace = trace>>8;
	Matrix[0][0] = Matrix[0][0]>>8;
	Matrix[0][1] = Matrix[0][1]>>8;
	Matrix[1][0] = Matrix[1][0]>>8;
	Matrix[1][1] = Matrix[1][1]>>8;
	int det = (Matrix[0][0]*Matrix[1][1]) - (Matrix[1][0]*Matrix[0][1]);	
	

	int trace_sq = ((trace*trace))/128;
	
	int R = det - trace_sq*5;
	return R;
	/*
	if(R>0)
	{
			for(int i=0;i<2;i++)
		{
			for(int j=0;j<2;j++)
			{
				print_dec(Matrix[i][j]);
				print_str(" ");
			}
			print_str("\n");
		}
		print_str("Det:");
		print_dec(det);
		print_str(" Trace:");
		print_dec(trace);

		print_str(" trace_sq:");
		print_dec(trace_sq);
		
		print_str(" R:");
		print_dec(R);

		print_str("\n");
	}
	*/




}

void hello(void)
{
	// C code to compute harris score
	volatile int image[7][512];
	for(int k=0;k<6;k++)
	{
		for(int j=0;j<512;j++)
		{	
			image[k][j] = getPixel();
		
		}
	
	}
	
	for(int j=0;j<506;j++)
	{
		int score = calculate_harris_score(image,0,j);
		if(score>1)
		{
			print_dec(0);
			print_str(" ");
			print_dec(j);
			print_str("\n");			
		}
		
	}
	
	for(int i=1;i<506;i++)
	{
		for(int j=0;j<512;j++)
		{
			image[(i+5)%7][j] = getPixel();
		}
		
		for(int j=0;j<506;j++)
		{
			int score = calculate_harris_score(image,i,j);
			if(score>1)
			{
				print_dec(i);
				print_str(" ");
				print_dec(j);
				print_str("\n");			
			}
		}
		
	}
	
	

}

