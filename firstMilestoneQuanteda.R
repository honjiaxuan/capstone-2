## Loading packages
require(quanteda)
library(doMC)
library(text2vec)
## Enabling multicore
registerDoMC(cores = 4)
## Reading in the text
mytext <- readLines("/home/oscar/Documents/DSSCapstone/en_US/en_US.twitter.txt")
## Splitting the text in chunks
splits <- split_into(mytext, 100)
rm(mytex)
library(foreach)
library(doParallel)
## Parallelizing the quanteda functions
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
## Save the file
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
## Save the file
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
## Save the file
saveRDS(threegrams, "./twitter_dfm_threegrams")
#################################################################################
## Reading the previously saved objects
require(quanteda)
library(doMC)
## Enabling multicore
registerDoMC(cores = 4)
df1 <- colSums(readRDS("./twitter_dfm"))
df2 <- colSums(readRDS("./twitter_dfm_bigrams"))
df3 <- colSums(readRDS("./twitter_dfm_threegrams"))
## Exploring their structure
head(df1)
head(df2)
head(df3)
## Converting to data.frames structure
df1 <- as.data.frame(df1)
df1$token <- rownames(df1)
names(df1) <- c("n", "token")
rownames(df1) <- NULL

df2 <- as.data.frame(df2)
df2$token <- rownames(df2)
names(df2) <- c("n", "token")
rownames(df2) <- NULL

df3 <- as.data.frame(df3)
df3$token <- rownames(df3)
names(df3) <- c("n", "token")
rownames(df3) <- NULL
## Looking at her sizes. Because of the RAM issues I'm facing with those big files
object.size(df1)/1024/1024; object.size(df2)/1024/1024; object.size(df3)/1024/1024
#################################################################################
## Saving the more usefull and light objects
require(quanteda)
library(doMC)
## Enabling multicore
registerDoMC(cores = 4)
saveRDS(df1, "./words1")
saveRDS(df2, "./words2")
saveRDS(df3, "./words3")
rm(list = c("df1", "df2", "df3"))
gc()
#################################################################################
## I have to save the objects, close session and restart it because of the RAM consumption
require(quanteda)
library(doMC)
## Enabling multicore
registerDoMC(cores = 4)
s1 <- Sys.time()
df1 <- readRDS("./words1")
s2 <- Sys.time()
s2-s1
s1 <- Sys.time()
df2 <- readRDS("./words2")
s2 <- Sys.time()
s2-s1
s1 <- Sys.time()
df3 <- readRDS("./words3")
s2 <- Sys.time()
s2-s1
#################################################################################
## Exploring how percentage of the total is each token and the cumulative percentage

## Featuring what percentage of total of the sample each token is
df1$perc <- df1$n/sum(df1$n)
df2$perc <- df2$n/sum(df2$n)
df3$perc <- df3$n/sum(df3$n)
## ordering the data frames by perc in decreasing order
df1 <- df1[order(-df1$perc),]
df2 <- df2[order(-df2$perc),]
df3 <- df3[order(-df3$perc),]
## Featuring how much the cumulative percentage increases with each token
df1$cumperc <- cumsum(df1$perc)
df2$cumperc <- cumsum(df2$perc)
df3$cumperc <- cumsum(df3$perc)
## Agregating a num for plots
df1$ID <- c(1:nrow(df1))
df2$ID <- c(1:nrow(df2))
df3$ID <- c(1:nrow(df3))
## Creating a col with the percentage from 1 (max percentage) to 0 (min percentage)
df1$percTrans <- (df1$perc - min(df1$perc)) / (max(df1$perc) - min(df1$perc))
df2$percTrans <- (df2$perc - min(df2$perc)) / (max(df2$perc) - min(df2$perc))
df3$percTrans <- (df3$perc - min(df3$perc)) / (max(df3$perc) - min(df3$perc))
## Keeping in mind the issue about the size of the files, I'll keep just the tokens which
## represents the 0.8 out of the total of the cases
s <- data.frame(name = c("df1", "df2", "df3"), inicialSize = c(object.size(df1), 
                                                               object.size(df2), 
                                                               object.size(df3)))
df1 <- df1[df1$cumperc<=0.8,]
df2 <- df2[df2$cumperc<=0.8,]
df3 <- df3[df3$cumperc<=0.8,]
s$finalSize <- c(object.size(df1), object.size(df2), object.size(df3))
s$perc <- (s$finalSize / s$inicialSize) - 1
s
##########################################################################################
## Saving objects
saveRDS(df1, "./wordspruned1")
saveRDS(df2, "./wordspruned2")
saveRDS(df3, "./wordspruned3")
##########################################################################################
##########################################################################################
##########################################################################################
df1 <- readRDS("./wordspruned1")
df2 <- readRDS("./wordspruned2")
df3 <- readRDS("./wordspruned3")
##########################################################################################
## plotting the cumulative percentages
## Because of the size of the objects, the pl
library(ggplot2)
g <- ggplot(data = df1, aes(x=ID, y=cumperc))
g <- g + geom_point()
g <- g + geom_point(data = df1, aes(x=ID, y=percTrans), colour="blue")
g

g <- ggplot(data = df2, aes(x=ID, y=cumperc))
g <- g + geom_point()
g <- g + geom_point(data = df2, aes(x=ID, y=percTrans), colour="blue")
g

g <- ggplot(data = df3, aes(x=ID, y=cumperc))
g <- g + geom_point()
g <- g + geom_point(data = df3, aes(x=ID, y=percTrans), colour="blue")
g
## Plotting the cumulative percentage

###############################################################################