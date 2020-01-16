setwd("C:\\Users\\samsung\\Desktop\\Bitamin\\Machine Learning with R\\8장. Association Rules (장바구니 분석)")

# 파일 불러오고 요약하기
library(arules)
groceries <- read.transactions("groceries.csv",sep=",")
summary(groceries)

# 자세히 들여다보기
inspect(groceries[1:5])

# 빈도수 확인 (알파벳 순)
itemFrequency(groceries[,1:3])

# 빈도수 그래프
itemFrequencyPlot(groceries,support=0.1)
itemFrequencyPlot(groceries,topN=20)

# transaction data 시각화
image(groceries[1:5])
image(sample(groceries,100))

# 훈련하기
apriori(groceries)  #기본값 (support=0.1 / confidence=0.8)
groceryrules <- apriori(groceries, parameter=list(support=0.006, confidence=0.25, minlen=2))
groceryrules

# 평가하기
summary(groceryrules)

# 자세히 들여다보기
inspect(groceryrules[1:3])

# 모델 개선하기 1 (sort 통해 -> lift 높은 순대로 5개)
inspect(sort(groceryrules,by="lift")[1:5])

# 모델 개선하기 2 (subset 통해 -> 원하는 품목 고르기)
berryrules <- subset(groceryrules, items %in% "berries")
inspect(berryrules)

# 파일 저장하기
write(groceryrules,file='groceryrules.csv',sep=",",quote=TRUE, row.names=FALSE) #csv형태로
groceryrules_df <- as(groceryrules,"data.frame")#df형태로 만들기
str(groceryrules_df)
