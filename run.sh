#!/bin/sh
python gen_bin.py $1
iverilog -g2012 -f programs.txt
./a.out > corners_output.txt
python display_output.py $1
