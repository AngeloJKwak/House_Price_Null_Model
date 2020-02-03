library(caret) #http://topepo.github.io/caret/index.html
library(data.table)
library(Metrics)

set.seed(77)

train <- fread('./project/volume/data/raw/Stat_380_train.csv')
test <- fread('./project/volume/data/raw/Stat_380_test.csv')

#train<-DT[,.(Id,LotArea, BldgType, OverallQual, OverallCond, YearBuilt, PoolArea, FullBath, BedroomAbvGr, SalePrice)]
train[is.na(train$SalePrice)]$SalePrice<-0
train[is.na(train)] <- 0

train_y<-train$SalePrice
test_y<-train$SalePrice

dummies <- dummyVars(SalePrice ~ LotArea + BldgType + OverallQual + OverallCond + PoolArea + SalePrice, data = train)
#train<-predict(dummies, newdata = train)
#test<-predict(dummies, newdata = train)

#reformat after dummyVars and add back response Var
train<-data.table(train)
train$SalePrice<-train_y
test<-data.table(test)

#fit a linear model
lm_model<-lm(SalePrice ~ LotArea + BldgType + OverallQual + OverallCond + PoolArea + TotRmsAbvGrd + GrLivArea + YearBuilt + BedroomAbvGr + SalePrice,data=train)

#assess model
summary(lm_model)

#save model
saveRDS(dummies,"./project/volume/models/House_Prediction_lm.dummies")
saveRDS(lm_model,"./project/volume/models/House_Prediction_lm.model")

test$SalePrice<-predict(lm_model,newdata = test)

#our file needs to follow the example submission file format. So we need to only have the Id and saleprice column and
#we also need the rows to be in the correct order

submit<-test[,.(Id,SalePrice)]

#now we can write out a submission
fwrite(submit,"./project/volume/data/processed/submit_lm.csv")

