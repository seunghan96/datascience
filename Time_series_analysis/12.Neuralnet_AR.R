# Neuralnet AR

'''
nnetar(Neuralnet AR)
- input : AR변수 (y_t-1, y_t-2 ...)
- single hidden layer
- nnetar(timeseries, p(=AR 개수), P(=seasonal lag), k(=node의 수))
'''

setwd('C:\\Users\\samsung\\Desktop\\datascience\\Time_series_analysis')
library(forecast)

sales = read.csv('sales_s1.csv')
dim(sales)
head(sales)

par(mfrow=c(3,1))
ts.plot(sales$site1)
ts.plot(sales$site2)
ts.plot(sales$total)

train1 = sales$total[1:1099]
test1 = sales$total[1100:1127]

train2 = sales$total[1:1069]
test2 = sales$total[1070:1097]

train3 = sales$total[1:1039]
test3 = sales$total[1040:1067]

# single seasonality
ms_t1 = ts(train1, frequency=365)
ms_t2 = ts(train2, frequency=365)
ms_t3 = ts(train3, frequency=365)

# neural network AR
t1_nnetar = nnetar(ms_t1)
t2_nnetar = nnetar(ms_t2)
t3_nnetar = nnetar(ms_t3)

# forecast
fc1 = forecast(t1_nnetar, h=28)
fc2 = forecast(t2_nnetar, h=28)
fc3 = forecast(t3_nnetar, h=28)

fc1$mean[fc1$means<0] = 0
fc2$mean[fc2$means<0] = 0
fc3$mean[fc3$means<0] = 0

# plot
plot(fc1)
plot(fc2)
plot(fc3)

# MAPE
100-100*abs(sum(fc1$mean)-sum(test1))/sum(test1)
100-100*abs(sum(fc1$mean)-sum(test2))/sum(test2)
100-100*abs(sum(fc1$mean)-sum(test3))/sum(test3)
