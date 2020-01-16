#######################
## Homework 2
## 2015123127 ÀÌ½ÂÇÑ
#######################

#####################
##### 1-(a) VIF #####
#####################

# 1. importing libraries
library(mvtnorm)
library(car)

# 2. making dataset
N=150
P=50
X=matrix(NA,nrow=N,ncol=P)
covmat=matrix(rnorm(P^2,sd=2),nrow=P) #50x50
covmat=covmat+t(covmat) # to make a diagonal matrix
U=eigen(covmat)$vectors
D=diag(rexp(P,rate=10)) 
covmat=U%*%D%*%t(U)

for(i in 1:N){
  X[i,]=rmvnorm(1,mean=rep(0,P),sigma=covmat)
}
X=data.frame(X)
dim(X)
betas.true=c(1,2,3,4,5,-1,-2,-3,-4,-5,rep(0,P-10))
sigma=15.7
X=as.matrix(X)
y=X%*%betas.true+rnorm(N,mean=0,sd=sigma)


# 3. train & test split
alldata=data.frame(cbind(y,X))
names(alldata)[1] <- "y"
head(alldata)
train=alldata[1:100,]
test=alldata[101:150,]

# 4. fitting 
fit=lm(y~.,data=train)

# 5. Results ( betas, yhat, mspe )
betas.lm=coef(fit)
yhat.lm=predict(fit,newdata=test)
mspe.lm=mean((test$y-yhat.lm)^2)

# 6. VIF
# We can say that there is a multicolinearity problem, since VIF values are quite big! ( usually 5(10) or above )
# It is because we made the model with the dataset which are highly related
vif(fit)


###################### 
##### 1-(b) Ridge ####
######################
## alpha=0 

# 1. import libraries
library(glmnet)

# 2. fitting RIDGE ( alpha = 0 )
ridge=glmnet(x=as.matrix(train[,-1]),y=as.numeric(train[,1]),alpha=0,nlambda=100)
# how coef changes by 'lambda value'
plot(ridge,xvar="lambda",main="Ridge Regression Betas for Different Values of the Tuning Parameter")

# 3. 10-fold CV
cv.ridge=cv.glmnet(x=as.matrix(train[,-1]),y=as.numeric(train[,1]),alpha=0,nfolds=10,nlambda=100)

#4. the LEAST cv_mspe  
cvmspe.ridge=min(cv.ridge$cvm)
cvmspe.ridge

#5. the best lambda value 
lambda.ridge=cv.ridge$lambda.min
lambda.ridge

#6. coefficients of Ridge Regression
betas.ridge=coef(cv.ridge,s="lambda.min")
# we can see huge difference ( coef of LM >> coef of RIDGE )
betas.ridge # beta of RIDGE
betas.lm # beta of LM

# 7. LM's beta vs RIDGE's beta
par(mfrow=c(1,2))
plot(betas.ridge,betas.lm,xlim=c(-6,6),ylim=c(-6,6))
plot(betas.lm,betas.lm,xlim=c(-6,6),ylim=c(-6,6))



###################### 
##### 1-(c) LASSO ####
######################
## alpha=1 

# 1. import libraries
library(glmnet)

# 2. fitting lasso ( alpha = 1 )
lasso=glmnet(x=as.matrix(train[,-1]),y=as.numeric(train[,1]),alpha=1,nlambda=100)
plot(lasso,xvar="lambda",main="Lasso Regression Betas for Different Values of the Tuning Parameter")

# 3. 10-fold CV
cv.lasso=cv.glmnet(x=as.matrix(train[,-1]),y=as.numeric(train[,1]),alpha=1,nfolds=10,nlambda=100)

#4. the LEAST cvmspe  
cvmspe.lasso=min(cv.lasso$cvm)
cvmspe.lasso

#5. the best lambda value 
lambda.lasso=cv.lasso$lambda.min
lambda.lasso

#6. coefficients of Lasso Regression
betas.lasso=coef(cv.lasso,s="lambda.min")
betas.lasso # beta of LASSO
betas.lm # beta of LM

# 7. LM's beta vs LASSO's beta
par(mfrow=c(1,2))
plot(betas.lasso,betas.lm,xlim=c(-6,6),ylim=c(-6,6))
plot(betas.lm,betas.lm,xlim=c(-6,6),ylim=c(-6,6))


