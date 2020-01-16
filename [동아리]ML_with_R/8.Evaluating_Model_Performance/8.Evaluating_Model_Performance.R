# (to output the predicted probabilities for) the C5.0 classifier
setwd("C:\\Users\\samsung\\Desktop\\Bitamin\\Machine Learning with R\\5장. Decision Tree & Rules")
credit <- read.csv("credit.csv")

train_sample <- sample(1000,900)
credit_train <- credit[train_sample,]
credit_test <- credit[-train_sample,]

library(C50)
credit_model <- C5.0(credit_train[-17], credit_train$default)

predicted_prob <- predict(credit_model, credit_test, type="prob")


# (to output the predicted probabilities for) the naive Bayes predicted probabilities
setwd("C:\\Users\\samsung\\Desktop\\Bitamin\\Machine Learning with R\\4장. Naive Bayes")
sms_raw <- read.csv("sms_spam.csv",stringsAsFactors=FALSE)
sms_raw$type <- factor(sms_raw$type)

library(tm)
sms_corpus <- VCorpus(VectorSource(sms_raw$text))
lapply(sms_corpus[1:2],as.character)
sms_corpus_clean <- tm_map(sms_corpus,content_transformer(tolower))
sms_corpus_clean <- tm_map(sms_corpus_clean,removeNumbers)
sms_corpus_clean <- tm_map(sms_corpus_clean,removeWords,stopwords())
sms_corpus_clean <- tm_map(sms_corpus_clean,removePunctuation)
library(SnowballC)
sms_corpus_clean <- tm_map(sms_corpus_clean,stemDocument)
sms_corpus_clean <- tm_map(sms_corpus_clean,stripWhitespace)
sms_dtm <- DocumentTermMatrix(sms_corpus_clean)

sms_dtm_train <- sms_dtm[1:4169,]
sms_dtm_test <- sms_dtm[4170:5559,]
sms_train_labels <- sms_raw[1:4169,]$type
sms_test_labels <- sms_raw[4170:5559,]$type

sms_freq_words <- findFreqTerms(sms_dtm_train,5)
sms_dtm_freq_train <- sms_dtm_train[,sms_freq_words]
sms_dtm_freq_test <- sms_dtm_test[,sms_freq_words]

convert_counts <- function(x) {x<-ifelse(x>0,"Yes","No")}
sms_train <- apply(sms_dtm_freq_train,MARGIN=2,convert_counts)
sms_test <- apply(sms_dtm_freq_test,MARGIN=2,convert_counts)

library(e1071)
sms_classifier <- naiveBayes(sms_train,sms_train_labels)

sms_test_prob <- predict(sms_classifier,sms_test,type="raw")
head(sms_test_prob)


# sms_results
setwd("C:\\Users\\samsung\\Desktop\\Bitamin\\Machine Learning with R\\10장")
sms_results <- read.csv("sms_results.csv")
head(sms_results)
head(subset(sms_results,prob_spam>0.40 & prob_spam<0.6))
head(subset(sms_results,actual_type!=predict_type))
table(sms_results$actual_type, sms_results$predict_type)

# accuracy & error rate
library(gmodels)
CrossTable(sms_results$actual_type, sms_results$predict_type)

# other measures
library(caret)
confusionMatrix(sms_results$predict_type, sms_results$actual_type, positive="spam")

# kappa (0(bad)~1(good))
pr_a <- 0.865+0.109
pr_a
pr_e <- 0.868*0.888 + 0.132*0.112
pr_e
k <- (pr_a-pr_e) / (1-pr_e)
k

library(vcd)
Kappa(table(sms_results$actual_type, sms_results$predict_type))

# sensitivity & specificity
# sensitivity = (TP/TP+FN) -> 실제O.예측O / 실제O
# specificity = (TN/FN+FP) -> 실제X.예측X / 실제X
sens <- 152/(152+31)
sens
spec <- 1203/(1203+4)
spec

library(caret)
sensitivity(sms_results$predict_type,sms_results$actual_type, positive="spam")
specificity(sms_results$predict_type,sms_results$actual_type, positive="ham")

# precision & recall(=sensitivity)
library(caret)
prec <- posPredValue(sms_results$predict_type, sms_results$actual_type, positive="spam")
rec <- sensitivity(sms_results$predict_type, sms_results$actual_type, positive="spam")

# f-measure
f <-(2*prec*rec) / (prec+rec)
f

# visualize -> ROCR
library(ROCR)
pred <- prediction(predictions=sms_results$prob_spam, labels=sms_results$actual_type)

# ROC curve
perf <- performance(pred, measure="tpr", x.measure="fpr")
plot(perf, main="ROC curve", col="blue",lwd=3)
abline(a=0,b=1,lwd=2,lty=2)
perf.auc <- performance(pred, measure='auc')
str(perf.auc)
unlist(perf.auc@y.values)

# holdout method 
credit <- read.csv("credit.csv")
random_ids <- order(runif(1000))
credit_train <- credit[random_ids[1:500],]
credit_validate <- credit[random_ids[501:750],]
credit_test <- credit[random_ids[751:1000],]

in_train <- createDataPartition(credit$default,p=0.75,list=FALSE)
credit_train <- credit[in_train,]
credit_test <- credit[-in_train,]

# cross-validation
folds <- createFolds(credit$default,k=10)
str(folds)
credit01_test <- credit[folds$Fold01,]
credit01_train <- credit[-folds$Fold01,]

library(caret)
library(C50)
library(irr)
set.seed(123)
folds <- createFolds(credit$default,k=10)
cv_results <- lapply(folds, function(x) {
  credit_train <- credit[-x,]
  credit_test <- credit[x,]
  credit_model <- C5.0(default ~., data=credit_train)
  credit_pred <- predict(credit_model, credit_test)
  credit_actual <- credit_test$default
  kappa <- kappa2(data.frame(credit_actual, credit_pred))$value
  return(kappa)
})
str(cv_results)
mean(unlist(cv_results))

