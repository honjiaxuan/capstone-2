library(tm)
library(doMC)
registerDoMC(cores = 6)
twitter <- readLines("/home/oscar/Documents/Capstone/en_US/en_US.twitter.txt")

data <- data.frame(text=twitter, stringsAsFactors = F)










max(nchar(docs))
docs <- Corpus(VectorSource(docs))
writeLines(as.character(docs[[1000]]))
#create the toSpace content transformer
toSpace <- content_transformer(function(x, pattern) {return (gsub(pattern, "", x))})

docs <- tm_map(docs, toSpace, "-")
docs <- tm_map(docs, toSpace, ":")
writeLines(as.character(docs[[1000]]))
############################################################################
sum(as.numeric(grep("love", blogs))) / sum(as.numeric(grep("hate", blogs)))
sum(grepl("love", twitter)) / sum(grepl("hate", twitter))
twitter[which(grepl("biostats", twitter))]
twitter[[556872]]
sum(grepl("A computer once beat me at chess, but it was no match for me at kickboxing", 
      twitter))
