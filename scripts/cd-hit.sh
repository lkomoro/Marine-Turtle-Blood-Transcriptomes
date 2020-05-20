#!/bin/bash
#use cd-hit to cluster sequences based on a sequence identity in fasta format

#BSUB -q short
#BSUB -W 4:00
#BSUB -n 8
#BSUB -R rusage[mem=16000]
#BSUB -R "span[hosts=1]"
#BSUB -e cd-hit.err
#BSUB -o cd-hit.log



/local/path/to/cd-hit-est \
-i path/to/assembly.fasta -o cd-hit-filtered.Trinity.fasta -c 0.95 -n 10 -T 8 -M 16000
