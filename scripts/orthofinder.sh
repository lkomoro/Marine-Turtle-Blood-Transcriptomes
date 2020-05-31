#!/bin/bash
#run Orthofinder on translated fasta files


#BSUB -q long
#BSUB -W 24:00
#BSUB -R rusage[mem=16000]
#BSUB -n 12
#BSUB -R span[hosts=1]



module load orthofinder/2.3.3
singularity exec $ORTHOFINDERIMG orthofinder -f dir.with.translated.fasta.files
