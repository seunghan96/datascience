# 엔트로피 지수 (예시)
# 빨간색 60%, 파란색 40%로 이루어진 data
-0.60*log2(0.60) - 0.40*log2(0.40)

# 엔트로피 지수 곡선
curve(-x*log2(x)-(1-x)*log(1-x), col='red',xlab='x',ylab='Entropy',lwd=4)

##############################################################################

# 경로 설정
setwd("C:\\Users\\samsung\\Desktop\\Bitamin\\Machine Learning with R\\5장. Decision Tree & Rules")

##############################################################################

# < Decision Tree >

# 파일 불러오기
credit <- read.csv("credit.csv")

# 구조 & 타깃의 table 확인하기
str(credit)
table(credit$default)

# (1) 데이터 나누기
set.seed(123)
train_sample <- sample(1000,900)
credit_train <- credit[train_sample,]
credit_test <- credit[-train_sample,]

# 비율 점검 (고르게 섞였는지)
prop.table(table(credit_train$default))
prop.table(table(credit_test$default))

# (2) 학습시키기
library(C50)
credit_model <- C5.0(credit_train[-17], credit_train$default)

# 들여다보기
summary(credit_model)

# (3) 평가하기
library(gmodels)
credit_pred <- predict(credit_model, credit_test)
CrossTable(credit_test$default, credit_pred, prop.chisq=FALSE, prop.c=FALSE, prop.r=FALSE, dnn=c('actual default','predicted default'))

# (4) 모델 개선 by 부스팅
credit_boost10 <- C5.0(credit_train[-17], credit_train$default, trials=10)
summary(credit_boost10)

credit_boost_pred10 <- predict(credit_boost10, credit_test)
CrossTable(credit_test$default, credit_boost_pred10, prop.chisq=FALSE, prop.c=FALSE, prop.r=FALSE, dnn=c('actual default','predicted default'))

# (5) cost matrix 작성 1
matrix_dimensions <- list(c('no','yes'),c('no','yes'))
names(matrix_dimensions) <- c('predicted','actual')

error_cost <- matrix(c(0,1,4,0),nrow=2, dimnames=matrix_dimensions)

# (6) cost matrix 작성 2
credit_cost <- C5.0(credit_train[-17],credit_train$default, costs=error_cost)
credit_cost_pred <- predict(credit_cost, credit_test)

CrossTable(credit_test$default, credit_cost_pred, prop.chisq=FALSE, prop.c=FALSE, prop.r=FALSE, dnn=c('actual default','predicted default'))


#############################################################################################################################

# < Rule Learners >

# 파일 불러오기
mushrooms <- read.csv("mushrooms.csv", stringsAsFactors=TRUE)
mushrooms$veil_type <- NULL

# 비율 확인하기
table(mushrooms$type)

# (1) 학습시키기
library(RWeka)
mushroom_1R <- OneR(type~.,data=mushrooms)

# (2) 평가하기
summary(mushroom_1R)

# (3) 개선하기 (RIPPER 사용)
mushroom_JRip <- JRip(type~.,data=mushrooms)
mushroom_JRip
