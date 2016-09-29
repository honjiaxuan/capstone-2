## Importing
## Previously in the firstDraft.R script we get the text and save it as a RDS object
## So here we read it
sam <- readRDS("./rsamp.RDS")
df <- data.frame(V1=sam, stringsAsFactors = F)
library(tm)

## This code take to a impossible amount of RAM required
## mycorpus <- Corpus(DataframeSource(df))
## tdm <- TermDocumentMatrix(mycorpus, control = 
##                                  list(removePunctuation = TRUE, stopwords = TRUE))
## inspect(tdm)

library(RWeka)
library(NLP)
library(qdap)
doc <- sent_detect(sam, language = "en", model = NULL)