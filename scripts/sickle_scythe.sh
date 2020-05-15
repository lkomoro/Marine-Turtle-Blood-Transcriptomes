#!/bin/bash
# sickle scythe combo
#samples *0, ran seperate jobs in parallel for computing efficiency
#change path for your adaptor sequence

#BSUB -q long
#BSUB -W 30:00
#BSUB -R rusage[mem=1000]
#BSUB -n 12
#BSUB -R span[hosts=1]
#BSUB -e SScombo0.err
#BSUB -oo SScombo0.log

date

#load modules and set variables
module load scythe/0.994
ADAPTOR="/project/uma_lisa_komoroske/Shreya/CmRNAseq_SB/NEBadaptor/NEB.adaptor.fasta"
CONTAM="0.1"
module load sickle/1.33

#adaptor trim, rezip raw reads
for file in *0_*_combined.fq.gz
do
echo $file
date
gunzip $file
sample=$(basename $file _combined.fq.gz ) #adjust so that $sample includes name+ R1 or R2 etc.
echo $sample
scythe -a $ADAPTOR -p $CONTAM -o ./"$sample"_combined_S.fq "$sample"_combined.fq
date


done

wait
for R1 in *0_1_combined_S.fq
do

echo $R1
R2=${R1/_1_/_2_}
echo $R2
sample=$(basename $R1 _1_combined_S.fq)
echo $sample
sickle pe -f $R1 -r $R2 -t sanger -o "$sample"_R1_SS.fastq -p "$sample"_R2_SS.fastq -s "$sample"_orphans.fastq.gz -q 20
date
rm $R1
rm $R2
gzip "$sample"_R1_SS.fastq
gzip "$sample"_R2_SS.fastq
done
