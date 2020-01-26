# 5. Timeseries Forecasting Model_Exchange Rate

library(forecast)

#### 1. Data Preprocessing ####
z = read.csv('C:\\Users\\samsung\\Desktop\\datascience\\Time_series_analysis\\pounds_nz.csv')

train = z[1:35]
test = z[36:39]
y = ts(train, frequency=4)

par(mfrow=c(3,1))
#### 2. Modeling ####
# 1) Exponential MA
fit1 = HoltWinters(y, beta=FALSE, gamma=FALSE)
fc1 = forecast(fit1, h=4)
plot(fc1, main='Exponential MA')

# 2) Holt Winters
fit2 = hw(y)
fc2 = forecast(fit2,h=4)
plot(fc2, main='Holt Winters')

# 3) STL
fit3 = stl(y, s.window='periodic')
fc3 = forecast(fit3, h=4)
plot(fc3, main='STL')

#### 3. Evaluation ####
# 1 - MAPE
mape1 = mean(100 - 100*abs(as.numeric(fc1$mean)-as.numeric(test)) / as.numeric(test))
mape2 = mean(100 - 100*abs(as.numeric(fc2$mean)-as.numeric(test)) / as.numeric(test))
mape3 = mean(100 - 100*abs(as.numeric(fc3$mean)-as.numeric(test)) / as.numeric(test))
mape1;mape2;mape3
