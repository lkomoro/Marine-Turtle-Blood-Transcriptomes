#!/bin/bash
# concatenate R1s and R2s for trinity

#BSUB -q long
#BSUB -W 8:00
#BSUB -R rusage[mem=1000]
#BSUB -n 12
#BSUB -R span[hosts=1]
#BSUB -e concat.err
#BSUB -oo concat.log

cd /path/to/trimmed/fastq/files
cat Sample_01_R1_SS.fastq.gz Sample_02_R1_SS.fastq.gz Sample_03_R1_SS.fastq.gz Sample_04_R1_SS.fastq.gz > combined_R1.fastq.gz
cat Sample_01_R2_SS.fastq.gz Sample_02_R2_SS.fastq.gz Sample_03_R2_SS.fastq.gz Sample_04_R2_SS.fastq.gz > combined_R2.fastq.gz
