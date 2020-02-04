library(caret) 
library(data.table)
library(Metrics)

#read in data
train <- fread('./project/volume/data/raw/Stat_380_train.csv')
test <- fread('./project/volume/data/raw/Stat_380_test.csv')

#Fill in any null values with 0
train[is.na(train)] <- 0

train_y<-train$SalePrice
test_y<-train$SalePrice

#I ran into issues trying to work with dummy variables, so while this is still here, they were not used any further in the model
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

#use the model with the test dataset 
test$SalePrice<-predict(lm_model,newdata = test)

#format the final table for submission
submit<-test[,.(Id,SalePrice)]

#now we can write out a submission
fwrite(submit,"./project/volume/data/processed/submit_lm.csv")