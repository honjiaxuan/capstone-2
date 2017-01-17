library(text2vec)
library(data.table)
mytext <- readLines("/home/oscar/Documents/DSSCapstone/en_US/en_US.twitter.txt", n = 5)

#################################################################
## gotta create first a db filehash. Read the documentation. The package created by Roger Peng
## promise to facilitate the hashing of big files
## Then, with Pcorpus you can load this file, making it accesible from disk without have to put
## all on RAM.
## Letś explore this approach. Even when I think that with text2vec it's not neccesary.
PCorpus(mytext,
        readerControl = list(reader = readLines("/home/oscar/Documents/DSSCapstone/en_US/en_US.twitter.txt", n = 5), language = "en"),
        dbControl = list(dbName = "", dbType = "DB1"))
#################################################################

prep_fun = tolower
tok_fun = word_tokenizer
it_train = itoken(mytext, 
                  preprocessor = prep_fun, 
                  tokenizer = tok_fun,
                  progressbar = TRUE)
vocab <- create_vocabulary(it_train, ngram = c(ngram_min = 2L, ngram_max = 4L))
vocab

head(setorder(vocab$vocab, -terms_counts))
tail(setorder(vocab$vocab, -terms_counts))
head(setorder(vocab$vocab, terms), 100)
tail(setorder(vocab$vocab, terms), 100)
############################################
vectorizer = vocab_vectorizer(vocab)
t1 = Sys.time()
dtm_train = create_dtm(it_train, vectorizer)
print(difftime(Sys.time(), t1, units = 'sec'))