# convert sRGB to .bmp
import cv2
import numpy as np
#import matplotlib.pyplot as plt 


def image_read(filepath):

    image = cv2.imread(filepath)
    image = cv2.resize(image, (640,480), interpolation = cv2.INTER_AREA) # resize

    # extract R, G, B pixels
    Rpixel = image[:,:,2]
    GPixel = image[:,:,1]
    BPixel = image[:,:,0]

    # write image in a file
    np.savetxt('r_image.mem', Rpixel)
    np.savetxt('G_image.mem', Gpixel)
    np.savetxt('b_image.mem', Bpixel)
    
    return 0



