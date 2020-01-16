################################
### Olympic Medalist Data EDA ##
################################

# 1. importing data
setwd('C:\\Users\\samsung\\Desktop\\연세대\\2019.2학기\\마틱스\\hw1')
data = read.csv('Olympic.csv')
head(data)
str(data)

# 2. South Korea's Total Medal
nrow(data[data$Team=='South Korea',])

# 3. South & North Korea's Total Medal
nrow(data[data$Team=='South Korea',]) + nrow(data[data$Team=='North Korea',])

# 4. average of number of medals
nrow(data)/length(unique(data$Team))

# 5. histogram
hist(table(data$Team))

# 6. Top 20 ( number of medals )
# answer : South Korea is ranked at the 20th
sort(table(data$Team),decreasing=T)[1:20]


# 7. korea data
kor <- data[data$Team=='South Korea',]

# 8. Top Gold medalist in Korea
# answer : Jeon I-Gyeong, Jin Jong-O, Kim Su-Nyeong ( 4 medals, each )
korgold <- kor[kor$Medal=='Gold',]
sort(table(korgold$Name),decreasing=T)[1:10] # why not [1], but [1:10]? -> since there may be more than one person, who got the most gold medal in Korea

# 9. line graph
plot(table(kor$Year), type='l')


# 10. summary of medals in the Olympics( where Korea won the medal )
for (i in unique(kor$Year)) {
  print(paste("Year", i))
  print(summary(kor[kor$Year==i,]$Medal))
}
