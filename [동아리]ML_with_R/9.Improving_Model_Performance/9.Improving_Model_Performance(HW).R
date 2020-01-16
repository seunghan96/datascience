install.packages('mlbench')
library(mlbench)
data(PimaIndiansDiabetes)

# 1-1
str(PimaIndiansDiabetes)

# 1-2
library(caret)
set.seed(123)
m <- train(diabetes ~., data=PimaIndiansDiabetes, method="C5.0")

# 1-3
m
'''
1) input data : 768개 샘플, 8개의 변수로 diabetes 여부(neg/pos) 파악 
2) 25개의 bootstrap sample ( 각 768개씩 )
3) 생성된 모델 후보 12개 ( 그 중 accuracy가 가장 높은 것은 trial 20, model=tree, winnow=False)
'''

# 1-4
ctrl <- trainControl(method='cv', number=10, selectionFunction='oneSE')

# 1-5
grid <- expand.grid(.model='tree', .trials=c(1,5,10,15,20), .winnow=c(TRUE,FALSE))

# 1-6
set.seed(1234)
m <- train(diabetes ~., data=PimaIndiansDiabetes, method='C5.0',
           metric='Kappa', trControl=ctrl, tuneGrid=grid)
m
'''
1),2)는 아까와 같음
3) 생성된 모델 후보 12개 ( 그 중 kappa값이 가장 높은 것은 trial=1, model=tree, winnow=TRUE)
'''

# 1-7.
library(ipred)
set.seed(1234)
ctrl <- trainControl(method='cv', number=10)
train(diabetes~., data=PimaIndiansDiabetes, method="treebag", trControl=ctrl)
# accuracy는 0.755, Kappa값은 0.453

# 1-8.
set.seed(1234)
library(adabag)
adaboost_cv <- boosting.cv(diabetes~.,data=PimaIndiansDiabetes)
library(vcd)
Kappa(adaboost_cv$confusion)
# kappa값은 0.3756이다

####################################################################################3

# 2-1.
'''
(1) C5.0 - tree의 trial
(2) KNN - Knn의 k값
(3) Neuralnet - hidden node의 개수
'''

# 2-2.
# OneSE : 최고 성능의 +- 1 표준편차 
# -> 단순하기 때문에 더 효율적이고, 과적합 가능성을 줄여준다

# 2-3.
# 배깅 vs 부스팅
# 부스팅은 배깅과 다르게, 과거 성능을 기반으로 다른 가중치를 부여한다!

# 2-4.
# 공통점 ) 데이터로부터 샘플을 추출하여,각각의 샘플로 부터 트리를 형성한다 
# 차이점 ) 배깅은 특징을 모두 다 사용하여 모델을 만들지만, 랜덤 포레스트는 특징 중 일부만을 랜덤하게 뽑아서 사용한다
  ( 성능은 랜덤 포레스트가 더 good )

# 2-5.
# OOB :  붓스트랩을 통한 임의 중복추출 시 훈련 데이터 집합에 속하지 않는 데이터

# 2-6.
# 총 특징 수(n)의 제곱근






