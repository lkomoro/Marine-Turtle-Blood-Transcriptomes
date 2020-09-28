#### MDS plot  of gene expression signatures ####
require(reshape)
require(plyr)
require(dplyr)
require(ggplot2)
require(erer)
require(edgeR)
require(limma)
require(RColorBrewer)

## Prepare data

#read in data
counts <- read.csv("Cm_genes_rollup.csv", header =T)
counts <- counts[,-1]
#make genes row names
row <- counts$GeneID
row.names(counts) <- row 
counts <- counts[,-1]
#set all NAs to 0
cts[is.na(cts)] <- 0
#read in metadata
all.spp_metadata<-read.csv("All.spp.metadata.csv", header = T, stringsAsFactors = F)
# filter out other species
cm_metadata <- all.spp_metadata %>% filter(Species == "Cm")
# format group names
cm_metadata$pop <- revalue(cm_metadata$pop, c("CA"="Cm(CA)", "HI"="Cm(HI)", "MI"="Cm(MI)"))

## Filter counts

#convert raw counts to counts per million
cpms <- cpm(cts) 
# filter counts to only keep orthogroups with at least one count per million in at least seven individuals 
keep <- rowSums(cpms >1) >= 7
cts2 <- cts[keep,]

## Normalize counts by library size

# Create a DGEList object (edgeR's container for RNA-seq count data)
ed <- DGEList(cts2)
# Calculate normalization factors
ed <- calcNormFactors(ed)

## MDS plot

# expand outer margins to make room for legend
par(mfrow=c(1,1))
par(oma = c(10,1,1,1))
# set plot gorups and colors 
plotgroup <- interaction(cm_metadata$pop)
plotcolor <- revalue(plotgroup, c( "Cm(CA)"="#009E73", "Cm(HI)"="#0072B2", "Cm(MI)"="#56B4E9"))
# make plot
plotMDS(ed, pch=21, bg = as.vector(plotcolor), cex= 3, cex.axis =2, 
        labels=NULL, col = "black", las=1)
# add legend
par(xpd = NA) # Allows legend to go outside plot frame
ltext <- gsub(".", "/", levels(plotgroup), fixed = T)
legend(x = par("usr")[1], y = par("usr")[3], legend = ltext, text.col = levels(plotcolor),
       title = "Population", cex = .9)
