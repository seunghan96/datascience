# 1
job <- read.csv("C:\\Users\\samsung\\Downloads\\jobkorea.csv")
str(job)

# 2
job <- job[,c(3,4,5)]

# 3
job <- paste(job[,1],job[,2],job[,3],sep=' ')

# 4
library(KoNLP)
useSejongDic()

# 5
nouns <- sapply(job,extractNoun,USE.NAMES=F)
nouns <- unlist(nouns)

# 6
library(tm)
nouns <- removeWords(nouns, c(stopwords('en')))
nouns <- removePunctuation(nouns)
nouns <- stripWhitespace(nouns)
nouns <- removeNumbers(nouns)

nouns <- subset(nouns, nchar(nouns)>=2)
nouns <- paste(nouns, collapse=' ')

# 7
unlist_nouns <- as.vector(nouns)


################################################################

options(stringsAsFactors = F)
set.seed(1234)

clean.corpus <- function(corpus) {
  corpus <- tm_map(corpus, removePunctuation)
  corpus <- tm_map(corpus, removeNumbers)
  corpus <- tm_map(corpus, content_transformer(tolower))
  corpus <- tm_map(corpus, removeWords, c(stopwords("en"),'customer','service','customers','calls'))
  return(corpus)
}

# 8 
job.corpus <- VCorpus(VectorSource(unlist_nouns))

# 9
job.corpus <- clean.corpus(job.corpus)

# 10
job.dtm <- DocumentTermMatrix(job.corpus, control=list(weghting=weightTfIdf))
rowTotals <- apply(job.dtm,1,sum)
job.dtm <- job.dtm[rowTotals>0,]
job.dtm.s <- scale(job.dtm, scale=T)

# 11
set.seed(123)

#job.clusters <- kmeans(job.dtm.s, 3)
#여기서 "cannot take a sample larger than the popluation when 'replace=FALSE'오류 떠서 진행이..ㅠㅠㅠㅠ

#barplot(job.clusters$size, main='k-means')
#plotcluster(cmdscale(dist(job.dtm)), job.clusters$cluster)
#plot(silhouette(job.clusters$cluster, dist(job.dtm.s)))


# 12
#job.dtm <- DocumentTermMatrix(job.corpus, control=list(weghting=weightTfIdf))
#library(skmeans)
#여기서도 위와 같은 오류 ㅠㅠㅠ
#soft.part <- skmeans(job.dtm, 3, m=1.2, control=list(nruns=5, verbose=T))
#barplot(table(soft.part$cluster), main='Spherical k-means')
#plotcluster(cmdscale(dist(job.dtm)), soft.part$cluster)
#plot(silhouette(soft.part))


# 앞에 데이터 전처ㄹ과정 어딘가에서 삐끗한듯...그래서 뒤 이은 문제들도 다 오류 ㅠㅠ리ㅠ