################################
##### 1-(d) MSPE comparison ####
################################
yhat.lm=predict(fit,newdata=test)
yhat.ridge=predict(cv.ridge,s="lambda.min",newx=as.matrix(test[,-1]))
yhat.lasso=predict(cv.lasso,s="lambda.min",newx=as.matrix(test[,-1]))

mspe.lm=mean((test$y-yhat.lm)^2)
mspe.ridge=mean((test$y-yhat.ridge)^2)
mspe.lasso=mean((test$y-yhat.lasso)^2)

mspe.lm
mspe.ridge
mspe.lasso


################################################################
##### 1-(e) Correlated vs UnCorrelated Case in Lasso ###########
###############################################################

# In contrast to Ridge, Lasso can make the coefficient of variables into zero.
# So, in the case of highly correlated variables, only one variable would be selected and the other variables can become zero.
# But in the case of uncorrelated variables, less variable will become zero compared to the highly correlated cases.
# That is Lasso is used as a method of reducing the number of features. But reduction of feature also means the loss of data, so there is a method called ElasticNet, which is a combination of Ridge and Lasso.


############################################################
###### 2. Question 2 on word fild #########################
############################################################




###################################################################################################################

######################################
##### 3. SOM with wine dataset #######
######################################

library("kohonen")
data("wines")
str(wines)
head(wines)
dim(wines)

# train(150) test(27) split
training = sample(nrow(wines), 150)
Xtraining = scale(wines[training, ])
Xtest = scale(wines[-training, ],
              center = attr(Xtraining, "scaled:center"),
              scale = attr(Xtraining, "scaled:scale"))
trainingdata = list(measurements = Xtraining, vintages = vintages[training])
testdata = list(measurements = Xtest, vintages = vintages[-training])

# 2 X 2
# Conclusion : Since there is not much cluster, the error doesn't seems to get much smaller 
set.seed(1)
som.wines = som(scale(wines), grid = somgrid(2, 2, "hexagonal"))
par(mfrow = c(1, 2))
plot(som.wines, main = "Wine data Kohonen SOM")
plot(som.wines, type = "changes", main = "Wine data: SOM")

mygrid = somgrid(2, 2, "hexagonal")
som.wines = supersom(trainingdata, grid = mygrid)
som.prediction = predict(som.wines, newdata = testdata)
som.prediction2 = predict(som.wines, newdata = trainingdata)
table(vintages[-training], som.prediction$predictions[["vintages"]])
table(vintages[training], som.prediction2$predictions[['vintages']])

# 4 X 4
set.seed(1)
som.wines = som(scale(wines), grid = somgrid(4, 4, "hexagonal"))
par(mfrow = c(1, 2))
plot(som.wines, main = "Wine data Kohonen SOM")
plot(som.wines, type = "changes", main = "Wine data: SOM")

mygrid = somgrid(4, 4, "hexagonal")
som.wines = supersom(trainingdata, grid = mygrid)
som.prediction = predict(som.wines, newdata = testdata)
som.prediction2 = predict(som.wines, newdata = trainingdata)
table(vintages[-training], som.prediction$predictions[["vintages"]])
table(vintages[training], som.prediction2$predictions[['vintages']])

# 10 X 10
set.seed(1)
som.wines = som(scale(wines), grid = somgrid(10, 10, "hexagonal"))
par(mfrow = c(1, 2))
plot(som.wines, main = "Wine data Kohonen SOM")
plot(som.wines, type = "changes", main = "Wine data: SOM")

mygrid = somgrid(10, 10, "hexagonal")
som.wines = supersom(trainingdata, grid = mygrid)
som.prediction = predict(som.wines, newdata = testdata)
som.prediction2 = predict(som.wines, newdata = trainingdata)
table(vintages[-training], som.prediction$predictions[["vintages"]])
table(vintages[training], som.prediction2$predictions[['vintages']])



# 2 X 2 : Since there is not much cluster, the error doesn't seems to get much smaller . Also, the model seems to be so simple
# 4 x 4 : There are more cluster in this case than the previous case. There is a point where the loss reduces with a large amount
# 10 X 10 : This should have the lowest loss, compared with the previous two cases. But in the aspect of intepretation of the model, it is too compicated. There are 100 clusters in total!
# We have to think both, the accuracy(lowering the loss) and interpretation(not making too much clusters)
# So I think the one with 4*4 nodes is the best!


# We can not make 14*14 grids, since there is only 177 datasets, and it does not make sense to make 196 clusters with 177 data!
# The number of cluster should be less than the number of datasets.


######################################################################












