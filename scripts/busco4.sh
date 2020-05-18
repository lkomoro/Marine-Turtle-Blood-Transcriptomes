#!/bin/sh
#script to run BUSCO analysis on green turtle transcriptome
#BSUB -q long
#BSUB -W 40:00
#BSUB -n 16
#BSUB -R "span[hosts=1]"
#BSUB -R rusage[mem=9000]
#BSUB -oo busco4_lung_filtered.log
#BSUB -eo b4_error.err
module load hmmer/3.1b2
module load blast/2.7.1+
export BUSCO_CONFIG_FILE="Busco4_config.ini "

module load busco/4.0.4

singularity exec $BUSCOIMG busco -l vertebrata_odb10
