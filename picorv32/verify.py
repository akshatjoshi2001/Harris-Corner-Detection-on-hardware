import cv2
import numpy as np
from scipy.signal import convolve2d,correlate2d


img = cv2.imread("chess.jpg",cv2.COLOR_BGR2GRAY)
img = cv2.resize(img, (480, 640),interpolation = cv2.INTER_NEAREST)
cv2.imwrite("android_resize.bmp",img)

img_gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
cv2.imwrite("android.bmp",img_gray)
file = open("pyop.txt", "w")

img_gray.tofile("android.bin")

filterx = np.array([[1,0,-1],[2,0,-2],[1,0,-1]],dtype='int64')
filtery = filterx.T

ans = []
# for j in range(480):
# 	ans.append([100, j])
# for i in range(0,len(img_gray)-6):
# 	for j in range(0,len(img_gray[0])-6):
# 		window = []
# 		for k in range(6):
# 			curr_row = []
# 			for l in range(6):
# 				curr_row.append(img_gray[i + k][j + l])
# 			window.append(curr_row)
		
# 		#print(window)
# 		Gx = correlate2d(window,filterx,mode='valid')
# 		Gy = correlate2d(window,filtery,mode='valid')
# 		# Gx = [[0 for j in range(4)]for i in range(4)]
# 		# Gy = [[0 for j in range(4)]for i in range(4)]

# 		# for i in range(4):
# 		# 	for j in range(4):
# 		# 		Gx[i][j] = 1*(window[i+0][j+0]) -1*window[i+0][j+2] + 2*(window[i+1][j+0]) -2*window[i+1][j+2] + 1*(window[i+2][j+0]) -1*window[i+2][j+2]
# 		# 		Gy[i][j] = 1*(window[i+0][j+0]) -1*window[i+2][j+0] + 2*(window[i+0][j+1]) -2*window[i+2][j+1] + 1*(window[i+0][j+2]) -1*window[i+2][j+2];
# 		# print(Gx, Gy)
# 		#print(len(Gx), len(Gx[0]))
# 		matrix = [[0, 0], [0, 0]]

# 		for p in range(4):
# 			for q in range(4):
# 				matrix[0][0] = Gx[p][q]*Gx[p][q] + matrix[0][0]
# 				matrix[0][1] = Gx[p][q]*Gy[p][q] + matrix[0][1]
# 				matrix[1][0] = Gx[p][q]*Gy[p][q] + matrix[1][0]
# 				matrix[1][1] = Gy[p][q]*Gy[p][q] + matrix[1][1]

# 		det = matrix[0][0]*matrix[1][1] - matrix[0][1]*matrix[1][0]
# 		trace = matrix[0][0] + matrix[1][1]
# 		R = (det - (5/128) * (trace))//(2**32)

# 		# for r in range(2):
# 		# 	for s in range(2):
# 		# 		print(matrix[r][s], end = " ")
# 		# 	print()

# 		if R >= 1:
# 			#print(i + 2, j + 2, R)
# 			ans.append([i+2, j+2])

# 		file.write("==========\n")
# 		file.write(str(i) + "  "+ str(j) + "\n")
# 		file.write("det = " + str(det) + "\n")
# 		file.write("trace = " +  str(-(5/128) * trace) + "\n")
# 		file.write("R = " + str(R) + "\n")
# 		for k in range(0,6):
# 			for l in range(0,6):
# 				file.write(str(img_gray[i+k][j+l]) + " ") 
# 			file.write("\n")

# file.close()



lines = []
with open('tmp.txt') as fi:
    lines = fi.readlines()

for i in range(len(lines)):
	pos = int(lines[i].strip())
	x = ((pos % 474) - 2)
	y = pos // 474
	ans.append([y, x])

new_img = img.copy()
for [i, j] in ans:
	for p in range(max(0, i-3), min(len(img), i + 3)):
		for q in range(max(0, j-3), min(len(img[0]), j + 3)):
			new_img[p][q] = (0, 0, 255)
cv2.imwrite("final.bmp",new_img)
