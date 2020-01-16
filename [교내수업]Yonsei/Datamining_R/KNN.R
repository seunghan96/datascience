setwd('C:\\Users\\samsung\\Desktop\\연세대\\2019.2학기\\경영\\데마')
mow = read.csv('RidingMowers.csv', na.strings='')
head(mow)

# [1] train & test split
set.seed(111)
sam = sample(dim(mow)[1], 0.6*dim(mow)[1])
sam
train = mow[sam,]
valid = mow[-sam,]
dim(train)
dim(valid)

'''
# split into 3
set.seed(2)
sam2 = sample(c(1:3), size=dim(mow)[1], replace=TRUE, prob=c(0.7,0.2,0.3))

train2 = mow[sam2==1,]
valid2 = mow[sam2==2,]
test2 = mow[sam2==3,]
'''

# [2] new data
new = data.frame(Income=60, Lot_Size=20)
new

# [3] visualization ( pch : shape of dot / pos : poisiton )
plot(Lot_Size ~ Income, data=train, pch=ifelse(train$Ownership=='Owner',1,3))
text(train$Income, train$Lot_Size, rownames(train), pos=3)
text(60,20,'X')
legend('topright', c('owner','non-owner','newhousehold'), pch=c(1,3,4))

# [4] Normalize
library(caret)
norm = preProcess(train[,1:2], method=c('center','scale'))
train.norm = train
valid.norm = valid
mow.norm = mow

train.norm[,1:2] = predict(norm, train[,1:2])
valid.norm[,1:2] = predict(norm, valid[,1:2])
new.norm = predict(norm, new)

head(train.norm)
head(new.norm)

# [5] KNN
library(FNN)
nn = knn(train=train.norm[,1:2], test=new.norm, cl=train.norm[,3], k=3)
nn2 = class::knn(train=train.norm[,1:2], test=new.norm, cl=train.norm[,3], k=3)



# [6] 3개의 k 값들은?
attr(nn, 'nn.index')
row.names(train)[attr(nn, 'nn.index')]

# [7] knn의 결과는?
nn2

# Accuracy
acc = data.frame(k=seq(1,14,1), accuracy=rep(0,14))
acc

for (i in 1:14) {
  knn.pred = knn(train=train.norm[,1:2],
                 test=valid.norm[,1:2],
                 cl = train.norm[,3], k=i)
  acc[i,2] = confusionMatrix(knn.pred, valid.norm[,3])$overall[1]
}

acc 

# In-Class
# Q1
text(60,20,'X')
text(80,18,'X')
text(105,17,'X')

# Q2
new2 = data.frame(Income=c(60,80,105), Lot_Size=c(20,18,17))
new2.norm = predict(norm, new2)
head(new2.norm)
nn = knn(train=train.norm[,1:2], test=new2.norm, cl=train.norm[,3], k=3)
nn2 = class::knn(train=train.norm[,1:2], test=new2.norm, cl=train.norm[,3], k=3)
nn2

# Q3
neighbours = matrix(row.names(train)[attr(nn, 'nn.index')],3,3)
neighbours
