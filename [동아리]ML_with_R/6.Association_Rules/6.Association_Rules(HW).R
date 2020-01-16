library(arules)

data(Epub)
itemFrequency(Epub)[10]

freq.book <- itemFrequency(Epub)
freq.book[which(freq.book==max(freq.book))]
# doc_11d책이 가장 많은 대출 수를 기록하고 있다 (0.226)

itemFrequencyPlot(Epub,support=0.01)

itemFrequencyPlot(Epub,topN=30)

image(sample(Epub,500))

rule <- apriori(Epub,parameter=list(support=0.001,confidence=0.2,minlen=2))

sort.rule <- sort(rule,by="lift")
inspect(sort.rule[1])
#doc_6e7,6e8책을 빌린 사람은, doc_6e9책까지 빌렸을 가능성이 높다 (80.9%)

doc.rule1 <- subset(rule, items %in% c("doc_6e7","doc_6e8","doc_6e9"))

doc.rule2 <- subset(rule, lhs %in% "doc_87c")

doc.rule3 <- subset(rule, items %pin% "60e", confidence=0.25)

plot(sort.rule[1:20], method="grouped")

plot(sort.rule,method="graph", control=list(type="itemsets"))

write(sort.rule,file="bitamin.csv",sep=",",quote=TRUE,row.names=FALSE)
##################################

data(Titanic)
titan.df <- as.data.frame(Titanic)
head(titan.df)
str(titan.df)
titanic <- NULL
for(i in 1:4){
  titanic <- cbind(titanic,
                   rep(as.character(titan.df[,i]), titan.df$Freq))
}

titanic <- as.data.frame(titanic)
names(titanic) <- names(titan.df)[1:4]
str(titanic)

####################################3
titanic <- as(titanic,"transactions")
tit.rule <- apriori(titanic)

tit.liftrule <- sort(tit.rule,by="lift")
inspect(tit.rule3[1:3])

new.rule <- apriori(titanic, parameter=list(support=0.005,confidence=0.8,minlen=2), appearance = list(rhs = c("Survived=No", "Survived=Yes"), default = "lhs"))

new.liftrule <-sort(new.rule,by="lift")
inspect(new.liftrule[1:3])

### 해석 : 
#2등석+아이인 경우, 24명 전원 생존했다 (24명 중 100%인 24명 생존)
#2등석+여성+아이의 경우, 24명 전원 생존했다 (13명 중 100%인 13명 생존)
#1등석+여성의 경우, 141명이 생존했다 (150명 중 97.24%인 141명이 생존)

subset.matrix <- is.subset(new.liftrule,
                           new.liftrule)
subset.matrix2 <- as.matrix(subset.matrix)
subset.matrix2[lower.tri(subset.matrix2,diag=T)]<-NA
redundant <- colSums(subset.matrix2,na.rm=T) >= 1
new.rule.pruned <- new.liftrule[!redundant]
inspect(new.rule.pruned)

library(arulesViz)

plot(new.rule.pruned,shading="order")

plot(new.rule.pruned,method="grouped")
# 원이 빨간색수록 lift가 높고, 클수록 support가 크다.
# 왼쪽 위의 원 : 
# 1)작다 -> 24명 밖에 안되는 (support가 0.01로 작은) 인원
# 2)빨강 -> lift가 3.09로 제일 크다 
# survived=Yes에 정확히 위치한 것으로 보아 24명 중 대부분 (전부 다)가 생존한 것을 알 수 있다
# (2등석에 앉은 child는 전부 생존!)

plot(new.rule.pruned,method="graph", control=list(type="itemsets"))

plot(new.rule.pruned,method="paracoord")

plot(new.rule.pruned,interactive=T)

plot(new.rule.pruned,method="matrix",measure="lift")
