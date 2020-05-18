#!/bin/bash
#salmon1.1 on Dc tissues

#BSUB -q short
#BSUB -W 4:00
#BSUB -R rusage[mem=8000]
#BSUB -n 12
#BSUB -R span[hosts=1]
#BSUB -e salmon.err
#BSUB -oo salmon.log

module load salmon/1.1.0
index=Tsalmon_index
#index is same folder as generated with salmon_index

loc=/project/uma_lisa_komoroske/Kenyon/assemblies/lung/trimmed
salmon quant -i $index --libType A -1 $loc/rDerCor_LG1_S4_R1_SS.fastq  -2 $loc/rDerCor_LG1_S4_R2_SS.fastq -p 8 -o ./salmon_quant --validateMappings

