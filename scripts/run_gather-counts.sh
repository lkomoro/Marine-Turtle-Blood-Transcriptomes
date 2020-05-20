#!/bin/bash
#Script to run gather-counts.py
#run in direcotry containing all salmon quant directories
#need to have gather-counts.py script installed

#BSUB -q short
#BSUB -W 1:00
#BSUB -R rusage[mem=4000]
#BSUB -n 1
#BSUB -R span[hosts=1]
#BSUB -e counts.err
#BSUB -oo counts.log

module load python/2.7.9

python2 path/to/script/gather-counts.py
