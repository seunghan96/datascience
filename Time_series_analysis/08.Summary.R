
######## SUMMARY  ##############

###################################
## 1. Exponential Moving Average ##
###################################

# 과거 일정 기간 데이터의 가중평균으로 미래 예측
# 최근 데이터 : 높은 가중치(alpha) / 오래전 데이터 : 낮은 가중치
# "바로 다음 시점"에 대한 예측력은 좋음
# Trend & Seasonality 고려 X

# 가중치 수동 설정 )exp_ma = HoltWinters(data, alpha=0.2, beta=False, gamma=False)
# 가중치 자동 설정 )exp_ma = HoltWinters(data, beta=False, gamma=False)
# forecast(exp_ma1, h=12)




######################################
## 2. Decomposition (시계열 분해법) ##
######################################
# Trend & Seasonality를 분해하여 각각을 예측하고 결합

# (1) HoltWinters 방법
# example = hw(data)
# forecast(example, h=12)

# (2) STL 방법
# example2 = stl(data, s.window='per)
# forecast(example2,h=12)


#################
## 3. ARIMA #####
#################
# AR integrated MA
# 시계열을 차분하여 '정상 시계열'로 만든 다음
# 자기상관변수(AR)과 백색잡음(MA)를 사용하여 시계열을 설명할 수 있는 모델 만들기
# AR(p) + MA(q) + differencing(d) 

# (1) x 변수 없을 때
# example =auto.arima(data)
# forecast(example, h=12)

# (2) x 변수 있을 때
# example2 = auto.arima(data,xreg=x변수)
# forecast(example2, xreg)


