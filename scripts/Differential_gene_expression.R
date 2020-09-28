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

## Set up design matrix
cm_metadata$pop <- revalue(cm_metadata$pop, c("Cm(CA)" = "Cm.CA", "Cm(HI)" = "Cm.HI", "Cm(MI)"= "Cm.MI"))
cm_metadata$pop <- as.factor(cm_metadata$pop)
mod.mat<-model.matrix(~0+pop, data=cm_metadata)
colnames(mod.mat)<-levels(cm_metadata$pop)

my.contrasts <- makeContrasts(
  CA.HI = Cm.CA-Cm.HI,
  CA.MI = Cm.CA-Cm.MI,
  HI.MI = Cm.HI-Cm.MI,
  levels=colnames(mod.mat))

## DE analysis

#Transform count data to log2-counts per million 
v <- voom(ed,mod.mat,plot=TRUE)
#Fit linear model for each gene given a series of arrays
vfit <- lmFit(v,mod.mat) 
vfit <- contrasts.fit(vfit, contrasts=my.contrasts)
efit <- eBayes(vfit)

#pairwise DGE tests
voom_results_CA.HI <- topTable(efit, coef=1, n=Inf) 
voom_results_CA.MI <- topTable(efit, coef=2, n=Inf)
voom_results_HI.MI <- topTable(efit, coef=3, n=Inf)

## Print Summary table

ds1<-decideTests(efit, adjust.method = "BH",p.value = 0.05)
summary(ds1)

## Visualize DE genes in MD plots 
par(mfrow=c(1,3))
plotMD(efit, column=1,  #column of object to be plotted
       status=ds1[,1],#sig status (-1,0,1) for sig down, not sig, or sig up 
       main=colnames(efit)[1])+#contrast for title of graph
  abline(h=c(-1, 1), col="blue", lty="dashed")
plotMD(efit, column=2, status=ds1[,2], main=colnames(efit)[2])+ abline(h=c(-1, 1), col="blue", lty="dashed")
plotMD(efit, column=3, status=ds1[,3], main=colnames(efit)[3])+ abline(h=c(-1, 1), col="blue", lty="dashed")
