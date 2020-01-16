######################
### Movie Audience ###
######################

setwd('C:\\Users\\samsung\\Desktop\\연세대\\2019.2학기\\경영\\마틱스\\hw4')
library(ggplot2)
data = read.csv('IMDb.csv')
head(data)
str(data)
colnames(data)
data$title_year = as.numeric(as.character(data$title_year))

# 목차
# 1. Hypothesis
# 2. EDA
# 3. Data Preprocessing
# 4. Modeling (regression)


##### Hypothesis #####
# H0 : ‘movie_facebook_likes(Facebook 좋아요 수)‘가 'gross(관람객 수)‘에 미치는 영향의 정도가  ‘num_critic_for_review (평론가들의 평론 수)’에 따라 다르다
# H1 : ‘movie_facebook_likes(Facebook 좋아요 수)‘가 'gross(관람객 수)‘에 미치는 영향의 정도가  ‘num_critic_for_review (평론가들의 평론 수)’에 따라 다르지 않다


##### EDA #####
# 1. Number of movies by genre
genre = colnames(data)[26:47]
genre_count = data.frame(colSums(data[genre]))
barplot(t(genre_count))

# 2. the change in the number of films released by the year
year_count = data.frame(table(data$title_year))
colnames(year_count) = c('Year','Movie_counts')
ggplot(data=year_count, aes(x=Year, y=Movie_counts)) + geom_bar(stat="identity")

# 3. Actor 1
actor_count = data.frame(table(data$actor_1_name))
colnames(actor_count) = c('Actor','Movie_counts')
top15_actor = actor_count[order(actor_count$Movie_counts, decreasing = TRUE),][1:15,]
ggplot(data=top15_actor, aes(x=Actor, y=Movie_counts)) + geom_bar(stat="identity")

# 4. Facebook 좋아요 수
top15_fb = data[order(data$movie_facebook_likes,decreasing=TRUE),][1:15,]
ggplot(data=top15_fb, aes(x=movie_title, y=gross)) + geom_bar(stat="identity") + geom_hline(yintercept=mean(data$gross), color = "red",size=2)


##### Data Preprocessing #####
# feature selection
data2 = data[(data$movie_facebook_likes>0)&(data$title_year>2009),]
data3 = data2[,c(11,13,15,16,22,12)]
head(data3)

# remove outliers
remove_outliers <- function(x, na.rm = TRUE, ...) {
  qnt <- quantile(x, probs=c(.25, .75), na.rm = na.rm, ...)
  H <- 1.5 * IQR(x, na.rm = na.rm)
  y <- x
  y[x < (qnt[1] - H)] <- NA
  y[x > (qnt[2] + H)] <- NA
  y
}

# Removes all outliers from a data set
remove_all_outliers <- function(df){
  df<-lapply(df,function(x) remove_outliers(x))
  df
}
final = data.frame(remove_all_outliers(data3))
final = na.omit(final)

# Mean Centering
mc<-function(x){
  x-mean(x)
}
final = as.data.frame(apply(final,2, mc))
head(final)

##### Modeling (Regression) ######
model = lm(gross~ movie_facebook_likes+num_voted_users +num_user_for_reviews+num_critic_for_reviews+imdb_score+movie_facebook_likes*num_critic_for_reviews, final)
summary(model)
