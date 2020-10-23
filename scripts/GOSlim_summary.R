#### Visualize the distribution of GO annotations ####
require(ggplot2)

#read in GO slim output
Slim <- read.table("GO-slim_directGOcount_bioprocess.txt", sep = "\t")

#make GO slim counts a column
GOSlim <- row.names(Slim) 
Slim$GOSlim <- GOSlim

#make barplot summarizing GO slim category distribution

ggplot(data=Slim, aes(x=reorder(GOSlim, GO), y=GO)) +
  geom_bar(stat="identity",fill='aquamarine4') +
  coord_flip() + 
  theme_classic()+
  xlab(NULL) +
  ylab ("Number of transcripts associated with GO term")+
  theme(text = element_text(size=15))
