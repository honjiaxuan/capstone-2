library(text2vec)
library(data.table)
mytext <- readLines("/home/oscar/Documents/Capstone/en_US/en_US.twitter.txt")
## Example of parallel mode
# set to number of cores on your machine
N_WORKERS = 4
doParallel::registerDoParallel(N_WORKERS)
splits = split_into(mytext, N_WORKERS)
jobs = lapply(splits, itoken, tolower, word_tokenizer, chunks_number = 1)
vectorizer = hash_vectorizer()
dtm = create_dtm(jobs, vectorizer, type = 'dgTMatrix')

##########################################################################

library(text2vec)
library(data.table)
mytext <- readLines("/home/oscar/Documents/Capstone/en_US/en_US.twitter.txt")

it = itoken(mytext, preprocess_function = tolower,
            tokenizer = word_tokenizer)
v = create_vocabulary(it)
#remove very common and uncommon words
pruned_vocab = prune_vocabulary(v, term_count_min = 10,
                                doc_proportion_max = 0.5, doc_proportion_min = 0.001)
vectorizer = vocab_vectorizer(v)
it = itoken(mytext, preprocess_function = tolower,
            tokenizer = word_tokenizer)
dtm = create_dtm(it, vectorizer)
# get tf-idf matrix from bag-of-words matrix
dtm_tfidf = transformer_tfidf(dtm)
