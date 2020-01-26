# 5. ARIMA

#### 1. 시계열의 정상성 ####
''' 
정상(stationarity) : 시계열의 joint pdf가 시간에 따라 불변
약한 정상(weak stationarity) : 시게열의 1)평균 2)분산이 일정하고, 3) 자기상관함수는 시간이 아닌 시차의 함수
 (1) 평균 일정 : trend 없다
 (2) 분산 : 변동의 폭이 일정
 (3) 상관관계는 시간이 아닌 시차에 따라 결정

정상 시계열 : 움직임의 폭이 일정 & 유의미한 trend X
비정상 시계열 : 뚜렷한 trend O & 분산도 (정상 시계열보다) 큼

정상 시계열 중, White Noise 
 1) 평균 = 0
 2) 분산 = constant
 3) 데이터들이 서로 독립

비정상 시계열 중, Random Walk
 1) 평균 = constant
 2) 분산 : t*sigma^2에 따라 증가
'''

library(forecast)
library(tseries)

# white noise ( stationarity ts )
set.seed(1234)
wn = rnorm(1000)
ts.plot(wn)

# random walk ( Non-stationarity ts )
set.seed(1234)
x = rnorm(1)
w = rnorm(1000)
for (t in 2:1000) {x[t] = x[t-1]+w[t]}
ts.plot(x)

# 비정상 시계열을 정상 시계열로
# for ARIMA 

## 1) Detrending
## by differencing(차분) -> trend 없앰
par(mfrow=c(2,1))
plot(AirPassengers)

## 2) Stabilizing Variance
## by Log Transformation -> variance 줄임
par(mfrow=c(3,1))
plot(AirPassengers)
plot(diff(AirPassengers))
plot(diff(log(AirPassengers)))

## 3) acf : Auto Correlation Function
## 시계열의 자기상관을 계산!
par(mfrow=c(2,1))
plot(acf(AirPassengers))
plot(acf(diff(log(AirPassengers)))) 


#### 2. ARIMA ####
'''
ARIMA (Auto Regressive Integrated Moving Average)

1) AR(p) : 자기상관모형
2) MA(q) : 이동평균모형
3) AR(p) + MA(q) : ARMA
4) AR(p) + MA(q) + differencing : ARIMA
'''

library(forecast)
library(tseries)

## 1) simulate AR
set.seed(12345)
ar1 = arima.sim(n=1000,list(ar=c(0.9)))
ts.plot(ar1)

eps = rnorm(1000)
eps2 = rnorm(1000)
y = eps
x = eps2
for (t in 2:1000) {
  y[t] = y[t-1] + eps[t]
  x[t] = 1.05*x[t-1] + eps2[t]
}

par(mfrow=c(2,2))
plot(y[1:40], type='l', main='a=1') # phi=1 (random walk)
plot(x[1:40], type='l', main='a=1.05') # explode!
plot(y, type='l', main='a=1')
plot(x, type='l', main='a=1.05')


## 2) Unit Root Test
'''
by adf ( Augmented Dichy Fuller Test )
시계열이 정상성인지 확인
unit root를 가지면 비정상(non Stationary) ( p value 작아서 가설 기각 시, unit root 비존 -> 정상성 시계열 )
# phi < 1 : stationary
# phi = 1 : random walk
# phi > 1 : explode
'''

adf.test(AirPassengers) # ??
## should difference first!


## 3) ARIMA modeling
'''
summary : 세개의 parameter를 추정하는 것! (p,q,d)
AR(p) + MA(q) + differencing(d) = ARIMA(AR integrated MA)
# 순서
1) 먼저 difference ( d번 차분 후 정상으로 변환 )
2) 정상으로 변환 후, ARMA 모형을 적합하기 위 acf,pacf를 이용하여 p,q찾

# acf (auto correlation function / 자기상관함수)
# pacf (partial correlation function / 편자기상관함수)

White Noise : (acf) lag=0에서는 1, 나머지는 0 & (pacf) 모든 lag에서 0
Random Walk : (acf) 모든 lag에서 0보다 유의하게 큼 & (pacf) lag=1에서는 0보다 크고, 외에서는 0
Differenced Random Walk : (acf) lag=0에서는 1, 그외에는 0 & (pacf) 모든 lag에서 0
'''

library(forecast)
library(tseries)

plot(AirPassengers)
par(mfrow=c(2,1))
acf(AirPassengers)
pacf(AirPassengers)
