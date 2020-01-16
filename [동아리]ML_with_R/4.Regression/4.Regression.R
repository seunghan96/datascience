# 경로설정
setwd("C:\\Users\\samsung\\Desktop\\Bitamin\\Machine Learning with R\\6장. Regression")

# 파일 불러오기
launch <- read.csv("challenger.csv")

# 계수 & 절편(오차)
b <- cov(launch$temperature, launch$distress_ct) / var(launch$temperature)
a <- mean(launch$distress_ct) - b*mean(launch$temperature)

# 피어슨 상관계수
r <- cov(launch$temperature,launch$distress_ct) / (sd(launch$temperature)*sd(launch$distress_ct))
cor(launch$temperature, launch$distress_ct)

#######################################################################

# 다중 선형회귀
reg <- function(y,x) {
  x <- as.matrix(x)
  x <- cbind(Intercept=1, x)
  b <- solve(t(x)%*%x)%*%t(x)%*%y
  colnames(b) <- 'estimate'
  print(b)
}

# 구조 확인
str(launch)

# 분석하기
reg(y=launch$distress_ct,x=launch[2])
reg(y=launch$distress_ct,x=launch[2:4])

#####################################################################33

# 파일 불러오기
insurance <- read.csv("insurance.csv",stringsAsFactors=TRUE)

# 구조 확인
str(insurance)

# summary & histogram
summary(insurance$charges)
hist(insurance$charges)

# 비율 확인 (지역별)
table(insurance$region)

# 상관행렬
cor(insurance[c("age","bmi","children","charges")])

# 산점도행렬
pairs(insurance[c('age','bmi','children','charges')])

library(psych)
pairs.panels(insurance[c('age','bmi','children','charges')])

# 학습하기
ins_model <- lm(charges~.,data=insurance)
ins_model

# 평가하기
summary(ins_model)

###############################################################

# 개선하기 ( 비선형, 새로운 항, 이진데이터, 상호작용 .... )
insurance$age2 <- insurance$age^2
insurance$bmi30 <- ifelse(insurance$bmi>=30, 1, 0)

ins_model2 <- lm(charges~age+age2+children+bmi+sex+bmi30*smoker+region, data=insurance)
summary(ins_model2)

##########################################################################

# 회귀나무 & 모델나무

# 데이터 불러오기
wine <- read.csv("whitewines.csv")

# 구조 확인
str(wine)

# histogram
hist(wine$quality)

# 경로설정
setwd("C:\\Users\\samsung\\Desktop\\Bitamin\\Machine Learning with R\\6장. Regression")

# 데이터 나누기
wine_train <- wine[1:3750,]
wine_test <- wine[3751:4898,]

# 학습하기
library(rpart)
m.rpart <- rpart(quality~.,data=wine_train)
m.rpart

# 시각화
library(rpart.plot)
rpart.plot(m.rpart,digits=3)
rpart.plot(m.rpart,digits=4,fallen.leaves=TRUE,type=3,extra=101)

# 평가하기
p.rpart <- predict(m.rpart,wine_test)
cor(p.rpart, wine_test$quality)

# Mean Absolute Error (MAE)
MAE <- function(actual,predicted) {
  mean(abs(actual-predicted))
}
MAE(p.rpart,wine_test$quality)

mean(wine_train$quality)
MAE(5.88,wine_test$quality)

# 개선하기
library(RWeka)
m.m5p <- M5P(quality~.,data=wine_train)
summary(m.m5p)

p.m5p <- predict(m.m5p,wine_test)
summary(p.m5p)

cor(p.m5p,wine_test$quality)
MAE(wine_test$quality,p.m5p)
