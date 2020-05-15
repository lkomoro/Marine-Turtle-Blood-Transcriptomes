#!/bin/bash
#run trinity on combined R1 and combined R2 files

#BSUB -q long
#BSUB -W 100:00
#BSUB -n 30:00
#BSUB -R "span[hosts=1]"
#BSUB -R "rusage[mem=6400]"
#BSUB -oo trinity.log
#BSUB -e trinity.err

module load trinity/2.8.5
module load bowtie2/2.3.4.3
module load java/1.8.0_77
module load samtools/1.4.1
module load jellyfish/2.2.3
module load python/2.7.9
module load python/2.7.9_packages/numpy/1.14.2


Trinity --left ./path/to/combinedR1reads.fastq.gz --right ./path/to/combinedR2reads.fastq.gz --seqType fq -max_memory 192G --CPU 30 --output Trinity --min_contig_length 300 --SS_lib_type RF --no_salmon
