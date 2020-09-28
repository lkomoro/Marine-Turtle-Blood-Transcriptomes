#### Differential orthogroup expression analysis ####
require(reshape)
require(plyr)
require(dplyr)
require(ggplot2)
require(erer)
require(edgeR)
require(limma)
require(RColorBrewer)

## Prepare data

#read in data (orthogorup expression data filtered to only contain shared orthogroups)
cts <- read.csv("DcCmEi_ortho_counts.csv")
cts <- cts[,-1]
#make OGs rownames
row <- cts$OG
row.names(cts) <- row
cts <- cts[,-1]
#set all NAs to 0
cts[is.na(cts)] <- 0
#read in metadata
all.spp_metadata<-read.csv("All.spp.metadata.csv", header = T, stringsAsFactors = F)
#format group names
all.spp_metadata$SPP.POP <- paste(all.spp_metadata$Species,"(",all.spp_metadata$pop,")", sep="")
all.spp_metadata$SPP.POP <- revalue(all.spp_metadata$SPP.POP, c("Dc(DC)" = "Dc", "Cc(CC)" = "Cc", "Ei(EI)" = "Ei"))
# filter metadta file to only include individuals we are including in this analysis 
df <- as.data.frame(colnames(cts))
colnames(df) <- "SAMPLE"
all.spp_metadata <- merge(df, all.spp_metadata)

## Filter counts

#convert raw counts to counts per million
cpms <- cpm(cts) 
# filter counts to only keep orthogroups with at least one count per million in at least two individuals 
keep <- rowSums(cpms >1) >= 2
cts2 <- cts[keep,]

## Normalize counts by library size

# Create a DGEList object (edgeR's container for RNA-seq count data)
ed <- DGEList(cts2)
# Calculate normalization factors
ed <- calcNormFactors(ed)

##set up design matrix

all.spp_metadata$Species <- as.factor(all.spp_metadata$Species)
mod.mat<-model.matrix(~0+Species, data=all.spp_metadata)
colnames(mod.mat)<-levels(all.spp_metadata$Species)

my.contrasts <- makeContrasts(
  Cm.Dc = Cm-Dc,
  Cm.Ei = Cm-Ei,
  Dc.Ei = Dc-Ei,
  levels=colnames(mod.mat))

## DE analysis

#Transform count data to log2-counts per million 
v <- voom(ed,mod.mat,plot=TRUE)
#Fit linear model for each gene given a series of arrays
vfit <- lmFit(v,mod.mat) 
vfit <- contrasts.fit(vfit, contrasts=my.contrasts)
efit <- eBayes(vfit)

#pairwise DGE tests
voom_results_Cm.Dc <- topTable(efit, coef=1, n=Inf)
voom_results_Cm.Ei <- topTable(efit, coef=2, n=Inf)
voom_results_Dc.Ei <- topTable(efit, coef=3, n=Inf)

## Print Summary table

ds1<-decideTests(efit, adjust.method = "BH",p.value = 0.05)
summary(ds1)
