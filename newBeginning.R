## Launching Sparkr
if (nchar(Sys.getenv("SPARK_HOME")) < 1) {
        Sys.setenv(SPARK_HOME = "/usr/local/spark")
}
library(SparkR, lib.loc = c(file.path(Sys.getenv("SPARK_HOME"), "R", "lib")))
sparkR.session(master = "local[*]", sparkConfig = list(spark.driver.memory = "2g"))
## Load data
df <- data.frame(text=readLines("/home/oscar/Documents/DSSCapstone/en_US/en_US.twitter.txt", n = 1000), 
                 stringsAsFactors = F)

df <- as.DataFrame(df)
head(df)

ldf <- dapplyCollect(
        df,
        function(x) {
                x <- gsub("@\\w+ *#", "", x)
        })
ldf <- as.DataFrame(as.data.frame(ldf))
################################################
schema <- structType(structField("text", "string"))
df1 <- dapply(df, function(x) { x <- gsub("@\\w+ *#", "", x)
                                x <- gsub("(f|ht)tp(s?)://(.*)[.][a-z]+", "", x)}, schema)
