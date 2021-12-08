#!/bin/sh
python3 gen_bin.py $1
iverilog -g2012 -f programs.txt
./a.out > corners_output.txt
python3 display_output.py $1
