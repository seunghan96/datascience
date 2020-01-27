# Time Series Regression
## Time Series + Regression

## 1. Import Dataset
setwd('C:\\Users\\samsung\\Desktop\\datascience\\Time_series_analysis')

library(forecast)
library(tseries)
sales = read.csv('ts_reg_s1.csv')
dim(sales)
head(sales)

ts.plot(sales$Sales)

train = sales[1:89,]
test = sales[90:96,]

## 2. Linear Regression
sales_lm = lm(Sales~Open+Promo+SchoolHoliday, data=train)
summary(sales_lm)

covariates = c('Open','Promo','SchoolHoliday')
sales_lm_fcst = predict(sales_lm, newdata = test[,covariates])
cbind(floor(sales_lm_fcst), test$Sales)

mean(100-100*abs(as.numeric(sales_lm_fcst[-4]) - as.numeric(test$Sales[-4])) / as.numeric(test$Sales[-4]))

## 3. Residual Analysis
# residual(y-yhat) analysis
# to test if residual is white noise
# ex) Durbin-Watson Test

ts.plot(as.numeric(sales_lm$residuals))
library(lmtest)
dwtest(sales_lm) 
# autocorrelation exsits -> white noise (X)
# explain residual with AR model


## 4. ARIMA
train_ts = ts(train, frequency=7)
test_ts = ts(test,frequency=7)
sales_fit = auto.arima(train_ts[,'Sales'])
sales_fc = forecast(sales_fit, h=7)

mean(100-100*abs(as.numeric(sales_fc$mean[-4]) - as.numeric(test$Sales[-4])) / as.numeric(test$Sales[-4]))

## 5. Regression with ARIMA errors
sales_fit2 = auto.arima(train_ts[,'Sales'], xreg=train_ts[,covariates])
sales_fc2 = forecast(sales_fit2, xreg=test_ts[,covariates])

mean(100-100*abs(as.numeric(sales_fc2$mean[-4]) - as.numeric(test$Sales[-4])) / as.numeric(test$Sales[-4]))

