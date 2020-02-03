library(data.table)
library(Metrics)


train_DT <- fread('./project/volume/data/raw/Stat_380_train.csv')
test_DT <- fread('./project/volume/data/raw/Stat_380_test.csv')

# make a null model

avg_price<-mean(train_DT$SalePrice)


#group by airport first to make a little more interesting model

bldg_types <-train_DT[,.(SalePrice=mean(SalePrice)),by=BldgType]

setkey(bldg_types,BldgType)
setkey(test_DT,BldgType)

test<-merge(test_DT,bldg_types, all.x=T)

# in my example I do not need to make a submit file, but if I did I would do something like this
fwrite(test[,.(Id,SalePrice)],"./project/volume/data/processed/submit.csv")


##NEW STUFF
#pick three or four variables to work with for building a model. 
#will work better if continuous
#A lot of the stuff above should be moved into features