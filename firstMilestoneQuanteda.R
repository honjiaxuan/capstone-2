require(quanteda)
library(doMC)
registerDoMC(cores = 6)
mytext <- readLines("/home/oscar/Documents/Capstone/en_US/en_US.twitter.txt")
dfm <- dfm(mytext, ignoredFeatures = stopwords("english"), stem = TRUE)
## The elapsed time for this dfm was 389 seconds, around 6.48 minutes.
## That's no so bad