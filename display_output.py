
import cv2
import numpy as np
import sys


filename="images/chess.jpg"  # Default image for testing

if(len(sys.argv) >= 2):
    filename = str(sys.argv[1])


try:
    img = cv2.imread(filename)
    
       
    img = cv2.resize(img, (512, 512),interpolation = cv2.INTER_NEAREST)
    lines = []    
    ans = []
    with open('corners_output.txt') as fi:
        lines = fi.readlines()

    for i in range(1,len(lines)):
        pos = int(lines[i].strip())
        x = ((pos % 512))
        y = pos // 512
        ans.append([y, x])


    new_img = img.copy()
    for [i, j] in ans:
    #	for p in range(max(0, i-3), min(len(img), i + 3)):
    #		for q in range(max(0, j-3), min(len(img[0]), j + 3)):
        new_img[i][j] = (0, 0, 255)
    cv2.imshow("Harris Detector Output", new_img)  
   
    cv2.waitKey(0)    
    
    cv2.destroyAllWindows() 
except:
    print("Error Occured! Please check the filename or file type(it should be a valid image file)")
    

    



