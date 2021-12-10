<div id="top"></div>




<!-- PROJECT LOGO -->
<br />
<div align="center">

<h1 align="center">Harris Corner Detection on FPGA</h1>

  <p align="center">
    This project aims to implement the Harris Corner feature detector algorithm using an efficient hardware approach. The effective usage of hardware blocks show that the speed of our feature detector is better than a similar software implementation in real-time.
 
  </p>
</div>

## Contributors

* <b>Prasanna Bartakke</b> EE19B106
* <b>Akshat Joshi</b> EE19B136
* <b>Sarthak Vora</b> EE19B140

Link to the report: <a href="https://github.com/akshatjoshi2001/Harris-Corner-Detection-on-hardware/blob/main/EE2003_Project_Report.pdf">Click here</a>

<!-- ABOUT THE PROJECT -->
## About The Project

Harris Corner Detector is a corner detector operator that is commonly used in computer vision algorithms to extract corners and infer features of an image. The detector algorithm measures the pixel intensity in all directions by taking the differential of the corner score into account. However, the computationally intensive software implementation cannot be executed efficiently on a low-cost CPU. Our implementation optimises memory usage and aims to parallelise the algorithm.

Corners are important features in an image which are invariant to translation, rotation and illumination. Unlike edges, we observe a significant pixel gradient change in all directions in case of corners. Due to this property, shifting a sliding window in any direction leads to a large change in feature computation. This forms the basis of our implementation on hardware and the algorithm finally detects corner points. 



<img src="https://github.com/akshatjoshi2001/Harris-Corner-Detection-on-hardware/blob/main/pipeline.svg" alt="Pipeline" />



<!-- GETTING STARTED -->
## Getting Started

To run the project, follow the below instructions:

### Requirements
* iverilog (Icarus Verilog version 10.3)
* Python 3.x (tested on 3.8)
* OpenCV (tested on version 4.5.4). You can install it using:

  ```sh
  pip install opencv-python
  ```

### Instructions to run

1. Ensure that you have the requirements installed
2. Clone the repo
   ```sh
   git clone https://git.ee2003.dev.iitm.ac.in/ee19b136/Harris-Corner-Detection-on-hardware.git
   ```
3. Test running
   ```sh
   ./run.sh
   ```

4. To run with a different input image
  
   ```sh
   ./run.sh <image path>
   ```
   Example:
   ```sh
   ./run.sh images/chess.jpg
   ```
  
<p align="right">(<a href="#top">back to top</a>)</p>



<!-- USAGE EXAMPLES -->
## Output
Running it on images/chess.jpg the following output is obtained: <br />


<img src="https://github.com/akshatjoshi2001/Harris-Corner-Detection-on-hardware/blob/main/images/chess_output.bmp" /> <br />

The red pixels indicate the detected corners.


<p align="right">(<a href="#top">back to top</a>)</p>


