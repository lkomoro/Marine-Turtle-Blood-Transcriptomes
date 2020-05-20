#!/bin/bash
#use diamond to search uniprot database with input protein sequences

#BSUB -q short
#BSUB -W 4:00
#BSUB -R rusage[mem=5000]
#BSUB -n 20
#BSUB -R span[hosts=1]
#BSUB -e diamond.err
#BSUB -oo diamond.log





#need a downloaded protein dabase file such as nr in fasta format AND a file of translated DNA reads. Also need to download the three files designated for the makedb command
#change --taxonlist flag to limit top hits to specified taxonomies (here included hits from bacteria, arcahea, viruses)
#max-target-seqs of 1 includes only top hit per query sequence, can modify to include more. This is appropriate for a translated peptide input, but doesn't work as well for untranslated sequences

diamond=/path/to/local/diamond/install

$diamond makedb --in nr.gz -d nr --taxonmap ./prot.accession2taxid --taxonnodes ./nodes.dmp --taxonnames ./names.dmp

$diamond blastp -d nr -q Orthogroup_sequences.fa -o nr_tophits.m8 --max-target-seqs 1 -f 6 --taxonlist 2,10239,2157

wait

#sort output files

sort -k 3n nr_tophits.m8 >sort_nr_tophits.m8

wait

#print only entries that have blast similarity greater than 95%

awk ‘{ if ($3 >= 95.0) { print } }’ sort_nr_tophits.m8 > sort_filt_nr_tophits.m8
