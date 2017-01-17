library(doMC)
registerDoMC(cores = 4)
library(foreach)
library(doParallel)
devset <- readRDS("./devsetRDS")
testset <- readRDS("./testsetRDS")
evalset <- readRDS("./evalsetRDS")
trigrams <- readRDS("./train3gramRDS")
bigrams <- readRDS("./train2gramtRDS")
onegrams <- readRDS("./train1gramtRDS")
## Stablishing sparklyr conection
library(sparklyr)
library(dplyr)
sc <- spark_connect(master = "local")
## Transforming some sets for prunning to reduce perplexity of the system
library(data.table)
## Converting to data.table for speed up
onegrams <- data.table(tokens = names(onegrams), num = as.integer(onegrams))
## importing data set to spark
one <- copy_to(sc, onegrams)
## order by num in descending
one <- setorder(one, -num)
## keep just the three more frecuents onegrams. This is with the aim of reduce the 
## perplexity and thinking about the efficiency of the app
onegrams <- onegrams[1:3]
## Converting to data.table for speed up
bigrams <- data.table(tokens = names(bigrams), num = as.integer(bigrams))
## Split each bigram on onegrams 
bigrams[, c("t1", "t2") := tstrsplit(tokens, "_", fixed = TRUE)]
## order by num in descending
bigrams <- setorder(bigrams, -num)
## for the each initial word keep just the three more frecuents bigrams
## This is with the aim of reduce the perplexity and thinking about the efficiency
## of the app
prunebigrams <- bigrams[, head(.SD, 3), by = t1]
## Converting to data.table for speed up
trigrams <- data.table(tokens = names(trigrams), num = as.integer(trigrams))
## Split each bigram on onegrams 
trigrams[, c("t1", "t2", "t3") := tstrsplit(tokens, "_", fixed = TRUE)]
## order by num in descending
trigrams <- setorder(trigrams, -num)
## for the each initial word keep just the three more frecuents bigrams
## This is with the aim of reduce the perplexity and thinking about the efficiency
## of the app
trigrams$t1_t2 <- paste(trigrams$t1, trigrams$t2, sep = "_")
trigrams <- setorder(trigrams, -num)
prunetrigrams <- trigrams[, head(.SD, 3), by = .(t1_t2)]
###################################################################################
saveRDS(bigrams, "./bigrams2RDS")
saveRDS(prunebigrams, "./prunebigramsRDS")
saveRDS(onegrams, "./pruneonegramsRDS")
saveRDS(trigrams, "./trigrams2RDS")
saveRDS(prunetrigrams, "./prunetrigramsRDS")
###################################################################################
## Restarting
###################################################################################
## Loading libraries, parallelizing and files
library(doMC)
registerDoMC(cores = 4)
library(foreach)
library(doParallel)
data <- readRDS("./devsetRDS")
## Cleaning the text and splitting by phrases
library(quanteda)
library(text2vec)
data <- split_into(data, 100)
dataProcess <- foreach(i=1:length(data), .combine = rbind, 
                       .packages = c("quanteda")) %dopar% {
                               splitsn <- as.vector(data[[i]])
                               ng <- tokenize(toLower(splitsn), what = c("sentence") , 
                                              verbose = FALSE, removeNumbers = TRUE, 
                                              removePunct = TRUE, removeSymbols = TRUE, 
                                              removeSeparators = TRUE, removeTwitter = TRUE, 
                                              removeHyphens = TRUE, removeURL = TRUE, 
                                              simplify = TRUE)
                       }
dataProcess <- as.vector(dataProcess)
## Splitting the phrases into words
splitted <- foreach(i=1:length(dataProcess), .combine = rbind) %dopar% {
        splitsn <- 
                temp <- strsplit(as.vector(dataProcess[i]), " ")
}

#########################################################################################################
saveRDS(splitted, "./splittedRDS")
#########################################################################################################
splitted <- readRDS("./splittedRDS")
prunebigrams <- readRDS("./prunebigramsRDS")
prunetrigrams <- readRDS("./trigrams2RDS")
pruneonegrams <- readRDS("./pruneonegramsRDS")
#########################################################################################################
library(data.table)

for(j in 1:10){
        temp <- pruneonegrams
        i <- length(splitted[[j]])-2
        f <- length(splitted[[j]])-1
        if(i > 0){
                phrase <- paste(splitted[[j]][[i]], splitted[[j]][[f]], sep = "_")
                temp <- prunetrigrams[t1_t2 == as.character(phrase), c("t3"), with = F][1:3,]
                na <- sum(is.na(temp))
                nr <- nrow(temp)
                n <- nr - na
                if(n > 0){
                        temp <- temp[1:n]
                } else temp <- "my ass" ## It's leaking for this pipe and keep NULL ("my ass)
        } else if(f == 1 || is.null(temp)){
                phrase <- splitted[[j]][[f]]
                temp <- prunetrigrams[t1 == as.character(phrase), c("t2"), with = F][1:3,]
                na <- sum(is.na(temp))
                nr <- nrow(temp)
                n <- nr - na
                if(n > 0){
                        temp <- temp[1:n]
                } else temp <- pruneonegrams$tokens
        }
        print(temp)
}


#5. Evaluating algortihm (IMPORTANT: DEV A FUNCTION WHICH CALCULATE THE
#PERPLEXITY VAR) # 5.1. read the devtest # 5.2 Split all the sentences and 
#create a new matrix: the first col (say X) is the n-1 words # of the sentence, 
#and the second col (Y) is the last word of the sentence # 5.3. Pass as argument
#to the prediction function the X's elements and store the responses # 5.4. 
#Compare the responses against the Y's and make the accuracy stat

#6. Tune the model and analyse if the 3-gram predictor is the best choice

#7. Run the model against the testset

#8. Run the model against the finalset