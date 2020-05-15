#!/bin/bash
# quality check reads, might need to run in parallel if running on many samples

#BSUB -q long
#BSUB -W 7:00
#BSUB -R rusage[mem=1000]
#BSUB -n 4
#BSUB -R span[hosts=1]
#BSUB -e fastqc.err
#BSUB -oo fastqc.log

module load fastqc/0.11.5
for file in /project/uma_lisa_komoroske/Full_Turtle_RNAseq_Spring2019/three.lane.reads/*1_combined.fq
do
echo $file
fastqc -o /project/uma_lisa_komoroske/Full_Turtle_RNAseq_Spring2019/raw_fastqc $file
done
