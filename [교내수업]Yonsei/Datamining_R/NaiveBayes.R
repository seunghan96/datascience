###################
## 4. Naive Bayes
###################

setwd('C:\\Users\\samsung\\Desktop\\연세대\\2019.2학기\\경영\\데마')
del = read.csv('FlightDelays.csv', na.strings='')

head(del)
str(del)

# data preprocessing
del$DAY_WEEK <- factor(del$DAY_WEEK)
del$DAY_OF_MONTH <- factor(del$DAY_OF_MONTH)
del$CRS_DEP_TIME <- factor(round(del$CRS_DEP_TIME/100))


# summary
summary(del)
by(del, del$CARRIER, summary) # carrier에 따른 summary

# 정교한 summary
library(Hmisc)
Hmisc::describe(del)

# checking missing values
colSums(is.na(del))  # No missing value

# train_test_split
set.seed(102) 
sam = sample(dim(del)[1],dim(del)[1]*0.7 )
train = del[sam,c(1,2,4,8,10,13)]
test = del[-sam,c(1,2,4,8,10,13)]

# Naive Bayes
library(e1071)
colnames(train)

# input : train dataset / output : y variable
delNB <- naiveBayes(Flight.Status~., data=train)
delNB

#table(train$Flight.Status, train$DEST)
prop.table(table(train$Flight.Status, train$DEST), margin=1)

# predict one data
test[37,]
predict(delNB, test[37,])

pred = predict(delNB, test)
predprob = predict(delNB,test,type='raw')
predprob
# Accuracy (80%)
sum(test$Flight.Status == predict(delNB,test)) / length(predict(delNB,test))

# 4가지 조건을 충족하는 경우는?
filter = test$CARRIER=='DL' & test$DAY_WEEK==7 & test$CRS_DEP_TIME==10 & test$DEST=='LGA' & test$ORIGIN=='DCA'
df = data.frame(actual=test$Flight.Status, predicted=pred, predprob )
df

newrecord = test[filter,]
newrecord_pred = predict(delNB, newrecord, type='raw')
newrecord_class = predict(delNB, newrecord)
newrecord_pred
newrecord_class

###########################################
library(pROC)

ROC = roc((ifelse(test$Flight.Status=='delayed',1,0)), predprob[,1])
plot(ROC)
auc(ROC)
############################################
library(gains)

gain = gains(ifelse(test$Flight.Status=='delayed',1,0), predprob[,1], groups=10)
plot(c(0,gain$cume.obs), 
     c(0,gain$cume.pct.of.total*sum(test$Flight.Status=='delayed')), 
     xlab='# cases',ylab='Cumulative',main='title', type='p')

lines(c(0,dim(test)[1]), 
     c(0,sum(test$Flight.Status=='delayed')))
#############################################
library(caret)

trainpred = predict(delNB, train)
confusionMatrix(trainpred, train$Flight.Status)

testpred = predict(delNB, test)
confusionMatrix(testpred, test$Flight.Status)
