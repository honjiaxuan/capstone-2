## Launch Spark session
if (nchar(Sys.getenv("SPARK_HOME")) < 1) {
        Sys.setenv(SPARK_HOME = "/usr/local/spark")
}
library(SparkR, lib.loc = c(file.path(Sys.getenv("SPARK_HOME"), "R", "lib")))
sparkR.session(master = "local[*]", sparkConfig = list(spark.driver.memory = "2g"))

sparkR.session(sparkPackages = "com.databricks:spark-avro_2.11:3.0.0")

data <- read.text("/home/oscar/Documents/DSSCapstone/en_US/en_US.twitter.txt")
View(data)
