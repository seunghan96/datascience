####### Time Series Decomposition

# 1. Moving Average (MA/단순 이동평균)
## smoothing의 한 방법
## 과거 일정 기간 데이터들을 average
library(forecast)
library(ggplot2)

gs = read.csv('gs_ts.csv')
class(gs)
head(gs)
tail(gs)

# 1) original plot
gs_price = ts(gs$price,frequency=250) # approximately 365 * (5/7)
plot(gs_price, main='Goldman Sachs Stock Price')

# 2) MA plot
ml = filter(gs_price, rep(1/100,100), sides=1) # sides=1 : past 
plot(gs_price, main='Goldman Sachs Stock Price (1000days MA)') 
lines(ml,col='red') # smoothing

######################################################################

# (가중 이동평균)
# 2. Exponential Moving Average (지수 이동평균)
# more weight on recent data
# alpha : 0 ~ 1 ( the bigger, the more weight on recent data )
# R : HoltWinters ( find the optimal alpha )

# alpha(level), beta(trend), gamma(seasonality)
#gs_hw = HoltWinters(gs_price, alpha=0.8, beta=FALSE, gamma=FALSE)
gs_hw = HoltWinters(gs_price, beta=FALSE, gamma=FALSE)
plot(gs_hw, main = 'Exponential Moving Average')

