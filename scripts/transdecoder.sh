#!/bin/bash
# Extract the Longest open reading frames and predict likely coding regions from transcriptome assemblies

#BSUB -q short
#BSUB -W 4:00
#BSUB -R rusage[mem=16000]
#BSUB -n 4
#BSUB -R span[hosts=1]

module load  transdecoder/5.5.0
module load R/3.6.0
module load gcc/8.1.0

assembly=/path/to/filtered/assembly.fa

TransDecoder.LongOrfs -t $assembly
TransDecoder.Predict -t $assembly --single_best_only
