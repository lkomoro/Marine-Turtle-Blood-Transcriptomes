#### Functional Enrichment Analysis ####
require(topGO)

## Prepare data

# read in filtered annotation
geneID2GO <- readMappings(file = "Gene2GO.map")
# read in differential gene expression analysis results table (generated in lines 66 to 68 in Differential_gene_expression.R)
DE <- read.table("/Users/shreyabanerjee/Documents/raw_salmon_counts/DGE_HI.MI.txt", sep = "\t", header = T)
genelist <- DE$adj.P.Val
names(genelist) <- row.names(DE)
# Create topGOData object
GOdata <- new("topGOdata",
              ontology = "BP", #The 'ontology' argument can be 'BP' (biological process), 'MF' (molecular function), or 'CC' (cellular component)
              allGenes = genelist, #this is your 'gene universe'
              geneSelectionFun = function(x)x,# this line just says 'use all genes'
              annot = annFUN.gene2GO,	gene2GO = geneID2GO)	# The 'annot' argument tells topGO how to map genes to GO annotations. 'annot'=annFUN.gene2GO means that the user provides gene-to-GO annotations, and we specify here that they are in object 'geneID2GO'.For other options, like pulling from database etc, see 'annFUN' help in documentation.

## Kolmogorov Smirnov Testing 
resultKS <- runTest(GOdata, algorithm = "weight01", statistic = "ks")
resultKS

## Format results to save as a table
tab <- GenTable(GOdata, KS = resultKS, topNodes = length(resultKS@score), numChar = 120)
tab <- tab[,c(1,2,3,6)]
names(tab)[4] <- "Raw.P.Value"
# retrieve genes that belong to each  GO term
genes.in.term <- genesInTerm(GOdata)
genes.in.term2 <- unlist(lapply(genes.in.term, function(x)paste(x, collapse = ",")))
genes.in.term2 <- cbind(names(genes.in.term), genes.in.term2)
# add genes in each term to the FEA results table 
tmp <- match(tab$GO.ID, genes.in.term2[,1])
tab$Genes.In.Term <- genes.in.term2[tmp,2]
# write to file 
write.table(tab, file = "HI.MI._FEA_KS.txt", row.names = F, quote = F, sep = "\t")