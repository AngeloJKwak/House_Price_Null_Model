library(data.table)
library(Metrics)


train_DT <- fread('./project/volume/data/raw/Stat_380_train.csv')
test_DT <- fread('./project/volume/data/raw/Stat_380_test.csv')

# make a null model

avg_price<-mean(train_DT$SalePrice)

test_DT$SalePrice<-avg_price

# in my example I do not need to make a submit file, but if I did I would do something like this
fwrite(test_DT[,.(Id,SalePrice)],"./project/volume/data/processed/submit.csv")