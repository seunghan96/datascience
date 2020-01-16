library(qdap)

# postive vector 만들기
new.pos <- c('rofl','lol')
old.pos <- subset(as.data.frame(key.pol),key.pol$y==1)
all.pos <- c(new.pos,old.pos[,1])

# negative vector 만들기
new.neg <- c('kappa','meh')
old.neg <- subset(as.data.frame(key.pol),key.pol$y==-1)
all.neg <- c(new.neg,old.neg[,1])

# sentiment frame 만들기
all.polarity <- sentiment_frame(all.pos, all.neg, 1, -1)

# invoke new lexicon ( 긍정 )
# customize [O]
polarity('ROFL, look at that!', polarity.frame=all.polarity)
# customize [X]
polarity('ROFL, look at that!')

# invoke new lexicon ( 부정 )
# customize [O]
polarity('kappa is bad word', polarity.frame=all.polarity)
# customize [X]
polarity('kappa is bad word')

##########################################################3

## wordcloud 만들기 ##

# 기본 설정 
options(stringsAsFactors = F)
library(tm)
library(qdap)
library(wordcloud)
library(ggplot2)
library(ggthemes)

# airbnb 파일 불러오기
bos.airbnb <- read.csv('C:\\Users\\samsung\\Desktop\\Bitamin\\Textmining with R\\4장. Sentiment Scoring\\bos_airbnb_1k.csv')

# polarity 확인
bos.pol <- polarity(bos.airbnb$comments)
bos.pol
ggplot(bos.pol$all, aes(x=polarity, y=..density..)) + 
  theme_gdocs() + 
  geom_histogram(binwidth=.25, fill='darkred', colour='grey60', size=.2) + 
  geom_density(size=.75)
## 그래프 확인해보면, 평균(mean)이 0이 아니라, 0.9정도 됨을 알 수 있음
## -> 의미 : 최소 몇몇의 'positive'단어가 있음을 알 수 있음

# 지금 만든 polarity를 원본 data.frame에 추가하기
bos.airbnb$polarity <- scale(bos.pol$all$polarity)

# 긍&부정 comment 구분하기
pos.comments <- subset(bos.airbnb$comments, bos.airbnb$polarity>0)
neg.comments <- subset(bos.airbnb$comments, bos.airbnb$polarity<0)

# 이 comments들을 합치기
pos.terms <- paste(pos.comments, collapse = " ")
neg.terms <- paste(neg.comments, collapse = " ")
all.terms <- c(pos.terms, neg.terms)
all.corpus <- VCorpus(VectorSource(all.terms))

# corpus를 tdm으로 바꾸기
all.tdm <- TermDocumentMatrix(all.corpus, control=list(weighting=weightTfIdf, removePunctuation=TRUE, 
                                                       stopwords=stopwords(kind='en')))

# tdm을 matrix 형식으로 바꾸기
all.tdm.m <- as.matrix(all.tdm)
colnames(all.tdm.m) <- c('positive','negative')

# cloud 생성
comparison.cloud(all.tdm.m, max.words=100, colors=c('darkgreen','darkred'))

################################################################

# 이모티콘

# (1) symbol-based
# ex) ♥ = 사랑 = \U2764
# 이러한 이모티콘을 '단어'로 바꿔줘야!
text <- "I am \U263B. I \U2764 ice cream"
patterns <- c('\U263B', '\U2764')
replacements <- c('happy','love')
mgsub(pattern=patterns,replacement=replacements, text)

# (2) punctuation-based
# ex) :) = smiley face
data(emoticon)
head(emoticon)
X <- emoticon

# append emoticons to the basic dataframe
meaning <- c('troubled face', 'crying')
emoticon <- c('(>_<)','Q_Q')
new.emotes <- data.frame(meaning, emoticon)
emoticon <- rbind(X, new.emotes)
emoticon

text <-  "Text mining is so much fun :-D. Other tm books make me Q_Q."
mgsub(pattern=emoticon[,2], replacement=emoticon[,1], text)

# (3) Emoji
# 생략

#######################################################

# Archived Sentiment Scoring Library
# 6가지 감정 분석
library(sentiment)
install.packages("C:\\Users\\samsung\\Desktop\\Rstem_0.4-1.tar.gz", repos=NULL, type='source')
install.packages("Rstem")
library(Rstem)

install.packages('Rstem', dependencies = TRUE)
download.file("C:\\Users\\samsung\\Desktop\\Rstem_0.4-1.tar.gz", 
              f <- tempfile())
unzip(f, exdir=tempdir())
load(file.path(tempdir(), '.RData'))
