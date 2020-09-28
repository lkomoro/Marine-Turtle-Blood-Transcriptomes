#### MDS plot  of orthgroup expression signatures ####
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
cts <- read.csv("/Users/shreyabanerjee/Downloads/allspp_allortho_counts.csv")
cts <- cts[,-1]
#make OGs rownames
row <- cts$OG
row.names(cts) <- row
cts <- cts[,-1]
rm(row)
#set all NAs to 0
cts[is.na(cts)] <- 0
#read in metadata
all.spp_metadata<-read.csv("All.spp.metadata.csv", header = T, stringsAsFactors = F)
#format group names
all.spp_metadata$SPP.POP <- paste(all.spp_metadata$Species,"(",all.spp_metadata$pop,")", sep="")
all.spp_metadata$SPP.POP <- revalue(all.spp_metadata$SPP.POP, c("Dc(DC)" = "Dc", "Cc(CC)" = "Cc", "Ei(EI)" = "Ei"))

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

## MDS plot

# expand outer margins to make room for legend
par(mfrow=c(1,1))
par(oma = c(10,1,1,1)) 
# set plot gorup and plot color 
plotgroup <- interaction(all.spp_metadata$SPP.POP)
plotcolor <- revalue(plotgroup, c("Dc"="#E69F00", "Cc"="#F0E442", "Ei"="#CC79A7", "Cm(CA)"="#009E73", "Cm(HI)"="#0072B2", "Cm(MI)"="#56B4E9"))
# make plot
plotMDS(ed, pch=21, bg = as.vector(plotcolor),  cex= 3, cex.axis =2, cex.lab = 1.5,
        labels=NULL, col = "black", las=1, title = "MDS with orthogroup counts")
# add legend
par(xpd = NA) # Allows legend to go outside plot frame
ltext <- c("C. carretta", "C. mydas (CA)", "C. mydas (HI)", "C. mydas (MI)", "D. coriacea", "E.imbricata")
legend(x = par("usr")[1], y = par("usr")[3], legend = ltext, text.col = "black",
       title = "Species", cex = 2, pch = 21, pt.cex = 3, pt.bg = levels(plotcolor))