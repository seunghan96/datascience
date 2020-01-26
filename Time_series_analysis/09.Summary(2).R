# Summary with US unemployment dataset #

setwd('C:\\Users\\samsung\\Desktop\\datascience\\Time_series_analysis')
us = read.csv('USunemp.csv')
head(us)
dim(us)
ts.plot(us)

# 2. train & test split for Cross-Validation
train1 = us$USun[1:118]
test1 = us$USun[119:130]

train2 = us$USun[1:106]
test2 = us$USun[107:118]

train3 = us$USun[1:94]
test3 = us$USun[95:106]

# 3. convert into time-series
m1 = ts(train1, frequency=12)
m2 = ts(train2, frequency=12)
m3 = ts(train3, frequency=12)

# 4-1. HoltWinters Model
hw1 = hw(m1)
hw2 = hw(m2)
hw3 = hw(m3)

hw1_fc = forecast(hw1,h=12)
hw2_fc = forecast(hw2,h=12)
hw3_fc = forecast(hw3,h=12)

attributes(hw1_fc)

cbind(hw1_fc$mean, test1)

par(mfrow=c(3,1))
plot(hw1_fc)
plot(hw2_fc)
plot(hw3_fc)

100-100*mean(abs(hw1_fc$mean - test1)/test1)
100-100*mean(abs(hw2_fc$mean - test2)/test2)
100-100*mean(abs(hw3_fc$mean - test3)/test3)

# 4-2. STL Method
stl_1 = stl(m1, s.window='per')
stl_2 = stl(m2, s.window='per')
stl_3 = stl(m3, s.window='per')

stl1_fc = forecast(stl_1, h=12)
stl2_fc = forecast(stl_2, h=12)
stl3_fc = forecast(stl_3, h=12)

attributes(stl1_fc)

cbind(stl1_fc$mean, test1)

par(mfrow=c(3,1))
plot(stl1_fc)
plot(stl2_fc)
plot(stl3_fc)

100-100*mean(abs(stl1_fc$mean - test1)/test1)
100-100*mean(abs(stl2_fc$mean - test2)/test2)
100-100*mean(abs(stl3_fc$mean - test3)/test3)

# 4-3. ARIMA
arima_1 = auto.arima(m1)
arima_2 = auto.arima(m2)
arima_3 = auto.arima(m3)

arima1_fc = forecast(arima_1,h=12)
arima2_fc = forecast(arima_2,h=12)
arima3_fc = forecast(arima_3,h=12)

attributes(arima1_fc)

cbind(arima1_fc$mean, test1)

par(mfrow=c(3,1))
plot(arima1_fc)
plot(arima2_fc)
plot(arima3_fc)

100-100*mean(abs(arima1_fc$mean - test1)/test1)
100-100*mean(abs(arima2_fc$mean - test2)/test2)
100-100*mean(abs(arima3_fc$mean - test3)/test3)

