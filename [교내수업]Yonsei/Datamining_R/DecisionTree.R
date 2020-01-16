setwd('C:\\Users\\samsung\\Desktop\\연세대\\2019.2학기\\경영\\데마')

#### 1. Importing Data
bank = read.csv('UniversalBank.csv', na.strings="")
bank$Personal.Loan = factor(bank$Personal.Loan)
bank = bank[,-c(1,5)]


#### 2. Partitioning Data
set.seed(1)
train.index = sample(dim(bank)[1],dim(bank)[1]*0.6)
train = bank[train.index,]
valid = bank[-train.index,]


#### 3. Modeling (1) simple Tree
library(rpart)
default = rpart(Personal.Loan ~., data=train, method='class')
default

library(rpart.plot)
prp(default, type=1, extra=1, under=TRUE, split.font=2, varlen=-10)
prp(default, type=1, extra=1, under=TRUE, split.font=1, varlen=-10,
    box.col=ifelse(default$frame$var=="<leaf>",'gray','white'))
                                                                    
default$frame$var
default$frame$var[1]
class(default$frame$var)
length(default$frame$var)

length(default$frame$var[default$frame$var=="<leaf>"])
rpart.rules(default)

library(RColorBrewer)
library(rattle)
fancyRpartPlot(default)


#### 3. Modeling (2) deeper Tree
deeper = rpart(Personal.Loan ~., data=train, method='class', cp=0, minsplit=1)
prp(deeper, type=1, extra=1, under=TRUE, split.font=1,
    varlen=-10, box.col=ifelse(deeper$frame$var=="<leaf>",'gray','white'))

# Tree with other params
ploan.ct1 = rpart(Personal.Loan~., data=train, method='class',maxdepth=3)
prp(ploan.ct1, type=1, extra=1, under=TRUE, split.font=1, varlen=-10, box.col=ifelse(ploan.ct1$frame$var=='<leaf>','gray','white'))

ploan.ct2 = rpart(Personal.Loan ~., data=train, method='class',minbucket=15)
prp(ploan.ct2, type=1, extra=1, under=TRUE, split.font=1, varlen=-10, box.col=ifelse(ploan.ct2$frame$var=="<leaf>",'gray','white'))


#### 4. Evaluation

### default ct ##
library(caret)
default.ct.point.pred.train = predict(default, train, type='class')
confusionMatrix(default.ct.point.pred.train, train$Personal.Loan)

default.ct.point.pred.valid = predict(default, valid, type='class')
confusionMatrix(default.ct.point.pred.valid, valid$Personal.Loan)

### deeper ct ##
deeper.ct.point.pred.train = predict(deeper, train, type='class')
confusionMatrix(deeper.ct.point.pred.train, train$Personal.Loan)

deeper.ct.point.pred.valid = predict(deeper, valid, type='class')
confusionMatrix(deeper.ct.point.pred.valid, valid$Personal.Loan)
