# 3. Decomposition
library(forecast)
library(ggplot2)

gs = read.csv('C:\\Users\\samsung\\Desktop\\datascience\\Time_series_analysis\\gs_ts.csv')
gs_price = ts(gs$price,frequency=250) # seasonality : 250 days
plot(decompose(gs_price))

## 1) Holt Winters
## ( alpha, beta, gamma )
gs_hw = HoltWinters(gs_price)
plot(gs_hw)

forecast(gs_hw,h=10)

## decomposition plot
class(gs_hw)
is.list(gs_hw)
attributes(gs_hw)
str(gs_hw)

gs_hw_fitted = gs_hw$fitted[,1:4]
colnames(gs_hw_fitted)
plot(gs_hw_fitted,main='Decomposition of Time series (Holt Winters)') # beta(trend) = 0

## 2) STL(Seasonal Decomposition of Time Series by LOESS)
# smoothing method -> HW : Exponential <-> STL : LOESS (local regression)
# locally weighted polynomial regression
gs_stl = stl(gs_price, s.window='periodic')
plot(gs_stl)
str(gs_stl)

gs_stl$time.series[,1] # seasonality

stl_fcst = forecast(gs_stl, h=100)
plot(stl_fcst, main= 'Forecast by STL')
