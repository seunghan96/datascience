# ANN (Artificial Neural Network)

# 파일 불러오기
setwd("C:\\Users\\samsung\\Desktop\\Bitamin\\Machine Learning with R\\7장. Neural Network & SVM")
concrete <- read.csv("concrete.csv")
str(concrete)

# 정규화하기
normalize <- function(x) {return((x-min(x))/(max(x)-min(x)))}
concrete_norm <- as.data.frame(lapply(concrete,normalize))

# 정규화 O <-> 정규화 X (비교해보기)
summary(concrete_norm$strength)
summary(concrete$strength)

# 데이터 나누기
concrete_train <- concrete_norm[1:773,]
concrete_test <- concrete_norm[774:1030,]

# 훈련시키기 (by neuralnet 함수)
library(neuralnet)
concrete_model <- neuralnet(strength~cement+slag+ash+water+superplastic+coarseagg+fineagg+age, data=concrete_train)
plot(concrete_model)

# 평가하기 (by compute 함수)
model_results <- compute(concrete_model, concrete_test[1:8])   # 모델과 독립변수(8개)를 인자로 compute
predicted_strength <- model_results$net.result  #net.result 이용하기
cor(predicted_strength, concrete_test$strength)   # 예측 & 실제의 상관관계 분석

# 개선하기 ( node를 5개로 -> hidden = n )
concrete_model2 <- neuralnet(strength~cement+slag+ash+water+superplastic+coarseagg+fineagg+age, data=concrete_train, hidden=5)
plot(concrete_model2)
model_results2 <-compute(concrete_model2, concrete_test[1:8])
predicted_strength2 <- model_results2$net.result
cor(predicted_strength2,concrete_test$strength)

##############################################################################

# SVM
letters <- read.csv("lettersdata.csv")
str(letters)

letters_train <- letters[1:13000,]
letters_test <- letters[13001:20000,]

library(kernlab)
letter_classifier <- ksvm(letter~., data=letters_train, kernel="vanilladot")
letter_classifier

letter_predictions <- predict(letter_classifier, letters_test)  
head(letter_predictions)

table(letter_predictions, letters_test$letter)

agreement <- letter_predictions == letters_test$letter
table(agreement)
prop.table(table(agreement))

# SVM 개선시키기 ( 다른 종류의 kernel function )
letter_classifier_rbf <- ksvm(letter~.,data=letters_train, kernel="rbfdot")

letter_predictions_rbf <- predict(letter_classifier_rbf, letters_test)
agreement_rbf <- letter_predictions_rbf==letters_test$letter

table(agreement_rbf)
prop.table(table(agreement_rbf))
