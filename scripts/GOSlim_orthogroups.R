#### summarize GO Slim categories in core genes ####
require(ggplot2)
require(stringr)
require(reshape2)
require(tidyr)
#read in orthogroup information
orthogroups <- read.table("Orthogroups.tsv", sep="\t", header =T)
# rename columns
colnames(orthogroups) <- c("Orthogroup", "A", "B",  "C", "D")
#change which genes of each transcriptome in each orthogroup to whether present or absent
for (i in c(2:ncol(orthogroups))) {
  orthogroups[,i] <- ifelse(orthogroups[,i] == "", "0", "1")
  orthogroups[,i] <- as.numeric(orthogroups[,i])
}
#create sum column
orthogroups$sum <- orthogroups$A + orthogroups$B + orthogroups$C + orthogroups$D
#keep orthgroups that are present in all assemblies (columns)
keep <- ncol(orthogroups) - 2
shared_OG <- subset(orthogroups, orthogroups$sum == keep)
shared_OG <- shared_OG[,c(1,6)]
#read orthogroup file in again to get Trinity transcript IDs
trinity.info <- read.table("Orthogroups.tsv", sep="\t", header =T)
#keep only orthogroup names and column of annotated assembly
#get rid of other species
trinity.info <- trinity.info[,c(1,2)]
colnames(trinity.info) <- c("Orthogroup", "TranscriptID")
#merge with list of shared orthogroups
df <- merge(shared_OG, trinity.info)
#keep orthogroups and trinity transcript IDs
df <- df[,c(1,3)]
#count number of trinity transcripts in each OG (transcripts separated by commas in orthofinder output)
comma.count <-c()
for (i in c(1:length(df$Orthogroup))) {
  comma.count[i] <- str_count(df[i,2], ',')
}
# put each Trinity transcript ID into it's own column
df2 <- colsplit(df$TranscriptID, ",", c(1:(1+ max(comma.count))))
df3 <- cbind(df, df2)
df3 <- df3[,-2]
# gather all transcript IDs and corresponding orthogroups into two columns
df4 <- gather(df3, alltranscripts, Trinity, 2:(2+ max(comma.count)))
df4 <- df4[,-2]
#filter out blank columns
core.genes <- df4 %>% filter(Trinity != "")
## you know have a list of trinity transcripts included in the shared orthogroup set

#read in GO Slim output
Slim <- read.table("GO-slim_directGOcount_bioprocess.txt", sep = "\t")

#run loop to make data frame of number of transcripts in each GO Slim category
num.trans.per.GOslim.cat <- c()
for (i in c(1:nrow(Slim))) {
  df <- as.data.frame(unlist(strsplit(as.vector(Slim[i,2]), split = ","))) #make vector of all transcripts in each GO SLim category
  colnames(df) <- "Trinity"
  df$GOslim <- rep(row.names(Slim)[i], length(df$Trinity)) #add column with name of category
  core <- merge(core.genes, df) #merge to retain only transcripts in shared orthogroup set
  num.trans.per.GOslim.cat[i] <- nrow(core) #count number of transcripts per GO slim category
}

#make data frame of GO Slim categories and number of transcripts in each
GO.slim.cat <- row.names(Slim)
GOslim_cts <- as.data.frame(cbind(GO.slim.cat, num.trans.per.GOslim.cat))
colnames(GOslim_cts) <- c("GOslim_category", "no.Transcripts")
GOslim_cts$no.Transcripts <-as.numeric(as.character(GOslim_cts$no.Transcripts))

##make barplot summarizing GO slim category distribution in shared orthogroups
ggplot(data=GOslim_cts, aes(x=reorder(GOslim_category, no.Transcripts), y=no.Transcripts)) +
  geom_bar(stat="identity",fill='aquamarine4') +
  coord_flip() + 
  theme_classic()+
  xlab(NULL) +
  ylab ("Number of transcripts associated with GO term")+
  theme(text = element_text(size=15))
