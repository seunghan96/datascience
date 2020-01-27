################
### Ensemble ###
################
# 4가지 방법론 고려
# stl, tbats, arima, neuralnet
# (with multi-seasonality)

ensemble_v1 = function(x,frq1,frq2,fh){  # x:시계열 data, frq1 & frq2 : multi-seasonality, fh : 예측 기간
  r1 = ensemble_test(x,frq1,frq2,fh) # 여러 model이용하여 test
  p1 = which(r1==max(r1)) # choose best one
  qt = x
  
  y1 = ts(qt,frequency=frq1)
  y2 = msts(qt,seasonal.periods=c(frq1,frq2))
  
  
  if(p1==1){r2 = forecast(stl(y1, s.window = 'per'),h=fh)$mean} # stl
  else if(p1==2){r2 = forecast(tbats(y2),h=fh)$mean} # tbats
  else if(p1==3){r2 = forecast(auto.arima(y1),h=fh)$mean} # arima
  else{r2 = forecast(nnetar(y2),h=fh)$mean} # neuralnet
  
  return(list(r1,r2))
}


## Example
setwd('C:\\Users\\samsung\\Desktop\\datascience\\Time_series_analysis')
library(forecast)

sales = read.csv('sales_s1.csv')
sales_ms = sales$total[1:1097]
sales_ts = sales$total[1098:1127]

test1 = ensemble_v1(sales_ms, 365.25, 7, 30)

ts.plot(sales_ts)
lines(as.numeric(test1[2]),col='red')
