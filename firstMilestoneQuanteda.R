require(quanteda)
library(doMC)
library(text2vec)
registerDoMC(cores = 4)
mytext <- readLines("/home/oscar/Documents/DSSCapstone/en_US/en_US.twitter.txt")

splits <- split_into(mytext, 20)

library(foreach)
library(doParallel)
## It's my decision to not remove stop words nor stem the words because the aim of the algo
## it's to predict the writing of a human, and humans use stop words and no pruned words
s1 <- Sys.time()
finalMatrix <- foreach(i=1:length(splits), .combine = rbind, .packages = c("quanteda")) %dopar% {
        splitsn <- as.vector(splits[[i]])
        dfm <- dfm(as.character(splitsn), what = c("word"), removeNumbers = T, removePunct = T, 
                   removeSymbols = T, removeSeparators = T, removeTwitter = T, removeHyphens = T, 
                   removeURL = T)
}
s2 <- Sys.time()
s2 - s1
#################################################################################
saveRDS(finalMatrix, "./twitter_dfm")
#################################################################################
df <- readRDS("./twitter_dfm")
df <- finalMatrix
words <- colSums(df)
words <- sort(words, decreasing = T)
barplot(head(words))
head(df)
coll <- collocations(mytext, punctuation = "dontspan")
saveRDS(coll, "./collocations")
###############################################################################
## To parallelize
ng <- ngrams(tokenize(mytext, what = c("word"), removeNumbers = T, removePunct = T, removeSymbols = T, 
                      removeSeparators = T, removeTwitter = T, removeHyphens = T, removeURL = T, 
                      simplify = F))
