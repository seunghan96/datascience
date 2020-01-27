# Multi-Seasonal Time Series(msts) & TBATS

#######################
### 1. MSTS & TBATS ###
#######################

setwd('C:\\Users\\samsung\\Desktop\\datascience\\Time_series_analysis')
library(tseries)
library(forecast)
# ts function : frequency
# msts tunction : multi-frequency ( for 다중 계졀성 )

'''
TBATS function
- 1) 시계열을 box-cox transformation으로 변환 ( 분산을 일정하게 )
- 2) exponential smoothing -> trend 추정 -> trend 제거
- 3) error -> ARMA model
- 4) multi seasonality -> Fourier series를 이용하여 추ㅈ
'''

metro = read.csv('seoul_metro.csv')
city = metro$CityHall

city_train = city[1:1812]
city_test = city[1813:1826]

city_ts = ts(city_train, frequency=7)
city_msts = msts(city_train, seasonal.periods=c(7,365))

tbats_ts = tbats(city_ts)
tbats_msts = tbats(city_msts)

fc_ts = forecast(tbats_ts, h=14)
fc_msts = forecast(tbats_msts, h=14)

plot(fc_ts)

mean(100-100*abs(as.numeric(fc_ts$mean)-as.numeric(city_test)) / as.numeric(city_test))
mean(100-100*abs(as.numeric(fc_msts$mean)-as.numeric(city_test)) / as.numeric(city_test))

############################################
## 2. auto ARIMA with Fourier Seasonality ##
############################################

## multi seasonality 반영!

city_train2 = city[1:1461]
city_test2 = city[1462:1826]

city_msts2 = msts(city_train2, seasonal.periods=c(7,365))

z = fourier(city_msts2,K=c(3,10))
zreg = fourier(city_msts2,K=c(3,10), h=365)

arima_msts = auto.arima(city_msts2, seasonal=FALSE, xreg=z)
fc_msts2 = forecast(arima_msts,xreg=zreg,h=365)

mean(100-100*abs(as.numeric(fc_msts2$mean)-as.numeric(city_test2)) / as.numeric(city_test2))
