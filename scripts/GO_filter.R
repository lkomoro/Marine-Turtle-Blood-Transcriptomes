#### filtering GO levels ####
require(dplyr)
require(reshape2)
require(plyr)
require(stringr)

## Filter by GO level

#read in your annotation file 
annot <- read.table("miniGTannotation_go_propagation.txt", sep ="\t", header=T)
# pull out GO terms that don't have a level
annot_obs <- annot %>% filter(Level == "Obsolete")
# pull out GO terms that have a levels below 5
annot$Level <- as.numeric(as.character(annot$Level))
annot_lowlevel <- annot %>% filter(Level < 5)
# combine low-level (<5) GO terms with GO terms without a level
annot_lowlevel <- rbind(annot_obs, annot_lowlevel)

## Aggregate annotations to gene level to match with differential gene expression analysis

#split transcripts into GeneID and isoform
vars <- colsplit(annot_lowlevel$Seq.Name, "_i", c("GeneID", "isoform"))
annot_lowlevel <- cbind(vars, annot_lowlevel)
annot_lowlevel <- annot_lowlevel[,c(1,4)]
# Remove duplicated columns
annot_lowlevel <- distinct(annot_lowlevel, GeneID, GO, .keep_all= TRUE)
# re-arrange data frame so that there is one row per gene, with all GO terms listed
annot_lowGOlevels <-ddply(annot_lowlevel, "GeneID", summarize, GO = paste(GO, collapse=","))
# write to file
write.table(annot_lowGOlevels, file = "Gene2GO.map", sep = "\t", quote = F,
            row.names = F, col.names = F)