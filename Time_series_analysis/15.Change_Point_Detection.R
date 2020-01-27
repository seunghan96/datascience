# Change Point Detection
setwd('C:\\Users\\samsung\\Desktop\\datascience\\Time_series_analysis')
'''
시계열의 평균/분산/분포 등의 변화를 감지
'''
library(changepoint)
y_ts = ts(rnorm(500,mean=1,sd=0.5))
y_ts_CP = ts(c(rnorm(250,mean=1,sd=0.5),rnorm(250,mean=2,sd=1)))

par(mfrow=c(2,1))
plot(y_ts)
plot(y_ts_CP)

mvalue = cpt.mean(y_ts_CP,method='PELT')
#mvalue = cpt.mean(y_ts_CP,method='BinSeg') # binary segment
#mvalue = cpt.mean(y_ts_CP,method='AMOC') # finding ONE change point
cpts(mvalue)
plot(mvalue)

varvalue = cpt.var(y_ts_CP,method='PELT')
cpts(varvalue)
plot(varvalue)

# Goldman Sachs
gs = read.csv('gs_ts.csv',header=T)
gs_ts = ts(gs$price, frequency = 250)

mvalue = cpt.mean(gs_ts,method='BinSeg')
cpts(mvalue)
plot(mvalue)

varvalue = cpt.var(gs_ts,method='BinSeg')
cpts(varvalue)
plot(varvalue)
