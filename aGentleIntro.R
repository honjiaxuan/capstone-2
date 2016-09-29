## https://eight2late.wordpress.com/2015/05/27/a-gentle-introduction-to-text-mining-using-r/#cut_to_chase
library(tm)
setwd("/home/oscar/Documents/Capstone")
con <- file("./en_US/en_US.twitter.txt", "r") ## Creates the connection to a file
docs <- Corpus(VectorSource(readLines(con)))
close(con)
writeLines(as.character(docs[[24]]))
getTransformations()

#create the toSpace content transformer
toSpace <- content_transformer(function(x, pattern) {return (gsub(pattern, "", x))})

docs <- tm_map(docs, toSpace, "-")
docs <- tm_map(docs, toSpace, ":")

writeLines(as.character(docs[[24]]))
docs <- tm_map(docs, removePunctuation)
writeLines(as.character(docs[[24]]))
docs <- tm_map(docs, toSpace, "")
docs <- tm_map(docs, toSpace, " -")
writeLines(as.character(docs[[24]]))

#Transform to lower case (need to wrap in content_transformer)
docs <- tm_map(docs,content_transformer(tolower))
writeLines(as.character(docs[[24]]))

#Strip digits (std transformation, so no need for content_transformer)
docs <- tm_map(docs, removeNumbers)

#remove stopwords using the standard list in tm
docs <- tm_map(docs, removeWords, stopwords("english"))
writeLines(as.character(docs[[24]]))

#Strip whitespace (cosmetic?)
docs <- tm_map(docs, stripWhitespace)
writeLines(as.character(docs[[24]]))

#load library
library(SnowballC)
#Stem document
writeLines(as.character(docs[[24]]))
docs <- tm_map(docs,stemDocument)
writeLines(as.character(docs[[24]]))


dtm <- DocumentTermMatrix(docs)

freq <- colSums(as.matrix(dtm))
#create sort order (descending)
ord <- order(freq,decreasing=TRUE)
#inspect most frequently occurring terms
freq[head(ord)]
#inspect least frequently occurring terms
freq[tail(ord)] 

##Here we have told R to include only those words that occur in  3 to 27 documents. 
##We have also enforced  lower and upper limit to length of the words included 
##(between 4 and 20 characters).
dtmr <-DocumentTermMatrix(docs, 
                          control=list(wordLengths=c(4, 100), 
                                       bounds = list(global = c(3,27))))
freqr <- colSums(as.matrix(dtmr))
#create sort order (descending)
ord <- order(freqr,decreasing=TRUE)
#inspect most frequently occurring terms
freqr[head(ord)]
#inspect least frequently occurring terms
freqr[tail(ord)] 

## let’s take get a list of terms that occur at least a  30 times in the entire corpus
findFreqTerms(dtmr,lowfreq=30)

##Let's find which words have a correlation higher than 0.6 with "chang" token
findAssocs(dtmr, "chang",0.6)


##Let's plot
wf=data.frame(term=names(freqr),occurrences=freqr)
library(ggplot2)
p <- ggplot(subset(wf, freqr>30), aes(term, occurrences))
p <- p + geom_bar(stat="identity")
p <- p + theme(axis.text.x=element_text(angle=45, hjust=1))
p


#wordcloud
library(wordcloud)
#setting the same seed each time ensures consistent look across clouds
set.seed(42)
#limit words by specifying min frequency
wordcloud(names(freqr),freqr, min.freq=70)
wordcloud(names(freqr),freqr,min.freq=70,colors=brewer.pal(6,"Dark2"))
