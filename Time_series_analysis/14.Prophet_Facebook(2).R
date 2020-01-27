# Prophet (2)
setwd('C:\\Users\\samsung\\Desktop\\datascience\\Time_series_analysis')
df = read.csv('example_wp_peyton_manning.csv', sep=',', header=T) %>% mutate(y=log(y))

### Adding Holiday Effect
playoffs = data.frame(holiday='playoff',
                      ds=as.Date(c('2008-01-13','2009-01-03','2010-01-16','2010-01-24','2010-02-07','2011-01-08','2013-01-12','2014-01-12','2014-01-19','2014-02-02','2015-01-11','2016-01-17','2016-01-24','2016-02-07')),
                      lower_window=0, upper_window=1)

superbowls = data.frame(holiday='superbowl',ds=as.Date(c('2010-02-07','2014-02-02','2016-02-07')), lower_window=0,upper_window=1)

holidays = bind_rows(playoffs,superbowls)

head(holidays) ; dim(holidays)

m = prophet(df,holidays = holidays)
future = make_future_dataframe(m, periods=365)
forecast = predict(m,future)

# display holiday effects
forecast %>%
  select(ds,playoff, superbowl) %>%
  filter(abs(playoff+superbowl)>0) %>%
  tail(10)

prophet_plot_components(m,forecast)

####################################################3

### Cross Validation in Prophet

m = prophet(df)

df.cv = cross_validation(m, horizon=365, units='days') 

df.cv$cutoff = as.Date(df.cv$cutoff)
head(df.cv)
unique(df.cv$cutoff)
filter(df.cv, cutoff=='2011-01-21')
