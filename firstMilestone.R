## http://stackoverflow.com/questions/25330753/more-efficient-means-of-creating-a-corpus-and-dtm-with-4m-rows

library(tm)
library(doMC)
registerDoMC(cores = 4)
## Puts the text in a matrix as rows each one
data <- data.frame(text=readLines("/home/oscar/Documents/DSSCapstone/en_US/en_US.twitter.txt"), 
                   n = 5000, stringsAsFactors = F)

library(stringi)
library(SnowballC)
## This function break all sentences in words: takes each row and break them in columns
## Now each row is a list
out <- stri_extract_all_words(stri_trans_tolower(SnowballC::wordStem(data[[1]], "english")))
## in old package versions it was named 'stri_extract_words'
## Then get names to each of the cols: 'doc1', 'doc2'...
names(out) <- paste0("doc", 1:length(out))
## Separate the lists and the keep just the unique values: make a vector with the unique values
lev <- sort(unique(unlist(out)))
## Creates a matrix term x freq in each doc
dat <- do.call(cbind, lapply(out, function(x, lev) {
        tabulate(factor(x, levels = lev, ordered = TRUE), nbins = length(lev))
}, lev = lev))

## Assign the term as row name
rownames(dat) <- sort(lev)

library(tm)
## remove stop words as rows
dat <- dat[!rownames(dat) %in% tm::stopwords("english"), ] 

library(slam)
dat2 <- slam::as.simple_triplet_matrix(dat)

tdm <- tm::as.TermDocumentMatrix(dat2, weighting=weightTf)
tdm

## or...
## dtm <- tm::as.DocumentTermMatrix(dat2, weighting=weightTf)
## dtm
##########################################################
freq <- rowSums(as.matrix(dat))
barplot(sort(freq, decreasing = T))
head(sort(freq, decreasing = T))
Terms(tdm)


