#!/bin/bash
#run Transrate with all combined left and right reads
#use Transrate installed locally from oyster river protocol github
#BSUB -q long
#BSUB -W 15:00
#BSUB -R rusage[mem=5000]
#BSUB -n 20
#BSUB -R span[hosts=1]
#BSUB -e transrate.err
#BSUB -oo transrate.log


/project/uma_lisa_komoroske/bin/ORP_transrate/orp-transrate/transrate --assembly /project_location/Trinity.fasta
          --left left_trimmed_read.fastq  \
          --right right_trimmed_read.fastq   \
