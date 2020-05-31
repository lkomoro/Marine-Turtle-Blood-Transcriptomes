# Marine-Turtle-Blood-Transcriptomes
A repository for scripts, notes and workflows for our collaborative project investigating marine turtle blood transcriptomes and green turtle differential expression analyses

## I. Pre-processing and quality checks
### i. Concatenating files from multiple lanes
Samples were sequenced across three HiSeq lanes

1. Check md5sums to verify integrity of files
2. Concatenate new lane reads. The script referenced needs to be looped; we ran jobs in parallel for computing efficiency, with samples ending in 0 using one script, then samples ending in 1, etc.
3. Check line counts add up before and after concatenation

*associated scripts: concat_across_lanes.sh*

### ii. Check quality with fastqc and multiqc
*associated scripts: fastqc_loop.sh*

Multiqc is installed globally on our cluster, from command line, run <multiqc *.fastqc>


### iii. Trimming newly concatenated reads with Sickle and Scythe
*Assocated scripts: sickle_scythe.sh*

Purpose: sickle uses a sliding window along with quality and length thresholds to determine when to trim or discard reads. Scythe uses a bayesian approach to remove adapters.
Resources:  [sickle documentation](https://github.com/najoshi/sickle); [UCDavis workshop info](https://bioinformatics.ucdavis.edu/research-computing/software/)

### iv. Check quality with fastqc and multiqc (after trimming) to ensure low-quality sequences were removed/trimmed and adapters are properly removed
*Assocated scripts: fastqc_loop.sh*

## II. De-novo transcriptome assembly with Trinity
### i. Concatenate all R1 and R2 reads into to unique files (for Trinity input)
*Assocated scripts: concat_R1_R2.sh*

### ii. Run Trinity
Purpose: Trinity takes many individual sequences where we expect a lot of discontinutity, creates many individual graphs from these sequences, and extracts isoforms from these. inchworm assembles read data and results in a collection of contigs with each k-mer present only once in contigs. chrysalis pools contigs if they share at least one k-1-mer, and builds de Bruijn graphs from each pool, Butterfly takes these and reconsturcts distinct transcripts. We used Trinity over other assemblers because it has been shown to generate more complete de-novo assemblies, though it's important to filter out potential chimeric transcripts downstream.

Resources: [Trinity publication](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3571712/) ; [Trinity github](https://github.com/trinityrnaseq/trinityrnaseq) ; [Harvard best practices](https://informatics.fas.harvard.edu/best-practices-for-de-novo-transcriptome-assembly-with-trinity.html)

Parameters: --min_contig_length 300 #exclude transcripts less than 300bp, since we did 150bp PE sequencing
--no_salmon #we ran salmon seperately
--SS_lib_type RF #used RF for our strand specific kit, check library prep kit for this

*Assocated script: run_trinity.sh*

## III. Gathering quality metrics on de-novo transcriptome
Purpose: Evaluate completeness (biological and technical) of assembly, compare different assemblies
### i. TrinityStats
This provides basic metrics like transcript abundance, contig Nx values, median contig lengths.

*Assocated script: trinity_stats.sh*

### ii. Re-mapping rates with Salmon and Bowtie
High re-mapping rates indicate high quality assemblies. Input should be the samples used to generate the transcriptome

*Assocated scripts: salmon_index.sh and salmon.sh (in order)*


### iii. BUSCO score
High BUSCO scores indicate biological completeness. We used vertebrata database of orthologous groups

*Assocated script and config: busco4.sh and Busco4_config.ini*

### iv. Transrate
Also provides the metrics from TrinityStats, as well as an assembly score based on individual contig scores, and provides a "good.assembly.fasta" file that contains a filtered version of the assembly with bad contigs removed. NOTE that the only copy of Transrate we've found to work is that downloaded from the [Oyster River Protocol github page](https://github.com/macmanes-lab/Oyster_River_Protocol/tree/master/software). We did NOT use the software downloaded the TransRate documentation directly as it does not accurately compute assembly score.

*Assocated script: transrate.sh*

### v. Contaminant abundance
Use diamond blast to determine abundance of transcripts in assembly with top hits matching non-vertebrate species, here just filtering the NCBI nr database to only include top blast hits from bacteria, archae, and viruses, but this can be modified with the --taxonlist flag.

*associated scripts: diamond_contamination.sh*

## IV. Filtering Assembly
Purpose: remove chimeric or misassembled transcripts, remove redundant transcripts for downstream applications (esp important because Trinity assemblies are very large)
### i. Filtering with Transrate
See above, use the "goodcontigs.fasta" file for next steps.
### ii. Filtering with cd-hit
We used a 95% similarity threshold, but this can be modified to be more lenient or stringent.

*associated scripts: cd-hit.sh*

## V. Quantification with Salmon (Mapping original reads to filtered assembly)
Purpose: salmon uses quasi-mapping to quantify transcripts which is faster than full alignment methods like Kallisto and sailfish, and models sample-specific bias while retaining speed.
### i. Build Salmon index
*associated scripts: salmon_index.sh*

### ii. Quantify transcript abundance
*associated scripts: salmon.sh*

### iii. Format count files for input into R for DGE analysis:
Roll up quant files in salmon directories generate .count file for R analysis. Make sure you have gather-counts.py installed, then use the following script to actually run it.

*associated scripts: gather-counts.py; run_gather-counts.sh*

## VI. Preparation for orthofinder
To run orthofinder on multiple assemblies, you first need to generate translated amino acid sequences from your filtered assemblies. Following the above filtering steps, run transdecoder to do this. You will ultimately end up with four output files, one of which ends in .pep and should be used in orthofinder analysis.

### i. run TransDecoder 
Extract the Longest open reading frames from your filtered assemblies then predict likely coding regions from the single best open reading frame per transcript.

*associated scripts: transdecoder.sh*

Use the .pep files containing translated amino acide sequences for downstream analysis. To run OrthoFinder, you will need to to make directories containing pep files for each assembly you want to include in an analysis and rename the files to end in .fa or .fasta.

## VII. Run orthofinder
Use OrthoFinder (https://github.com/davidemms/OrthoFinder) to find orthogroups of genes from each of your assemblies.


*associated scripts: orthofinder.sh*
