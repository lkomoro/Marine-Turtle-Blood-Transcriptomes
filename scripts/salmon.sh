#!/bin/bash
#run salmon on one file 

#BSUB -q short
#BSUB -W 4:00
#BSUB -R rusage[mem=8000]
#BSUB -n 12
#BSUB -R span[hosts=1]
#BSUB -e salmon.err
#BSUB -oo salmon.log

module load salmon/1.1.0
index=salmon_index

salmon quant -i $index --libType A -1 sample_R1_SS.fastq  -2 sample_R2_SS.fastq -p 8 -o ./salmon_quant --validateMappings

