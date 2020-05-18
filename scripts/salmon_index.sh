#!/bin/bash
#index trinity assembly for salmon

#BSUB -q short
#BSUB -W 2:00
#BSUB -R rusage[mem=2500]
#BSUB -n 12
#BSUB -R span[hosts=1]
#BSUB -e index_salm.err
#BSUB -oo index_salm.log

module load salmon/1.1.0
TRANSCRIPTOME="../*.fasta"
echo $TRANSCRIPTOME
salmon index -t $TRANSCRIPTOME -i Tsalmon_index

