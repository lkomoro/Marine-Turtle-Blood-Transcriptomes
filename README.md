# Marine-Turtle-Blood-Transcriptomes
A repository for scripts, notes and workflows for our collaborative project investigating marine turtle blood transcriptomes and green turtle differential expression analyses

## I. Pre-processing and quality checks
### i. Concatenating files from multiple lanes
1. Check md5sums to verify integrity of files
2. Concatenate new lane reads
*insert associated script*

### ii. Check quality with fastqc and multiqc *Assocated scripts found in *

### iii. Trimming newly concatenated reads with Sickle and Scythe
*Assocated scripts found in *

### iv. Check quality with fastqc and multiqc (after trimming) to ensure low-quality sequences were removed/trimmed and adapters are properly removed
*Assocated scripts found in *

## II. De-novo transcriptome assembly with Trinity
### i. Concatenate all R1 and R2 reads into to unique files (for Trinity input)
*Assocated scripts found in *

### ii. Run Trinity
Parameters:
*Assocated scripts found in *

## III. Gathering quality metrics on de-novo transcriptome

### i. TrinityStats

### ii. Re-mapping rates with Salmon and Bowtie

### iii. BUSCO score

### iv. Transrate

## IV. Filtering Assembly
### i. Filtering with Transrate
### ii. Filtering with cd-hit


## V. Quantification with Salmon (Mapping original reads to filtered assembly)
### i. Build Salmon index

### ii. Quantify transcript abundance

### iii. Format count files for input into R for DGE analysis:

## VI. Preparation for orthofinder
### i. run TransDecoder

## VII. Run orthofinder
