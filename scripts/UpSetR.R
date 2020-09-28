#### Visualize orthofinder results with UpsetR ####
require("UpSetR")
# read in data
orthogroups <- read.table("Orthogroups.tsv", sep="\t", header =T)
# rename columns
colnames(orthogroups) <- c("Orthogroup", "A", "B",  "C", "D")
#change which genes of each transcriptome in each orthogroup to whether present or absent
for (i in c(2:ncol(orthogroups))) {
  orthogroups[,i] <- ifelse(orthogroups[,i] == "", "0", "1")
  orthogroups[,i] <- as.numeric(orthogroups[,i])
}
#make basic plot
upset(orthogroups, 
      sets = c("A", "B",  "C", "D"), 
      order.by = "freq", 
      mainbar.y.label = "number of orthogroups shared", 
      sets.x.label = "Orthogroups per species", 
      keep.order = TRUE)

#make plot with queries (specific groups with specific colors) and other customizations
upset(orthogroups, 
      sets = c("A", "B",  "C", "D"), 
      order.by = "freq", 
      number.angles = 30, 
      point.size = 3.5, 
      line.size = 2, 
      mainbar.y.label = "number of orthogroups shared", 
      sets.x.label = "Orthogroups per species", 
      text.scale = c(2.3, 2.3, 2, 2, 3, 2.6), 
      keep.order = TRUE, 
      queries = list(list(query = intersects, params = list("A", "B",  "C", "D"), color = "red", active = T)))
