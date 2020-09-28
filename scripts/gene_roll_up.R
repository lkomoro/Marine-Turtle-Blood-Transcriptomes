#### Roll Transcript counts up to gene level ####
require(reshape)
require(dplyr)

# read in your transcript counts file
counts <- read.csv("Cm_transcripts.csv")
vars<-colsplit(counts$transcript, "_i", c("GeneID","IsoformID"))
counts <-cbind(vars, counts)
#aggregate by GeneID
Cm_RNASeq_by_genes<-aggregate(cbind(Sample_01,
                                    Sample_02,
                                    Sample_03,
                                    Sample_04,
                                    Sample_09,
                                    Sample_10,
                                    Sample_11,
                                    Sample_13,
                                    Sample_14,
                                    Sample_15,
                                    Sample_16,
                                    Sample_17,
                                    Sample_18,
                                    Sample_19,
                                    Sample_20,
                                    Sample_21,
                                    Sample_23,
                                    Sample_24,
                                    Sample_25,
                                    Sample_26,
                                    Sample_27,
                                    Sample_28,
                                    Sample_29,
                                    Sample_30,
                                    Sample_31,
                                    Sample_32,
                                    Sample_33,
                                    Sample_34,
                                    Sample_36,
                                    Sample_37,
                                    Sample_38,
                                    Sample_40,
                                    Sample_41,
                                    Sample_43)  ~ GeneID, counts, sum)

# write to file 
write.csv(Cm_RNASeq_by_genes, "Cm_genes_rollup.csv",sep="\t",quote=FALSE)