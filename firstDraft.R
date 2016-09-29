library(tm)
setwd("/home/oscar/Documents/Capstone/capstone")
## corp <- Corpus(DirSource("./en_US"), readerControl = list(language="en"))
## This read all the directory: three files: 799.5 Mb
con <- file("./en_US/en_US.blogs.txt") ## Creates the connection to a file
samp <- readLines(con)
close(con)
#################################
p <- 1000/length(samp) ## the probability or the size of the sample of the doc you wanna get
rsamp <- samp[sample(seq(1, length(samp)), size = length(samp) * p)] 
## samp is now a p proportion sample of the original set, for calculations
saveRDS(rsamp, "./rsamp.RDS")
