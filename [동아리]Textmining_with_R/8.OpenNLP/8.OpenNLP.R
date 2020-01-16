#### 8장 ######
# 필요한 packages & library

install.packages("openNLP")
install.packages("openNLPmodels.en", repos="http://datacube.wu.ac/", type='source')

options(stringsAsFactors=FALSE)
Sys.setlocale('LC_ALL','C')

library(gridExtra)
library(ggmap)
library(ggthemes)
library(NLP)
library(openNLP)
library("openNLPmodels.en", lib.loc="~/R/win-library/3.2")
library(pbapply)
library(stringr)
library(rvest)
library(doBy)
library(tm)
library(cshapes)

temp <- list.files(pattern='*.txt')
for (i in 1:length(temp)) assign(tmp[i], readLines(temp[i]))
all.emails <- pblapply(temp,get)

# 8-3-2.Minor Text Cleaining
txt.clean <- function(x) { x <- x[-1]
x <- paste(x,collapse= " ")
x <- str_replace_all(x, "")}

# entity model 설명
# date
# location
# money
# organization
# percentage
# person


raw.headlines<-readLines('https://raw.githubusercontent.com/kwartler/text_mining/master/all_3k_headlines.csv',
                         encoding='latin1')[-1]
text<-str_split(raw.headlines, 'http{1}', simplify=TRUE)[,1]
url_site_y<-paste('http',str_split(raw.headlines, 'http{1}', simplify=TRUE)[,2],sep='')
url_site_y<-str_split(url_site_y,',',simplify=TRUE)
url<-url_site_y[,1]
site<-url_site_y[,2]
y<-url_site_y[,3]
headlines<-tibble(
  headline=text,
  url=url,
  site=site,
  y=y
)

train <- createDataPartition(headlines$y, p=0.5, list=F)
train.headlines <- headlines[train,]
test.headlines <- headlines[-train,]

clean.train <- headline.clean(train.headlines$headline)

train.dtm <- match.matrix(clean.train, weighting=tm::weightTfIdf)

train.matrix <- as.matrix(train.dtm)
train.matrix <- Matrix(train.matrix, sparse=T)                          

dim(train.matrix)
train.matrix[1:5,1:25]

cv <- cv.glmnet(train.matrix,
                y=as.factor(train.headlines$y), alpha=1,
                family='binomial', nfolds=10, intercept=F,
                type.measure='class')
plot(cv)

preds <- predict(cv,train.matrix, type='class', s=cv$lambda.lse)

train.auc <- roc(train.headlines$y, as.numeric(preds))
train.auc
plot(train.auc)

confusion <- table(preds, train.headlines$y)
sum(diag(confusion))/sum(confusion)

clean.test <- headline.clean(test.headlines$headline)
test.dtm <- match.matrix(clean.test, weighting = tm::weightTfIdf, original.matrix=train.dtm)

test.matrix <- as.matrix(test.dtm)
test.matrix <- Matrix(test.matrix)

preds <- predict(cv, test.matrix, type='class', s=cv$lambda.min)
headline.preds <- data.frame(doc_row = rownames(test.headlines), class=preds[,1])

test.auc <- roc(test.headlines$y, as.numeric(preds))
test.auc
