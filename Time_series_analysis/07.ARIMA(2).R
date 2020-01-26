# 7. ARIMA (2)

## 1) White Noise
set.seed(1234)
wn = rnorm(1000)
ts.plot(wn)

par(mfrow=c(2,1))
acf(wn) 
pacf(wn)

# ACF : lag=0에서는 1, 그 이후로는 0
# PACF : 모든 lag에서 0


## 2) Random Walk
set.seed(123)
x = rnorm(1)
w = rnorm(1000)
for (t in 2:1000){
  x[t] = x[t-1]+w[t]
}
head(x)
head(w)
ts.plot(x)

par(mfrow=c(2,1))
acf(x)
pacf(x)

# ACF : 상관관계 high -> 비정상시계열! -> 차분 필


## 3) Random Walk with Differencing
par(mfrow=c(2,1))
acf(diff(x))
pacf(diff(x))
# 정상시계열로 변함을 확인

'''
AR(1), alpha=0.9
# AR(p) : p시점 이후 PACF는 급격히, ACF는 점진적으로 감소

MA(1). theta = 0.8
# MA(q) : q시점 이후 ACF는 급격히, PACF는 점진적으로 감소
'''

## 4) Auto Arima
library(forecast)
auto.arima(AirPassengers)

'''
해석?
ARIMA(2,1,1)(0,1,0)[12]
1) ARIMA(p=2,d=1,q=1)
2) y_t = 0.596(y_t-1) + 0.2143(y_t-2) - 0.9819(e_t-1)
3) (0,1,0)[12] : seasonality for every 12 months
'''

auto.arima(diff(AirPassengers))
# (2,1,1)->(2,0,1)로 바뀜
# 차분을 미리 해줬으니 d=1에서 d=0


## 5) ARIMA
arima(AirPassengers,c(2,1,1),seasonal=list(order=c(0,1,0), period=12))

library(forecast)
fit = auto.arima(AirPassengers)
fcst = forecast(fit, h=10*12)
plot(fcst)

attributes(fcst)

exp(fcst$mean)
ts.plot(AirPassengers,fcst$mean, lty=c(1,3))
