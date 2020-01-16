# 문서 분류기
# 1) training set으로부터 DTM 만들기
# 2) sparse model matrix란
# 3) data partition 만들기 ( train & test 용 )
# 4) document classification 알고리즘 만들기
# 5) Lasso Regression ( <-> linear regression )
# 6) Cross Validated lasso regression
# AUC

library(tm)
library(Matrix)
library(glmnet)
library(caret)
library(pROC)
library(ggthemes)
library(ggplot2)
library(arm)

headline.clean <- function(x) {
  x <- tolower(x)
  x <- removeWords(x, stopwords('en'))
  x <- removePunctuation(x)
  x <- stripWhitespace(x)
  return(x)
}

install.packages("RTextTools")
library(RTextTools)
trace("create_matrix", edit=T)

match.matrix <- function(text.col, original.matrix=NULL, weighting=weightTf)
                         {
                           control <- list(weighting=weighting)
                           training.col <- sapply(as.vector(text.col, mode='character'),iconv, to='UTF8', sub='byte')
                           corpus <- VCorpus(VectorSource(training.col))
                           matrix <- DocumentTermMatrix(corpus, control=control);
                           if (!is.null(original.matrix)) {
                             terms <- colnames(original.matrix[,
                                                               which(!colnames(original.matrix) %in% colnames(matrix))])
                             weight <- 0
                             if (attr(original.matrix, "weighting")[2] == "tfidf")
                               weight <- 0.000000001
                             amat <- matrix(weight, nrow=nrow(matrix),
                                            ncol=length(terms))
                             colnames(amat) <- terms
                             rownames(amat) <- rownames(matrix)
                             fixed <- as.DocumentTermMatrix(cbind(matrix[,which(colnames(matrix) %in% colnames(original.matrix))],amat),
                                                            weighting=weighting)
                             matrix <- fixed
                           }
                           matrix <- matrix[,sort(colnames(matrix))]
                           gc()
                           return(matrix)
}

# GLMnet Training
library(tibble)
library(stringr)
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
