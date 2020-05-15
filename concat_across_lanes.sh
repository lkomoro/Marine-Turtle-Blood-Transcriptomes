#!/bin/bash
# concatenate two lanes of rna seq turtle data Sample_0*

#BSUB -q long
#BSUB -W 48:00
#BSUB -R rusage[mem=1000]
#BSUB -n 24
#BSUB -R span[hosts=1]
#BSUB -e cat0.err
#BSUB -oo cat0.log

date

for file in /project/uma_lisa_komoroske/Full_Turtle_RNAseq_Spring2019/rawfastq_tocombine/added_lane/*0_1.fq.gz
do
echo $file
short=`echo $file | cut -f7 -d "/"`
sample=$(basename $short _1.fq.gz)
echo $sample

#gunzip /project/uma_lisa_komoroske/Full_Turtle_RNAseq_Spring2019/rawfastq_tocombine/added_lane/"$sample"_1.fq.gz
#gunzip /project/uma_lisa_komoroske/Full_Turtle_RNAseq_Spring2019/rawfastq_tocombine/two_lanes/"$sample"_1.fq.gz

#wc -l /project/uma_lisa_komoroske/Full_Turtle_RNAseq_Spring2019/rawfastq_tocombine/added_lane/"$sample"_1.fq >> ./addedR1_linects.txt
#wc -l /project/uma_lisa_komoroske/Full_Turtle_RNAseq_Spring2019/rawfastq_tocombine/two_lanes/"$sample"_1.fq >> ./twolaneR1_linects.txt

#cat /project/uma_lisa_komoroske/Full_Turtle_RNAseq_Spring2019/rawfastq_tocombine/added_lane/"$sample"_1.fq /project/uma_lisa_komoroske/Full_Turtle_RNAseq_Spring2019/rawfastq_tocombine/two_lanes/"$sample"_1.fq > ./"$sample"_1_combined.fq

#wc -l  ./"$sample"_1_combined.fq >> combinedR1_linects.txt

#gzip /project/uma_lisa_komoroske/Full_Turtle_RNAseq_Spring2019/rawfastq_tocombine/added_lane/"$sample"_1.fq
#gzip /project/uma_lisa_komoroske/Full_Turtle_RNAseq_Spring2019/rawfastq_tocombine/two_lanes/"$sample"_1.fq

#gzip ./"$sample"_1_combined.fq

#gunzip /project/uma_lisa_komoroske/Full_Turtle_RNAseq_Spring2019/rawfastq_tocombine/added_lane/"$sample"_2.fq.gz
#gunzip /project/uma_lisa_komoroske/Full_Turtle_RNAseq_Spring2019/rawfastq_tocombine/two_lanes/"$sample"_2.fq.gz

#wc -l /project/uma_lisa_komoroske/Full_Turtle_RNAseq_Spring2019/rawfastq_tocombine/added_lane/"$sample"_2.fq >> ./addedR2_linects.txt
#wc -l /project/uma_lisa_komoroske/Full_Turtle_RNAseq_Spring2019/rawfastq_tocombine/two_lanes/"$sample"_2.fq >> ./twolaneR2_linects.txt

#cat /project/uma_lisa_komoroske/Full_Turtle_RNAseq_Spring2019/rawfastq_tocombine/added_lane/"$sample"_2.fq /project/uma_lisa_komoroske/Full_Turtle_RNAseq_Spring2019/rawfastq_tocombine/two_lanes/"$sample"_2.fq > ./"$sample"_2_combined.fq

#wc -l  ./"$sample"_2_combined.fq >> combinedR2_linects.txt

#gzip /project/uma_lisa_komoroske/Full_Turtle_RNAseq_Spring2019/rawfastq_tocombine/added_lane/"$sample"_2.fq
#gzip /project/uma_lisa_komoroske/Full_Turtle_RNAseq_Spring2019/rawfastq_tocombine/two_lanes/"$sample"_2.fq

#gzip ./"$sample"_2_combined.fq

date

done
