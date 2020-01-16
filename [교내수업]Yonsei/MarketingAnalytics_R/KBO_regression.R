#############################
### KBO Linear Regression ###
#############################

setwd('C:\\Users\\samsung\\Desktop\\연세대\\2019.2학기\\경영\\마틱스\\hw3')

# Q1. importing data 
# changing 'Mon~Thur' to 0 / 'Fri~Sun' to 1
KBO <- read.csv('KBO.csv',stringsAsFactors = FALSE)
KBO$요일[KBO$요일=='월'|KBO$요일=='화'|KBO$요일=='수'|KBO$요일=='목'] <- 0
KBO$요일[KBO$요일=='금'|KBO$요일=='토'|KBO$요일=='일'] <- 1
head(KBO)

# Q2. extracting month from '날짜'variable
f <- function(x) unlist(strsplit(x,"-"))[2]
KBO$month <- as.numeric(lapply(KBO$날짜,f))
head(KBO)

# Q3. importing 'results2016.csv'
results2016 <- read.csv('results 2016.csv')

# Q4. merging results2016 & KBO2  ( to add '승률' column )
w_rate <- results2016[c(2,6)]
KBO2 <- merge(KBO,w_rate,by.x='홈',by.y='구단',sort = F)
KBO2 <- merge(KBO2,w_rate,by.x='방문',by.y='구단',sort = F)
names(KBO2)[names(KBO2) == "승률.x"] <- "homewin"
names(KBO2)[names(KBO2) == "승률.y"] <- "awaywin"
KBO2$ha_diff <- abs(KBO2$homewin-KBO2$awaywin) # difference between 'homewin'&'awaywin'
names(KBO2)[names(KBO2) == "승률.x"] <- "homewin"
names(KBO2)[names(KBO2) == "승률.y"] <- "awaywin"

KBO2$ha_diff <- abs(KBO2$homewin-KBO2$awaywin) # difference between 'homewin'&'awaywin'

# Q5. importing 'weather.csv'
weather <- read.csv('weather.csv')

# Q6. merging KBO2 & weather ( to add '강수량' column )
library(reshape2)
weather2 <- melt(weather, id.vars = "날짜")
KBO3 <- merge(KBO2,weather2, by.x=c('날짜','구장'), by.y=c('날짜','variable'))
names(KBO3)[names(KBO3) == "value"] <- "rain"
head(KBO3)

# Q7. making dummy variables & Linear Model
# one hot encoding : n classes -> make (n) variables
# dummy encoding : n classes -> make (n-1) variables 
library(fastDummies)
# will not make 2 variables! only 1 variables ( the  row with zero on that variables represents '주말' )
dum_day <- dummy_cols(KBO3$요일,remove_first_dummy = TRUE)[c(-1)] 
# will not make 8 variables! only 7 variables ( the row with all zero on those 7 variables represent 'March')
dum_month <- dummy_cols(KBO3$month,remove_first_dummy = TRUE)[c(-1)]
# will not make 12 variables! only 11 variables ( the row with all zero on those 7 variables represent '고척' )
dum_place <- dummy_cols(KBO3$구장,remove_first_dummy = TRUE)[c(-1)]

X <- cbind(KBO3$rain, KBO3$homewin, KBO3$awaywin, KBO3$ha_diff, dum_day,dum_month,dum_place)
total <- cbind(X,KBO3$관중수)
head(total)
colnames(total) = c('rain','homewin','awaywin','ha_diff','주중','4월','5월','6월','7월',
                    '8월','9월','10월','대구','마산','문학','잠실','광주','대전','사직','수원','울산','포항','청주','관중수')

# '주말' represents "Fri/Sat/Sun"
# '주중' represents "Mon/Tue/Wed/Thur"
head(total)
linear <- lm(관중수~.,data=total)

############################################################################

# Q8. interpreting Model
summary(linear)

## dummy variable을 만들 때, 세 가지 종류의 dummy variable의 default값(모든 dummy columns들이 0일 때)는 각각'주말','3월','고척'이다
## 그러므로, 아래에서 얘기할 '각 변수가 끼치는 영향'은, 그 기준이 '3월/주말/고척 구장'이 된다!

# (1) rain
# the coefficient is less than zero(-30.33), which means that more rain causes less crowds

# (2) ha_diff
# ha_difference, which represents the "difference in the final grade at the end of season" also affects "관중수".
# the bigger between the grade of two teams, the less people come to see the match!

# (3) 주중
# More people visit during '주말' than '주중', since the coef of '주중' is negative

# (4) 10월
# Lots of people come to see the match at October.
# Maybe it is because it is end of the season, where lots of teams are trying their best to go to the post season!

# (5) 장소
# The place (stadium) where the game is held also affects the crowd.
# '마산','대전' has negative effect, and '문학','잠실','광주','사직' has positive effect.
# we can say that "month" is the most important variable that is affecting the "관중수"
# ha_difference, which represents the "difference in the final grade at the end of season" also affects "관중수"
# 
