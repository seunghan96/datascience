# 4. Timeseries Forecasting Model_AirPassenger

library(forecast)

#### 1. Data Preprocessing ####
AP = AirPassengers

index = round(length(AP)*0.85)
train = AP[1:index]
test = AP[index:length(AP)]

y = ts(train,frequency=12)

#### 2. Modeling ####
# 1) Exponential MA 1
ex_fit = HoltWinters(y, beta=FALSE, gamma=FALSE)
ex_fc = forecast(ex_fit, h=12)
plot(ex_fc, main='Exponential MA Forecast')

# 2) Exponential MA 2
ex_fit2 = HoltWinters(y, alpha=0.1, beta=FALSE, gamma=FALSE)
ex_fc2 = forecast(ex_fit2, h=12)
plot(ex_fc2, main='Exponential MA Forecast 2')

# 3) Holt Winters 1   # parameter estimated by MLE
hw_fit = hw(y) 
hw_fc = forecast(hw_fit, h=12)
plot(hw_fc, main='Holt Winters Forecast')

# 4) Holt Winters 2    # parameter estimated by MSE
hw_fit2 = HoltWinters(y)
hw_fc2 = forecast(hw_fit2, h=12)
plot(hw_fc2, main='Holt Winters Forecast 2')

# 5) Seasonal Decomposition of Time Series by LOESS
stl_fit = stl(y,s.window='per')
stl_fc = forecast(stl_fit,h=12)
plot(stl_fc, main='STL Forecast')

#### 3. Evaluation ####
# 1 - MAPE
ex1_mape = mean(100 - 100*abs(as.numeric(ex_fc$mean)-as.numeric(test)) / as.numeric(test))
ex2_mape = mean(100 - 100*abs(as.numeric(ex_fc2$mean)-as.numeric(test)) / as.numeric(test))
hw_mape = mean(100 - 100*abs(as.numeric(hw_fc$mean)-as.numeric(test)) / as.numeric(test))
hw2_mape = mean(100 - 100*abs(as.numeric(hw_fc2$mean)-as.numeric(test)) / as.numeric(test))
stl_mape = mean(100 - 100*abs(as.numeric(stl_fc$mean)-as.numeric(test)) / as.numeric(test))
ex1_mape ; ex2_mape ; hw_mape ; hw2_mape ; stl_mape
