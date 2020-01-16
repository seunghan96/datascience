###############################
###### Basic Statistics #######
###############################

# set working directory & import files
setwd('C:\\Users\\samsung\\Desktop\\연세대\\2019.2학기\\통계\\딥러닝\\과제')
stock <- read.csv('stock.csv')
head(stock)
str(stock)

# import libraries
library(dplyr)
library(fastDummies)

# 1-(a) make dummy variables
stock$Month = as.factor(stock$Month)
stock$Year = as.factor(stock$Year)
stock = stock[order(stock$Month),] 
dum = dummy_cols(stock$Month,remove_first_dummy = TRUE)[-c(1)]
dim(dum)

# 1-(b) add intercept + dummy variables
X = cbind(1,stock$Interest, stock$Unemployment, dum) 
X = as.matrix(X)
dim(X)
head(X)

# 1-(c)
y = stock$Stock 
# beta hat
beta.hat = solve(t(X)%*%X)%*%t(X)%*%y 
# standard error
sigmasq.hat = as.numeric( t(y-X%*%beta.hat)%*%(y-X%*%beta.hat)/(24-14) ) # 14 : 1 intercept + 13 independent variables
stderr = sqrt(diag(solve(t(X)%*%X))*sigmasq.hat) # standard error of reg

# 1-(d)
attach(stock)
stock2 <- cbind(Interest, Unemployment, dum, Stock)
model <- lm(Stock ~., stock2)
summary(model) # it has the same value as the above questions!
beta.hat


######################
###### Poisson #######
######################

# import files
admissions = read.csv("https://stats.idre.ucla.edu/stat/data/binary.csv")
head(admissions)
dim(admissions)
table(admissions$admit)
table(admissions[admissions$gpa<=3,]$admit)
table(admissions[(admissions$gpa>3)&(admissions$gpa<4),]$admit)
table(admissions[admissions$gpa==4,]$admit)

# 2-(a)
# (x : gpa) (y: admit)
fit=glm(admit~gpa,family=binomial,data=admissions) #Logistic Regression Model ( family='binomial')
fit

# 2-(b)
## get estimated linear predictor
xvals=seq(2,4) # new x values
newdf=data.frame(gpa=xvals) 
eta=predict(fit,newdata=newdf,type="link") # prediction ( = X*B)
eta

# 2-(c)
## get estimated mean (=probability of getting admitted)
mu=predict(fit,newdata=newdf,type="response") 
mu

# 2-(d)
par(mfrow=c(1,2))
# ( Plot of Estimated Linear Predictor )
plot(xvals,eta,main="Linear Predictor",xlab="gre",ylab=expression(eta),type="l")# (d)
# ( Plot of Estimated Mean )
plot(xvals,mu,main="Mean Response as a Function of the Predictor",xlab="gpa",ylab=expression(mu),ylim=c(0,1),type="l",lwd=2) 
points(jitter(admissions$gpa),admissions$admit)
