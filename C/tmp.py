
import cv2
import numpy as np
from scipy.signal import convolve2d,correlate2d

filterx = np.array([[1,0,-1],[2,0,-2],[1,0,-1]],dtype='int64')
filtery = filterx.T


window = [[255,255,255,255,255,255],[255,255,255,255,255,255],[255,255,255,255,255,255],[255,255,255,255,255,255],[0,  0,116,116,255,255,],[0,  0,116,116,255,255]]
print(window)
Gx = [[0 for j in range(4)]for i in range(4)]
Gy = [[0 for j in range(4)]for i in range(4)]

for i in range(4):
	for j in range(4):
		Gx[i][j] = 1*(window[i+0][j+0]) -1*window[i+0][j+2] + 2*(window[i+1][j+0]) -2*window[i+1][j+2] + 1*(window[i+2][j+0]) -1*window[i+2][j+2]
		Gy[i][j] = 1*(window[i+0][j+0]) -1*window[i+2][j+0] + 2*(window[i+0][j+1]) -2*window[i+2][j+1] + 1*(window[i+0][j+2]) -1*window[i+2][j+2];
#print(len(Gx), len(Gx[0]))
matrix = [[0, 0], [0, 0]]

for p in range(4):
	for q in range(4):
		matrix[0][0] = Gx[p][q]*Gx[p][q] + matrix[0][0]
		matrix[0][1] = Gx[p][q]*Gy[p][q] + matrix[0][1]
		matrix[1][0] = Gx[p][q]*Gy[p][q] + matrix[1][0]
		matrix[1][1] = Gy[p][q]*Gy[p][q] + matrix[1][1]

det = matrix[0][0]*matrix[1][1] - matrix[0][1]*matrix[1][0]
trace = matrix[0][0] + matrix[1][1]
R = (det - (5/128) * (trace)**2)

print(Gx)
print(Gy)
print(matrix)

print(det, - (5/128) * (trace)**2, R)