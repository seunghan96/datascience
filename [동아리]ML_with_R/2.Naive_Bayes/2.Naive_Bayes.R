# 텍스트 마이닝 할 때!!!!!!!!!!
# 뭔진 몰라도 그냥 해 ㅎㅎㅎ
Sys.setlocale(category='LC_ALL')
options(stringsAsFactors=F)

  
# 경로 설정 후 파일불러오기
setwd("C:\\Users\\samsung\\Desktop\\Bitamin\\Machine Learning with R\\4장. Naive Bayes")
sms_raw <- read.csv("sms_spam.csv",stringsAsFactors=FALSE)

# 구조확인
str(sms_raw)

# vector -> factor
sms_raw$type <- factor(sms_raw$type)

# 빈도 확인하기
# ( ham : spam 빈도수 )
table(sms_raw$type)

# Corpus 생성하기
library(tm)
sms_corpus <- VCorpus(VectorSource(sms_raw$text))

# 특정 message 자세히보기
sms_raw$text[1]
inspect(sms_corpus[1:2])

# 실제 message로 풀어서보기
lapply(sms_corpus[1:2], as.character)

# all 소문자로
sms_corpus_clean <- tm_map(sms_corpus, content_transformer(tolower))

# 숫자 없애기
sms_corpus_clean <- tm_map(sms_corpus_clean, removeNumbers)

# 쓸데없는 단어 없애기
sms_corpus_clean <- tm_map(sms_corpus_clean, removeWords, stopwords())

# punctuation 없애기
sms_corpus_clean <- tm_map(sms_corpus_clean, removePunctuation)

# wordstem (어근)
library(SnowballC)
sms_corpus_clean <- tm_map(sms_corpus_clean, stemDocument)

# stripWhitespace()
sms_corpus_clean <- tm_map(sms_corpus_clean, stripWhitespace)

# DTM (Document Term Matrix)
sms_dtm <- DocumentTermMatrix(sms_corpus_clean)

##########################################################

# 데이터셋 나누기
sms_dtm_train <- sms_dtm[1:4169,]
sms_dtm_test <- sms_dtm[4170:5559,]

sms_train_labels <- sms_raw[1:4169,]$type
sms_test_labels <- sms_raw[4170:5559,]$type

# train/test 데이터에 속한 ham & spam 비율
prop.table(table(sms_train_labels))
prop.table(table(sms_test_labels))

# Wordcloud 만들기
# ( 최소 50번 이상 등장한 단어들 )
library(wordcloud)
wordcloud(sms_corpus_clean, min.freq=50, random.order=FALSE)

spam <- subset(sms_raw, type=="spam")
ham <- subset(sms_raw, type=="ham")

wordcloud(spam$text, max.words=40,scale=c(3,0.5))
wordcloud(ham$text, max.words=40,scale=c(3,0.5))

#########################################################

# 자주나오는 단어들 ( top 5 )
sms_freq_words <- findFreqTerms(sms_dtm_train, 5)
sms_dtm_freq_train <- sms_dtm_train[,sms_freq_words]
sms_dtm_freq_test <- sms_dtm_test[,sms_freq_words]

# 수치형 -> 카테고리형
convert_counts <- function(x) {x<-ifelse(x>0,"Yes","No")}

# 적용
sms_train <- apply(sms_dtm_freq_train, MARGIN=2, convert_counts)
sms_test <- apply(sms_dtm_freq_test, MARGIN=2, convert_counts)

# 모델 생성
# e1071 library는 naiveBayes 위해서
library(e1071)
sms_classifier <- naiveBayes(sms_train, sms_train_labels)

# 예측하기
sms_test_pred <- predict(sms_classifier, sms_test)

# CrossTable 만들기
library(gmodels)
CrossTable(sms_test_pred,sms_test_labels, prop.chisq=FALSE, prop.t=FALSE, dnn=c("predicted","actual"))

#########################################################################

# 모델 개선하기 (Laplace 사용)
sms_classifier2 <- naiveBayes(sms_train,sms_train_labels,laplace=1)
sms_test_pred2 <- predict(sms_classifier2,sms_test)
CrossTable(sms_test_pred2,sms_test_labels, prop.chisq=FALSE, prop.t=FALSE, prop.r=FALSE, dnn=c("predicted","actual"))


