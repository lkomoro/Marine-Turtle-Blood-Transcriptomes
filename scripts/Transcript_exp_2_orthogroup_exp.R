#### Match transcripts to the orthogroups they belong to ####
require(reshape2)
require(stringr)
require(tidyr)
require(dplyr)

## read in your transcript counts file
counts <- read.csv("Ei_transcripts.csv")
counts <- counts[,-1]
colnames(counts)[1] <- "TrinID"

## read in orthogroups file 
orthogroups <- read.csv("Orthogroups_spp.tsv", sep = "\t")
colnames(orthogroups) <- c("Orthogroup", "C.mydas", "C.carretta", "D. coriacea", "E.imbricata")

##separate list of trinity transcripts in orthogroup.tsv column of interest into one column per transcript
# count how many transcripts are in each row
comma.count <-c()
for (i in c(1:length(orthogroups$Orthogroup))) {
  comma.count[i] <- str_count(orthogroups$E.imbricata[i], ',')
}
#find the max number of transcripts per row 
max.no.transcripts <- max(comma.count) + 1 
#split each row into multiple columns
df <- colsplit(orthogroups$E.imbricata, ",", c(1:max.no.transcripts))
OG <- orthogroups$Orthogroup
df <- cbind(OG, df)
#gather all transcripts into one column
longdata <- gather(df, alltranscripts, Ei_Trinity, 2:(max.no.transcripts + 1))
longdata <- longdata[,-2]
#remove empty rows (lots of empty rows for rows in original file that had < max.no.transcripts transcripts)
longdata <- subset(longdata, Ei_Trinity != "")
#remove extra info, keep only trinity ID
df <- colsplit(longdata$Ei_Trinity, ".p", c("trin", "trin2"))
cleanlongdata <- as.data.frame(cbind(df$trin, as.character(longdata$OG)))
colnames(cleanlongdata) <- c("TrinID", "OG")

## merge transcript+counts table with trasnscripts+orthogroups file
OG_counts <- merge(counts, cleanlongdata, by = "TrinID", all.x=T, all.y=F)
OG_counts <- subset(OG_counts, OG_counts$OG != "NA")

## aggregate expression counts by orthgroup
Ei_counts_by_OG <-aggregate(cbind(Sample_35,
                                  Sample_39)  ~ OG, OG_counts, sum)