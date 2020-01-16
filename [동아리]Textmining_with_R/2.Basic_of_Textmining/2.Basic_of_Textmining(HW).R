# 1-1
ls <- read.csv("C:\\Users\\samsung\\Downloads\\love_separation.csv")
str(ls)

# 1-2
ls1 <- ls[ls$type=='love ',]
ls2 <- ls[ls$type=='separation',]
lsd1 <- data.frame(doc_id=seq(1:nrow(ls1)), text=ls1$lyrics)
lsd2 <- data.frame(doc_id=seq(1:nrow(ls2)), text=ls2$lyrics)

# 1-3
library(tm)
tryTolower = function(x) {
  y=NA
  try_error=tryCatch(tolower(x),error=function(e) e)
  if (!inherits(try_error,'error'))
    y=tolower(x)
  return(y)
}

# 1-4
custom.stopwords <- c(stopwords('english'))

clean.corpus <- function(corpus) {
  corpus <- tm_map(corpus, content_transformer(tryTolower))
  corpus <- tm_map(corpus, removeWords, custom.stopwords)
  corpus <- tm_map(corpus, removePunctuation)
  corpus <- tm_map(corpus, stripWhitespace)
  corpus <- tm_map(corpus, removeNumbers)
  return(corpus)
}

# 1-5.
corpus1 <- VCorpus(DataframeSource(lsd1))
lsd1_clean <- clean.corpus(corpus1)

corpus2 <- VCorpus(DataframeSource(lsd2))
lsd2_clean <- clean.corpus(corpus2)

# 1-6.
tdm1 <- TermDocumentMatrix(lsd1_clean, control=list(weighting=weightTf))
tdm2 <- TermDocumentMatrix(lsd2_clean, control=list(weighting=weightTf))

# 1-7.
m1 <- as.matrix(tdm1)
m2 <- as.matrix(tdm2)
term.freq1 <- rowSums(m1)
term.freq2 <- rowSums(m2)
freq.df1 <- data.frame(word=names(term.freq1), frequency=term.freq1)
freq.df2 <- data.frame(word=names(term.freq2), frequency=term.freq2)
freq.df1 <- freq.df1[order(freq.df1[,2], decreasing=T),]
freq.df2 <- freq.df2[order(freq.df2[,2], decreasing=T),]
freq.df1[1:10,]
freq.df2[1:10,]

######################################33

# 2
x <- read.csv('C:\\Users\\samsung\\Downloads\\x.csv')
#y <- grep("@+",x,value=TRUE) ( 하나의 문자열 안에 @가 들어가 있는건 어케 찾죠...ㅠ)
#( @+ 앞에 뭘 적어야 할지...공백/영어/ '/' 등 열별로 다양한게 들어가있어서... )
