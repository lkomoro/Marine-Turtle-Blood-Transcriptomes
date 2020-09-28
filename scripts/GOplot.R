#### Visualize results of functional enrichment analysis ####
require(GOplot)

## prepare data

# read in FEA results table 
FEA1 <- read.table("HI.MI._FEA_KS.txt", sep = "\t", header =T)
# add column for which GO level you used (BP = biological process)
FEA1$Category <- rep("BP", length(FEA1$GO.ID))
#re-order and rename columns to suit GOplot 
FEA1 <- FEA1[,c(6,1,2,5,4)]
colnames(FEA1) <- c("Category", "ID", "Term", "Genes", "adj_pval")
# read in and format dsifferential gene expression results
DE1 <- read.table("/Users/shreyabanerjee/Downloads/DGE_HI.MI.txt", sep = "\t")
DE1$ID <- row.names(DE1)
row.names(DE1) <- c()
DE1 <- DE1[,c(7, 1:6)]

## create a circle object 
circ <- circle_dat(FEA1, DE1)

## plot GoCircle 
GOCircle(circHI.MI, nsub = 10, label.size=4)