import cv2
import numpy as np
import sys

print("Converting image into appropriate format...")
filename="images/chess.jpg"  # Default image for testing

if(len(sys.argv) >= 2):
    filename = str(sys.argv[1])


try:
    print("Image name: ",filename)
    img = cv2.imread(filename)
    if(len(img.shape) == 3 and img.shape[2] == 3):
         img = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
       
    img = cv2.resize(img, (512, 512),interpolation = cv2.INTER_NEAREST)
    img.tofile("file.bin")
    print("Compiling verilog files and simulating...")
except:
    print("Error Occured! Please check the filename or file type(it should be a valid image file)")
    

    
