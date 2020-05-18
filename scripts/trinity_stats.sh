#!/bin/bash
#run TrinityStats

#BSUB -q short
#BSUB -W 1:00
#BSUB -R rusage[mem=16000]
#BSUB -n 4
#BSUB -R span[hosts=1]
#BSUB -e TrinityStats2_HIGT.err
#BSUB -oo TrinityStats_HIGT.log

module load trinity/2.8.5
/share/pkg/trinity/2.8.5/util/TrinityStats.pl ./Trinity.fasta
