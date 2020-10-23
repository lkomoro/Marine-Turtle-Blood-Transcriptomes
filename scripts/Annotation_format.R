#### Final formatting annotation Tables ####
# By Blair Bentley
library(plyr)
require(reshape2)
require(dplyr)
require(stringr)

#### format raw blast2GO exportation ####
# read in blast2GO export 
data <- read.delim(file = "miniGTannotation_go_propagation.txt", header = T, sep = "\t")
# remove transdecoder info from trinity transcript IDs
x <- colsplit(data$Seq.Name, ".p", c("Transcript", "prot"))
data <- cbind(x, data)
#keep columns of interest
data <- data[,c(4,6, 5,1)]
colnames(data) <- c("GO ID",	"GO Level", "Description",	"Transcript")
annotation <- distinct(data)

#### Format GO term names ####
#read in another blast2GO export format
data <- read.delim("GT_annotation_table.txt", sep = "\t")
#keep GO IDs and GO ID names
data <- data[,c(10,11)]
#remove empty rows
data <-subset(data, data$GO.IDs != "")
#count number of GO IDs per row
comma.count <-c()
for (i in c(1:length(data$GO.IDs))) {
  comma.count[i] <- str_count(data[i,2], ',')
}
max(comma.count) #15
#split up column so that each GO ID is in it's own column
GO.IDs <- colsplit(data$GO.IDs, ";", c(1:16))
#split up column so that each GO name is in it's own column
GO.names <- colsplit(data$GO.Names, ";", c(1:16))
#combine all GO ID columns (excluding blank rows) into one vector in exact order
GO.ID.list <- c(GO.IDs$`1`[GO.IDs$`1` != ""], GO.IDs$`2`[GO.IDs$`2` != ""], GO.IDs$`3`[GO.IDs$`3` != ""], 
                GO.IDs$`4`[GO.IDs$`4` != ""], GO.IDs$`5`[GO.IDs$`5` != ""], GO.IDs$`6`[GO.IDs$`6` != ""], 
                GO.IDs$`7`[GO.IDs$`7` != ""], GO.IDs$`8`[GO.IDs$`8` != ""], GO.IDs$`9`[GO.IDs$`9` != ""], 
                GO.IDs$`10`[GO.IDs$`10` != ""], GO.IDs$`11`[GO.IDs$`11` != ""], GO.IDs$`12`[GO.IDs$`12` != ""], 
                GO.IDs$`13`[GO.IDs$`13` != ""], GO.IDs$`14`[GO.IDs$`14` != ""], GO.IDs$`15`[GO.IDs$`15` != ""], 
                GO.IDs$`16`[GO.IDs$`16` != ""])
#combine all GO name columns (excluding blank rows) into one vector in exact order
GO.names.list <- c(GO.names$`1`[GO.names$`1` != ""], GO.names$`2`[GO.names$`2` != ""], GO.names$`3`[GO.names$`3` != ""], 
                   GO.names$`4`[GO.names$`4` != ""], GO.names$`5`[GO.names$`5` != ""], GO.names$`6`[GO.names$`6` != ""], 
                   GO.names$`7`[GO.names$`7` != ""], GO.names$`8`[GO.names$`8` != ""], GO.names$`9`[GO.names$`9` != ""], 
                   GO.names$`10`[GO.names$`10` != ""], GO.names$`11`[GO.names$`11` != ""], GO.names$`12`[GO.names$`12` != ""], 
                   GO.names$`13`[GO.names$`13` != ""], GO.names$`14`[GO.names$`14` != ""], GO.names$`15`[GO.names$`15` != ""], 
                   GO.names$`16`[GO.names$`16` != ""])
#combine GO ID list and GO name list into a data frame 
df <- as.data.frame(cbind(GO.ID.list, GO.names.list))
#remove duplicated GO IDs
df <- distinct(df)
#remove GO category/letter before ":" in each column
GO.format.ID <- colsplit(df$GO.ID.list, ":", c("bleh", "GO.ID"))
GO.format.term <- colsplit(df$GO.names.list, ":", c("bleh", "GO.term"))
#combine clean columns
GOkey <- cbind(GO.format.ID, GO.format.term)
GOkey <- GOkey[,c(2,4)]
rm(data, df, GO.format.ID, GO.format.term, GO.IDs, GO.names, GO.ID.list, GO.names.list, comma.count)

#### Merge annotation with GO term names ####
#merge annotation file with GO key
annot_new <- merge(annotation, GOkey, all.x=T)
#remove duplicates
annot_new <- distinct(annot_new)
annot_new <- annot_new[,c(4,3,1,2,5)]
colnames(TS2_new)[5] <- "GO.names"
write.table(TS2_new, file = "Annotation_table.txt", row.names = F, sep = "\t", quote=F)

#### Formatting Orthofinder output ####
# see ormat_OF_supp_tables.R
# use Table S5 or Table S6 

#### Final formatting by Blair Bentley ####
df1<-read.delim(file="Annotation_table.txt", sep = "\t")
df2<-read.delim(file="TableS5.txt", sep = "\t")
df2_ex<-df2[,1:2]
df2_un<-unique(df2_ex)
df2_sort<-df2_un[order(df2_un$Trinity),]
colnames(df2_sort)[1]<-"Transcript"
df1<-df1[order(df1$Transcript),]
df3<-join(x = df1, y = df2_sort, by = "Transcript")
write.table(x = df3, file="TableS2.txt",sep = "\t",eol = "\n", quote = F, row.names = F)
