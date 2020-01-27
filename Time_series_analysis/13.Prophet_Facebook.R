# 13. Prophet

'''
## Prophet ##
( Open source package by Facebook )

- 1) 일별데이터에 적합

- 2) 비선형 추세(Non-linear trend) 산출
  ( 시계열 automatic change-point detection + 베이지안 방법 prior for trend )
  ( change point detection : 시간 흐름 중간에 trend 바뀌면 파악! )

- 3) 일별(freq=7)&연도별(freq=365.25) 계절성 계산
  ( with Fourier terms -> multi-seasonality )

- 4) 휴일 효과 적용

- 5) saturating forecast(예측치의 범위 설정)
'''

### 1. Import dataset & libraries
library(prophet)
library(dplyr)

setwd('C:\\Users\\samsung\\Desktop\\datascience\\Time_series_analysis')
df = read.table('example_wp_peyton_manning.csv', sep=',', header=T) %>% mutate(y=log(y)) # log transformation!
head(df)

df_ms = df[1:2540,]
df_ts = df[2541:2905,]

### 2. Modeling
m = prophet(df_ms)

### 3. Forecast
future = make_future_dataframe(m, periods=365) # 예측치를 저장할 공간
head(future) ; tail(future)

forecast = predict(m, future) # prediction
tail(forecast[c('ds','yhat','yhat_lower','yhat_upper')]) # range

### 4. plot
plot(m,forecast) 
prophet_plot_components(m,forecast) # plot for (1)trend & (2)weekly / (3) yearly seasonality

### 5. MAPE
yhat = exp(forecast$yhat[(2905-364):2905])
mean(100-100*abs(as.numeric(yhat) - as.numeric(exp(df_ts$y))) / as.numeric(exp(df_ts$y)))

###############################################################################################

### saturating
df2 = read.table('example_wp_R.csv', sep=',', header=T) %>% mutate(y=log(y)) # log transformation
df2$cap = 8.5 # cap (maximum value)

m2 = prophet(df2,growth='logistic') # limit이 있을 경우!

future2 = make_future_dataframe(m2, periods=1826)
future2$cap = 8.5

forecast2 = predict(m2,future2)
plot(m2,forecast2)

############################################################################################

### adding monthly seasonality

df3 = read.table('example_wp_R.csv', sep=',', header=T) %>% mutate(y=log(y)) # log transformation

m3 = prophet(weekly.seasonality = F) # weekly 없애고 monthly
m3 = add_seasonality(m3, name='monthly', period=30.5, fourier.order = 5) # 5 fourier terms

m3 = fit.prophet(m3,df3) # with monthly seasonality

future3 = make_future_dataframe(m3, periods=365)
forecast3 = predict(m3,future3)

prophet_plot_components(m3,forecast3)

#############################################################################################
