#### remove extra transdecoder info from Table S5 and Table S6 ####
setwd("/Users/shreyabanerjee/Documents/turtle/drafts/Sept8")
require(stringr)
require(reshape2)
require(tidyr)

#### S5 ####
S5 <- read.delim("/Users/shreyabanerjee/DOwnloads/TableS5.txt", sep = "\t", header = T)
final.S5.col.names <- colnames(S5)
#### C. mydas ####
#split by comma to get each gene alone

comma.count <-c()
for (i in c(1:length(S5$C.mydas))) {
  comma.count[i] <- str_count(S5$C.mydas[i], ',')
}
max(comma.count) #44

df <- colsplit(S5$C.mydas, ",", c(1:45))
Cm <- cbind(S5$Orthogroup, df)
colnames(Cm)[1] <- "OG"

#gather into a two column list of OG and transcript

df <- gather(Cm, alltranscripts, Trinity, 2:46)
df <- df[,-2]
df <- subset(df, df$Trinity != "")

#split off unwanted trinity info
df2 <- colsplit(df$Trinity, ".p", c("Transcript", "trash"))
Cm <- cbind(df,df2)
Cm <- Cm[,c(1,3)]

#combine again into list separated by commas
CmS5 <- aggregate(Transcript ~ OG, Cm, paste, collapse = ', ')

#### Cc ####

comma.count <-c()
for (i in c(1:length(S5$C.carretta))) {
  comma.count[i] <- str_count(S5$C.carretta[i], ',')
}
max(comma.count) #8

df <- colsplit(S5$C.carretta, ",", c(1:9))
Cc <- cbind(S5$Orthogroup, df)
colnames(Cc)[1] <- "OG"

#gather into a two column list of OG and transcript

df <- gather(Cc, alltranscripts, Trinity, 2:10)
df <- df[,-2]
df <- subset(df, df$Trinity != "")

#split off unwanted trinity info
df2 <- colsplit(df$Trinity, ".p", c("Transcript", "trash"))
Cc <- cbind(df,df2)
Cc <- Cc[,c(1,3)]

#combine again into list separated by commas
CcS5 <- aggregate(Transcript ~ OG, Cc, paste, collapse = ', ')

#### Dc ####

comma.count <-c()
for (i in c(1:length(S5$D.coriacea))) {
  comma.count[i] <- str_count(S5$D.coriacea[i], ',')
}
max(comma.count) #25

df <- colsplit(S5$D.coriacea, ",", c(1:26))
Dc <- cbind(S5$Orthogroup, df)
colnames(Dc)[1] <- "OG"
#gather into a two column list of OG and transcript

df <- gather(Dc, alltranscripts, Trinity, 2:27)
df <- df[,-2]
df <- subset(df, df$Trinity != "")

#split off unwanted trinity info
df2 <- colsplit(df$Trinity, ".p", c("Transcript", "trash"))
Dc <- cbind(df,df2)
Dc <- Dc[,c(1,3)]

#combine again into list separated by commas
DcS5 <- aggregate(Transcript ~ OG, Dc, paste, collapse = ', ')

#### Ei ####
comma.count <-c()
for (i in c(1:length(S5$E.imbricata))) {
  comma.count[i] <- str_count(S5$E.imbricata[i], ',')
}
max(comma.count) #18

df <- colsplit(S5$E.imbricata, ",", c(1:19))
Ei <- cbind(S5$Orthogroup, df)
colnames(Ei)[1] <- "OG"
#gather into a two column list of OG and transcript

df <- gather(Ei, alltranscripts, Trinity, 2:20)
df <- df[,-2]
df <- subset(df, df$Trinity != "")
#split off unwanted trinity info
df2 <- colsplit(df$Trinity, ".p", c("Transcript", "trash"))
Ei <- cbind(df,df2)
Ei <- Ei[,c(1,3)]
#combine again into list separated by commas
EiS5 <- aggregate(Transcript ~ OG, Ei, paste, collapse = ', ')

#### combine S5 back together ####

colnames(CmS5)[2] <- "TranscriptCm"
colnames(CcS5)[2] <- "TranscriptCc"
colnames(DcS5)[2] <- "TranscriptDc"
colnames(EiS5)[2] <- "TranscriptEi"
colnames(S5)[1] <- "OG"
dim(S5)

S5 <- merge(S5, CmS5, all.x = T)
dim(S5)
S5 <- merge(S5, CcS5, all.x = T)
dim(S5)
S5 <- merge(S5, DcS5, all.x = T)
dim(S5)

S5 <- merge(S5, EiS5, all.x = T)
dim(S5)

