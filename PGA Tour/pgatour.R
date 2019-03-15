#Homework 2 - PGA Tour 2006


#Make data.frame of pga data
setwd("~/Winter 2018/STAT 330 - Intro to Regression/Homework/Homework 2")
tour <- read.csv("pgatour2006.csv", header=TRUE)

#Vector of columns to keep
keep <- c("PrizeMoney", "AveDrivingDistance", "DrivingAccuracy", "GIR", "PuttingAverage",
          "BirdieConversion", "SandSaves", "Scrambling", "BounceBack", "PuttsPerRound")

#Filtered data.frame of data to use
tourdat <- tour[keep]

#Train/Test datasets
set.seed(123)
train.row <- sample(196, 150)
train <- tourdat[train.row,]
test <- tourdat[-train.row,]

#Fit a Random Forest
library(randomForest)
my.woods <- randomForest(x=train[,-1], y=train$PrizeMoney,
                         xtest=test[,-1], ytest=test$PrizeMoney,
                         replace=TRUE, keep.forest=TRUE, ntree=200,
                         mtry=3, nodesize=5)


#Report Training and Test RMSE
my.woods

#Train RMSE
sqrt(3653604988)  # == 60445.06

#Test RMSE
sqrt(2028806329)  # == 45042.27


#Important Explanatory Variables
importance(my.woods)
varImpPlot(my.woods)

#Tiger Woods Observation and Prediction
tiger <- tour[178, keep]
tiger <- tiger[,-1]
tiger

predict(my.woods, newdata=tiger) #Prediction is $406,756.2 when he actually won $662,771
