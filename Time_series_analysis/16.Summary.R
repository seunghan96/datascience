# Summary ½Ç½À
setwd('C:\\Users\\samsung\\Desktop\\datascience\\Time_series_analysis')
library(dplyr)
library(forecast)

bond =read.csv('bond_3yr.csv')
bond$date = as.Date(bond$date, format='%Y/%m/%d')

bond1 = bond
bond1 = bond1[complete.cases(bond1),] # eliminate NA

bond_ms = bond1$rate[1:(nrow(bond1)-30)]
bond_ts = bond1$rate[(nrow(bond1)-29):nrow(bond1)]

# 1) stl
fit = stl(ts(bond_ms, frequency = 250), s.window='per')
fcst = as.numeric(forecast(fit, h=30)$mean)

mean(100-100*abs(fcst-bond_ts)/bond_ts)

ts.plot(bond_ts)
lines(fcst,col='red')

# 2) tbats
fit = tbats(ts(bond_ms, frequency = 250))
fcst = as.numeric(forecast(fit, h=30)$mean)

mean(100-100*abs(fcst-bond_ts)/bond_ts)

ts.plot(bond_ts)
lines(fcst,col='red')

# 3) ARIMA
fit = auto.arima(ts(bond_ms, frequency = 250))
fcst = as.numeric(forecast(fit, h=30)$mean)

mean(100-100*abs(fcst-bond_ts)/bond_ts)

ts.plot(bond_ts, ylim=c(0,2))
lines(fcst,col='red')

# 4) Neural Network
fit = nnetar(ts(bond_ms, frequency = 250))
fcst = as.numeric(forecast(fit, h=30)$mean)

mean(100-100*abs(fcst-bond_ts)/bond_ts)

ts.plot(bond_ts, ylim=(c(0,2)))
lines(fcst,col='red')