S5 <- S5[,-c(2:5)]
colnames(S5) <- final.S5.col.names

write.table(S5, "TableS5.txt", row.names=F, quote = F, sep = "\t")

#### S6 ####
S6 <- read.delim("/Users/shreyabanerjee/DOwnloads/TableS6.txt", sep = "\t", header = T)
final.S6.col.names <- colnames(S6)

#### Brain ####
comma.count <-c()
for (i in c(1:length(S6$Brain))) {
  comma.count[i] <- str_count(S6$Brain[i], ',')
}
max(comma.count) #18

df <- colsplit(S6$Brain, ",", c(1:19))
brain <- cbind(S6$Orthogroup, df)
colnames(brain)[1] <- "OG"
#gather into a two column list of OG and transcript

df <- gather(brain, alltranscripts, Trinity, 2:20)
df <- df[,-2]
df <- subset(df, df$Trinity != "")

#split off unwanted trinity info
df2 <- colsplit(df$Trinity, ".p", c("Transcript", "trash"))
brain <- cbind(df,df2)
brain <- brain[,c(1,3)]

#combine again into list separated by commas
brainS6 <- aggregate(Transcript ~ OG, brain, paste, collapse = ', ')

#### Blood ####
comma.count <-c()
for (i in c(1:length(S6$Blood))) {
  comma.count[i] <- str_count(S6$Blood[i], ',')
}
max(comma.count) #38

df <- colsplit(S6$Blood, ",", c(1:39))
blood <- cbind(S6$Orthogroup, df)
colnames(blood)[1] <- "OG"
#gather into a two column list of OG and transcript

df <- gather(blood, alltranscripts, Trinity, 2:40)
df <- df[,-2]
df <- subset(df, df$Trinity != "")

#split off unwanted trinity info
df2 <- colsplit(df$Trinity, ".p", c("Transcript", "trash"))
blood <- cbind(df,df2)
blood <- blood[,c(1,3)]

#combine again into list separated by commas
bloodS6 <- aggregate(Transcript ~ OG, blood, paste, collapse = ', ')

#### Lung ####
comma.count <-c()
for (i in c(1:length(S6$Lung))) {
  comma.count[i] <- str_count(S6$Lung[i], ',')
}
max(comma.count) #12

df <- colsplit(S6$Lung, ",", c(1:13))
lung <- cbind(S6$Orthogroup, df)
colnames(lung)[1] <- "OG"
#gather into a two column list of OG and transcript

df <- gather(lung, alltranscripts, Trinity, 2:14)
df <- df[,-2]
df <- subset(df, df$Trinity != "")

#split off unwanted trinity info
df2 <- colsplit(df$Trinity, ".p", c("Transcript", "trash"))
lung <- cbind(df,df2)
lung <- lung[,c(1,3)]

#combine again into list separated by commas
lungS6 <- aggregate(Transcript ~ OG, lung, paste, collapse = ', ')

#### Ovary ####
comma.count <-c()
for (i in c(1:length(S6$Ovary))) {
  comma.count[i] <- str_count(S6$Ovary[i], ',')
}
max(comma.count) #27

df <- colsplit(S6$Ovary, ",", c(1:28))
ovary <- cbind(S6$Orthogroup, df)
colnames(ovary)[1] <- "OG"
#gather into a two column list of OG and transcript

df <- gather(ovary, alltranscripts, Trinity, 2:29)
df <- df[,-2]
df <- subset(df, df$Trinity != "")

#split off unwanted trinity info
df2 <- colsplit(df$Trinity, ".p", c("Transcript", "trash"))
ovary <- cbind(df,df2)
ovary <- ovary[,c(1,3)]

#combine again into list separated by commas
ovaryS6 <- aggregate(Transcript ~ OG, ovary, paste, collapse = ', ')

#### combine S6 back together ####

colnames(brainS6)[2] <- "Transcriptbrain"
colnames(bloodS6)[2] <- "Transcriptblood"
colnames(lungS6)[2] <- "Transcriptlung"
colnames(ovaryS6)[2] <- "Transcriptovary"
colnames(S6)[1] <- "OG"
dim(S6)

S6 <- merge(S6, brainS6, all.x = T)
dim(S6)
S6 <- merge(S6, bloodS6, all.x = T)
dim(S6)
S6 <- merge(S6, lungS6, all.x = T)
dim(S6)

S6 <- merge(S6, ovaryS6, all.x = T)
dim(S6)

S6 <- S6[,-c(2:5)]
colnames(S6) <- final.S6.col.names

write.table(S6, "TableS6.txt", row.names=F, quote = F, sep = "\t")
