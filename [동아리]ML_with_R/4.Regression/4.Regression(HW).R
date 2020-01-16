setwd("C:\\Users\\samsung\\Desktop\\Bitamin\\Machine Learning with R\\6장")

# 1
car <- read.csv("car_accident.csv")

# 2
car <- car[-2,-9,-11]
names(car) <- c('date','day_night','day','cnt_dead','cnt_serious','cnt_slight','province','acc_type','law_type','road_type','party1','party2')


# 3
seoul <- subset(car,car$province=="서울")

# 4
library(stringr)
library(dplyr)

date <- as.character(seoul$date)

weather <- function(x) {
  if(x %in% c("03","04","05")) {
    W <- "spring"
  } else if (x %in% c("06","07","08")) {
    W <- "summer"
  } else if (x %in% c("09","10","11")) {
    W <- "autumn"
  } else {
    W <- "winter"
  }
  W
}

seoul <- mutate(seoul,month=(weather(str_sub(date,5,6))))

# 5
seoul <- mutate(seoul,weekend=(seoul$day==c("토","일")))

# 6
aa <- table(droplevels(seoul)$acc_type)
bb <- table(droplevels(seoul)$law_type)
cc <- table(droplevels(seoul)$road_type)
dd <- table(droplevels(seoul)$party1)
ee <- table(droplevels(seoul)$party2)

# 7
library(rpart)
ashop <- read.csv("ashopping.csv")
str(ashop)

a <- sample(nrow(ashop),nrow(ashop)*0.7)
train <- ashop[a,]
test <- ashop[-a,]

m.rpart <- rpart(서비스.만족도~.,data=train)      
m.rpart

# 8.
library(DMwR)
library(RWeka)
printcp(m.rpart)  # 7에서 8가면 에러 증가하니 7에서 컷!
Rt.shop <- rpartXse(서비스.만족도~.,data=train)
Rt.shop

# 9.
cv.rpart <- function(form,train,test,...) {
  m <- rpartXse(form,train,...)
  p <- predict(m,test)
  mse <- mean((p-resp(form,test))^2)
  c(rmse=mse/mean((mean(resp(form,train))-resp(form,test))^2))
}

cv.lm <- function(form,train,test,...) {
  m <- lm(form,train,...)
 p <- predict(m,test)
  p <- ifelse(p<0,0,p)
  mse <- mean((p-resp(form,test))^2)
  c(nmse=mse/mean((mean(resp(form,train))-resp(form,test))^2))
}

res <- experimentalComparison(
  c(dataset(서비스.만족도~.,train,'서비스.만족도')),
  c(variants('cv.lm'),
    variants('cv.rpart',se=c(0,0.5,1))),
  cvSettings(4,10,1234))