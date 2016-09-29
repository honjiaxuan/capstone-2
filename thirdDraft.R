ptm <- proc.time()
setwd("/home/oscar/Documents/Capstone/capstone")
con <- file("/home/oscar/Documents/Capstone/en_US/en_US.blogs.txt", "r") ## Creates the connection to a file
samp <- readLines(con)
close(con)
p <- 1000 ## the probability or the size of the sample of the doc you wanna get
samp <- samp[sample(seq(1, length(samp)), size = p)]
library (openNLP)
library (tm)
library (qdap)
library(RWeka)
doc <- sent_detect(samp, language = "en", model = NULL) # splitting of text 
## paragraphs into sentences
corpus <- VCorpus(VectorSource(doc)) # main corpus with all sample files
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, stripWhitespace)
corpus <- tm_map(corpus, tolower)
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeWords, stopwords("english"))
## remove offensive and profane words
corpus <- tm_map(corpus, PlainTextDocument)
cleanCorpus <- data.frame(text=unlist(sapply(corpus, `[`, "content")), stringsAsFactors=F)
tdm <- TermDocumentMatrix(corpus)


## head(cleanCorpus, 6)
Onegram <- NGramTokenizer(corpus, 
                          Weka_control(min = 1, max = 1,delimiters = " \\r\\n\\t.,;:\"()?!"))
Bigram <- NGramTokenizer(corpus, 
Weka_control(min = 2, max = 2,delimiters = " \\r\\n\\t.,;:\"
()?!"))
Trigram <- NGramTokenizer(corpus, 
                          Weka_control(min = 3, max = 3,delimiters = " \\r\\n\\t.,;:\"()?!"))

Tab_onegram <- data.frame(table(Onegram))
Tab_bigram <- data.frame(table(Bigram))
Tab_trigram <- data.frame(table(Trigram))

OnegramGrp <- Tab_onegram[order(Tab_onegram$Freq,decreasing = TRUE),]
BigramGrp <- Tab_bigram[order(Tab_bigram$Freq,decreasing = TRUE),]
TrigramGrp <- Tab_trigram[order(Tab_trigram$Freq,decreasing = TRUE),]

OneSamp <- OnegramGrp[1:35,]
colnames(OneSamp) <- c("Word","Frequency")
BiSamp <- BigramGrp[1:35,]
colnames(BiSamp) <- c("Word","Frequency")
TriSamp <- TrigramGrp[1:35,]
colnames(TriSamp) <- c("Word","Frequency")