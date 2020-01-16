# 경로 설정
setwd("C:\\Users\\samsung\\Desktop\\Bitamin\\Machine Learning with R\\3장. kNN")

# 파일 불러오기
# 여성 유방암 관련 data
wbcd <- read.csv("wisc_bc_data.csv", stringsAsFactors=FALSE)

# 파일 구조 check
str(wbcd)

# ID 빼기
wbcd <- wbcd[-1]

# table 확인하기
table(wbcd$diagnosis)

# target 변수를 factor 형식으로
wbcd$diagnosis <- factor(wbcd$diagnosis, levels=c("B","M"), labels=c("Benign","Malignant"))
str(wbcd$diagnosis)

# 비율 확인하기
# ( %로 나타내기 위해 100을 곱함 + 소숫점 1째짜리 까지 )
round(prop.table(table(wbcd$diagnosis))*100, digits=1)

# 더 자세히 들여다보자면...
# 종양의 3가지 특성에 대해 요약 (반지름, 넓이, 굴곡도)
summary(wbcd[c("radius_mean","area_mean","smoothness_mean")])

# 정규화 시킬 함수 생성
normalize <- function(x) { return ((x-min(x)) / (max(x)-min(x))) }

# 정규화 (한번에) 시키기
# ( 모든 값들이 0~1사이로 변형되었을것임! )
str(wbcd)
wbcd_n <- as.data.frame(lapply(wbcd[2:31],normalize))

####################################################################

# Training & Test 데이터로 나누기
wbcd_train <- wbcd_n[1:469,]
wbcd_test <- wbcd_n[470:569,]

# target 변수 불러들어!
wbcd_train_labels <- wbcd[1:469,1]
wbcd_test_labels <- wbcd[470:569,1]

# Model 만들기 (by Training 데이터)
# 'class' library가 knn을 가지고 있음
library(class)
wbcd_test_pred <- knn(train=wbcd_train, test=wbcd_test, cl=wbcd_train_labels, k=21)

# Model 평가하기 (by Test 데이터)
library(gmodels)
CrossTable(x=wbcd_test_labels, y=wbcd_test_pred, prop.chisq=FALSE)

####################################################################

# Model 개선하기 ( normalize함수 말고, scale함수 써서(z-score) )
wbcd_z <- as.data.frame(scale(wbcd[-1]))

wbcd_train <- wbcd_z[1:469,]
wbcd_test <- wbcd_z[470:569,]
wbcd_train_labels <- wbcd[1:469,1]
wbcd_test_labels <- wbcd[470:569,1]

wbcd_test_pred <- knn(train=wbcd_train, test=wbcd_test, cl=wbcd_train_labels, k=21)

CrossTable(x=wbcd_test_labels, y=wbcd_test_pred, prop.chisq=FALSE)
