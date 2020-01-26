library(forecast)
library(ggplot2)
library(ggfortify)

# 1. AirPassenger

## 1) data overview
plot(AirPassengers)
class(AirPassengers)

AP = AirPassengers
start(AP) 
end(AP)
frequency(AP)

## 2) graph
par(mfrow=c(3,1))
plot(AP, ylab='Num of Passengers', xlab='Time')
plot(aggregate(AP),ylab='Passengers') # monthly
boxplot(AP~cycle(AP),ylab='Passengers')

autoplot(AP,ts.colour='red',ts.linetype='dashed')



# 2. US unemployment
cbe = read.csv('cbe.csv')
class(cbe)
head(cbe)

choc = ts(cbe[,1],start=1958, frequency=12)
beer = ts(cbe[,2],start=1958, frequency=12)
elec = ts(cbe[,3],start=1958, frequency=12)

plot(cbind(choc,beer,elec), main='Multiple TS Graph')

# 3. Intersection between time series
AP.elec = ts.intersect(AP,elec)
start(AP.elec)

par(mfrow=c(2,1))
plot(AP.elec[,1], ylab='AirPassengers')
plot(AP.elec[,2], ylab='Electricity')

plot(cbind(AP.elec[,1],AP.elec[,2]), main='Intersection')

# 4. Trend & Seasonality

## 1) Trend
plot(AP)
ap.time = time(AP)
Reg= lm(AP~ap.time)
abline(Reg)

## 2) TS decomposition
decompose(AP)
plot(decompose(AP))
