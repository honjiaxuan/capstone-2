## ignoredFeatures = "RT"
require(quanteda)
library(doMC)
library(text2vec)
registerDoMC(cores = 4)
mytext <- readLines("/home/oscar/Documents/DSSCapstone/en_US/en_US.twitter.txt")
splits <- split_into(mytext, 100)
rm(mytex)
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
## To parallelize bi-grams
s1 <- Sys.time()
bigrams <- foreach(i=1:length(splits), .combine = rbind, .packages = c("quanteda")) %dopar% {
        splitsn <- as.vector(splits[[i]])
        ng <- dfm(tokenize(splitsn, ngrams = 2 , removeNumbers = T, removePunct = T, 
                              removeSymbols = T, removeSeparators = T, removeTwitter = T, 
                              removeHyphens = T, removeURL = T, simplify = F))
}
s2 <- Sys.time()
s2 - s1
## It tooks 17.28692 mins
#################################################################################
saveRDS(bigrams, "./twitter_dfm_bigrams")
#################################################################################
## To parallelize three-grams
s1 <- Sys.time()
threegrams <- foreach(i=1:length(splits), .combine = rbind, .packages = c("quanteda")) %dopar% {
        splitsn <- as.vector(splits[[i]])
        ng <- dfm(tokenize(splitsn, ngrams = 3 , removeNumbers = T, removePunct = T, 
                           removeSymbols = T, removeSeparators = T, removeTwitter = T, 
                           removeHyphens = T, removeURL = T, simplify = F))
}
s2 <- Sys.time()
s2 - s1
## It tooks 38.22526 mins
#################################################################################
saveRDS(threegrams, "./twitter_dfm_threegrams")
#################################################################################
df <- readRDS("./twitter_dfm")
df <- finalMatrix
words <- colSums(df)
words <- sort(words, decreasing = T)
wordsdf <- as.data.frame(words)

wordsdf$w <- rownames(wordsdf)
rownames(wordsdf) <- NULL
names(wordsdf) <- c("times", "words")
barplot(head(words))

library(ggplot2)
g <- ggplot(data = wordsdf, aes(x = words, y = times))
g <- g + geom_density()
g



plot(density(wordsdf$times))
head(df)
coll <- collocations(mytext, punctuation = "dontspan")
saveRDS(coll, "./collocations")
###############################################################################