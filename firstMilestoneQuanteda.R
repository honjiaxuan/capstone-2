require(quanteda)
library(doMC)
library(text2vec)
registerDoMC(cores = 4)
mytext <- readLines("/home/oscar/Documents/DSSCapstone/en_US/en_US.twitter.txt")
splits <- split_into(mytext, 20)

library(foreach)
library(doParallel)

f <- 0
s1 <- Sys.time()
finalMatrix <- foreach(i=1:length(splits), .packages = c("quanteda")) %dopar% {
        dfm <- dfm(as.character(splits[i]), ignoredFeatures = stopwords("english"), stem = TRUE)
        f <- f + colSums(dfm)
}
s2 <- Sys.time()
s2 - s1

countWords <- 0
for(i in 1:length(finalMatrix)) {
        countWords <- finalMatrix[[i]] + countWords
}
countWords <- sort(countWords, decreasing = T)
barplot(countWords[1:10])
## Now, I have to compare this countword with the deployed by the function quanteda by itself