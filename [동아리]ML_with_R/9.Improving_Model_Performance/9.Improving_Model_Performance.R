# 모델별 parameter 확인
library(caret)
modelLookup("C5.0") # C5.0 ( 분류 나무 )

# simple tuned model
set.seed(300)
credit <- read.csv("C:\\Users\\samsung\\Desktop\\Bitamin\\Machine Learning with R\\5장\\credit.csv")
m <- train(default ~., data=credit, method="C5.0") # train 통해, tuning parameter 이용해 model 만듬
str(m) # 시간 좀 걸림....
p <- predict(m,data=credit)
table(p,credit$default) # (예측,실제)

# customizing tuning process
# ( default값을 바꿀 수 있음 -> 특정 상황에 더 적합하게끔 )
ctrl <- trainControl(method="cv", number=10, selectionFunction="oneSE") # 10-cross validation
grid <- expand.grid(.model="tree", .trials=c(1,5,10,15,20,25,30,35), .winnow="FALSE") # C5.0의 parameter 지정

set.seed(300)
m <- train(default~., data=credit, method="C5.0",
           metric='Kappa',
           trControl=ctrl, # 지정해준것 적용 (1)
           tuneGrid=grid)  # 지정해준것 적용 (2)
m # 1~35의 trial 중, Kappa값이 제일 높 ㄱ것 골라줌

# 앙상블 모형 (meta-learning)
# 배깅 (훈련 데이터를 부트스트랩 샘플링해 훈련 데이터의 개수를 생성한다)
library(ipred) # improved predictive model
library(adabag)
set.seed(300)
mybag <- bagging(default~., data=credit, nbagg=25) 
credit_pred <- predict(mybag, data=credit)
table(credit_pred, credit$default)

library(caret) #10 cv-fold 적용해보기
set.seed(300)
ctrl <- trainControl(method="cv",number=10)
train(default~., data=credit, method='treebag', trControl=ctrl)

str(svmBag)
svmBag$fit
bagctrl <- bagControl(fit=svmBag$fit,
                      predict=svmBag$pred,
                      aggregate=svmBag$aggregate)
set.seed(300)
svmbag <- train(default~., data=credit,"bag", 
                trControl=ctrl, bagControl=bagctrl)
svmbag

# 부스팅
set.seed(300)
m_adaboost <- boosting(default~., data=credit)
p_adaboost <- predict(m_adaboost, data=credit)
p_adaboost$confusion

set.seed(300)
adaboost_cv <- boosting.csv(default~., data=credit)credit
adaboost_cv$confusion

library(vcd)
Kappa(adaboost_cv$confusion)

# 랜덤포레스트
library(randomForest)
set.seed(300)
rf <- randomForest(default~., data=credit)
rf

# 랜덤포레스트 evaluating
library(caret)
ctrl <- traincontrol(method="repeatedcv", number=10, repeats=10)

grid_rf <- expand.grid(.mtry=c(2,4,8,16))
set.seed(300)
m_rf <- train(default~., data=credit, method='rf', 
              metric='kappa', trControl=ctrl, tuneGrid=grid_rf)


grid_c50 <- expand.grid(.model='tree',
                        .trials=c(10,20,30,40),
                        .winnow="FALSE")
set.seed(300)
m_c50 <- train(default~., data=credit, method='C5.0',
               metric='Kappa', trControl=ctrl, tuneGrid=grid_c50)

m_rf
m_c50 