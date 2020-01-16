# 기본 설정
options(stringsAsFactors = F)
set.seed(1234)
library(skmeans)
library(tm)
library(clue)
library(cluster)
library(fpc)
library(wordcloud)

clean.corpus <- function(corpus) {
  corpus <- tm_map(corpus, removePunctuation)
  corpus <- tm_map(corpus, removeNumbers)
  corpus <- tm_map(corpus, content_transformer(tolower))
  corpus <- tm_map(corpus, removeWords, c(stopwords("en"),'customer','service','customers','calls'))
  return(corpus)
}

# 파일 불러오고 dtm 형태로 변환하기
wk.exp <- read.csv('C:\\Users\\samsung\\Desktop\\Bitamin\\Textmining with R\\5장\\1yr_plus_final4.csv', header=T)
str(wk.exp)

wk.text <- VCorpus(VectorSource(wk.exp$text))
wk.corpus <- clean.corpus(wk.text)
wk.dtm <- DocumentTermMatrix(wk.corpus, control=list(weghting=weightTfIdf))

# scale해서 정규화하기
wk.dtm.s <- scale(wk.dtm, scale=T)

##################################################

# < 1. k-means >

# 군집화하기 (k=3)
wk.clusters <- kmeans(wk.dtm.s, 3)
wk.clusters

# barplot 그리기
barplot(wk.clusters$size, main='k-means')

# x축은 각각 군집1, 군집2, 군집3
# y축은 군집 별 document 수

# document 50개가 각각 어디 cluster에 속하는지 확인하기
# ( 1개는 군집1, 49개는 군집2에 속한다 )
wk.clusters$cluster

# 각각의 cluster가 몇개의 단어를 포함하고 있는지
wk.clusters$size

# plotcluster
# ( cmdscale은 2차원으로 축소하기 위해서 )
plotcluster(cmdscale(dist(wk.dtm)), wk.clusters$cluster)

# silhouette
# 경계가 뚜렷할 수록 잘 구분
plot(silhouette(wk.clusters$cluster, dist(wk.dtm.s)))

# prototypical words 뽑아내기
# ( cl_prototypes : extracting prototypes from each partition )
# ( t : transpose 하기 )
work.clus.proto <- t(cl_prototypes(wk.clusters))
comparison.cloud(work.clus.proto, max.words = 100)

##################################################

# < 2. Spherical K-Means Clustering >
# ( 장점 : sparse matrices를 잘 다룸 (0으로 많이 이루어진 데이터) )
# ( pg 139 그림 보면 이해 편할 듯 )
wk.dtm <- DocumentTermMatrix(wk.corpus, control=list(weghting=weightTfIdf))
soft.part <- skmeans(wk.dtm, 3, m=1.2, control=list(nruns=5, verbose=T))

# barplot
barplot(table(soft.part$cluster), main='Spherical k-means')

# plotcluster
plotcluster(cmdscale(dist(wk.dtm)), soft.part$cluster)

# silhouette
plot(silhouette(soft.part))

# wordcloud
s.clus.proto <- t(cl_prototypes(soft.part))
comparison.cloud(s.clus.proto, max.words=100)

# top 5 뽑아내기 ( 각각 cluster로 부터 )
sort(s.clus.proto[,1],decreasing=T)[1:5]
sort(s.clus.proto[,2],decreasing=T)[1:5]
sort(s.clus.proto[,3],decreasing=T)[1:5]

#######################################################3

# < 3. K-Mediod Clustering >
# ( cluster center 계산할 때, 평균값 말고 중위값 사용 )
wk.dtm <- DocumentTermMatrix(wk.corpus, control=list(weghting=weightTfIdf))
wk.mediods <- pamk(wk.dtm, krange=2:4, critout=T)
# ( krange : 가능한 cluster의 개수 범위 지정 )

plot(silhouette(wk.mediods$pamobject$clustering, dist(wk.dtm)))

########################################################

# < 4. Evaluating Cluster Approaches >
results <- cluster.stats(dist(wk.dtm.s), wk.clusters$cluster, wk.mediods$pamobject$clustering)
results

#########################################################
########################################################

# Calculating and Exploring String Distance
# String distance : 하나의 string에서 다른 string까지의 거리
# 종류
# 1) substitution : 단어 교체 횟수 ( racecar->racecat : 1 )
# 2) OSA : substitution + deletion + insertion + transposition ( racearzc -> racecars : 3 (c넣고,r->s하고,c빼고) )
# 3) DL : OSA + "adjacaent substrings can be transposed more than once )
# 4) LCS : deletion & insertion
# 5) Levenshtein : substitution + deletion + insertion
library(stringdist)
stringdist('crabapple','apple',method='lcs')
stringdist('crabapples','apple',method='lcs')

# 함수 3가지
# 1) Amatch ( + Ain )
match('apple', c('crabapple','pear'))  # match : 아예 일치하는 것 찾기
amatch('apple',c('crabapple','pear'), maxDist=3, method='dl') # (3거리 내로 변형시켜서) 일치 시킬 수 있는 것
amatch('apple',c('crabapple','pear'), maxDist=4, method='dl') 
ain('raspberry',c('berry','pear'), maxDist=4, method='dl') # T/F값으로 나타내기

# 2) Stringdist
stringdist('raspberry',c('berry','pear'), method='hamming') # hamming은 deletion을 허락 안함 -> 그래서 Inf값
stringdist('raspberry',c('berry','pear'), method='osa') # OSA는 4가지 변형 모두 가능함

# 3) Stringdistmatrix
fruit <- c('crabapple','apple','raspberry')
fruit.dist <- stringdistmatrix(fruit)
plot(hclust(fruit.dist), labels=fruit)

#########################################3
###########################################

# LDA Topic Modeling Explained
library(tm)
library(qdap)
library(lda)
library(GuardianR)
library(pbapply)
library(LDAvis)
library(treemap)
library(car)
options(stringsAsFactors = F)

text <- read.csv('C:\\Users\\samsung\\Desktop\\Bitamin\\Textmining with R\\5장\\guardian.csv')

articles <- iconv(text$body, "latin1",'ASCII',sub="")
articles <- gsub('http\\S+\\s*','',articles)
articles <- bracketX(articles, bracket='all')
articles <- gsub("[[:punct:]]","",articles)
articles <- removeNumbers(articles)  
articles <- tolower(articles)
articles <- removeWords(articles,c(stopwords('en'), 'pakistan','gmt','england'))

blank.removal <- function(x) {
  x <- unlist(strsplit(x,' '))
  x <- subset(x, nchar(x)>0)
  x <- paste(x,collapse=' ')
}

articles <- pblapply(articles, blank.removal)

# example로 훈련하기 (1)
ex.text <- c('Text mining is a     good time', 'Text mining is a good time')
strsplit(ex.text[1],' ')
strsplit(ex.text[2],' ')

char.vec <- unlist(strsplit(ex.text[1],' '))
char.vec

char.vec <- subset(char.vec, nchar(char.vec)>0)
char.vec

char.vec <- paste(char.vec, collapse=' ')
char.vec

# example로 훈련하기 (2)
ex.text <- c('this is a text document')
ex.text.lex <- lexicalize(ex.text)
ex.text.lex

ex.text <- c('this is a text document','text mining a text document is great')
ex.text.lex <- lexicalize(ex.text)
ex.text.lex

# example 끝내고 다시 본문으로!
documents <- lexicalize(articles)
wc <- word.counts(documents$documents, documents$vocab)
doc.length <- document.lengths(documents$documents)

# LDA 모델 만들기
k <- 4
num.iter <- 25
alpha <- 0.02
eta <- 0.02
set.seed(1234)
fit <- lda.collapsed.gibbs.sampler(documents=documents$documents,
                                   K=k,
                                   vocab=documents$vocab,
                                   num.iterations = num.iter,
                                   alpha=alpha,
                                   eta=eta,
                                   initial=NULL,
                                   burnin=0,
                                   compute.log.likelihood = TRUE
                                   )

plot(fit$log.likelihoods[1,])  # 무슨 의미지 ㅠㅠ

# 주제(4개) 별로 단어 7개
top.topic.words(fit$topics,7,by.score=TRUE)

# 각 주제를 잘 대표하는 문서는 어떤 문서?
# 주제1은 21번 문서가 잘 나타냄 / 주제2는 ....
top.topic.documents(fit$document_sums,1)

theta <- t(pbapply(fit$document_sums + alpha, 2, function(x) x/sum(x)))
phi <- t(pbapply(t(fit$topics) + eta, 2, function(x) x/sum(x)))

article.json <- createJSON(phi=phi, theta=theta, doc.length=doc.length, vocab=documents$vocab, term.frequency = as.vector(wc))
serVis(article.json)

# caluclate the mode for each of the document topics

doc.assignment <- function(x) {
  x <- table(x)
  x <- as.matrix(x)
  x <- t(x)
  x <- max.col(x)
}

fit$assignments[[2]][1:10]
table(fit$assignments[[2]][1:10])
t(as.matrix(table(fit$assignments[[2]][1:10])))
max.col(t(as.matrix(table(fit$assignments[[2]][1:10]))))
# 3번째 주제 (index로는 2)가 제일 많이 등장함!

assignments <- unlist(pblapply(fit$assignments,doc.assignment))

# topic number를 name으로 바꾸기
assignments <- recode(assignments, "1='Cricket1' ; 2='Paris Attacks'; 3='Cricket2'; 4='Unknown'")

article.ref <- seq(1:nrow(text))
article.pol <- polarity(articles)[[1]][3]
article.tree.df <- cbind(article.ref, article.pol, doc.length, assignments)
treemap(article.tree.df, index=c('assignments','article.ref'),
        vSize='doc.length', vColor='polarity',type='value',
        title='Guardian Articles mentioning Pakistan',
        palette=c('red','white','green'))

####################################################################
#####################################################################

# Text to Vectors using text2vec
library(data.table)
library(text2vec)
library(tm)
text <- fread('C:\\Users\\samsung\\Desktop\\Bitamin\\Textmining with R\\5장\\Airbnb-boston_only\\Airbnb-boston_only.csv', encoding='UTF-8')

airbnb <- data.table(review_id = text$review_id,
                     comments = text$comments,
                     review_scores_rating = text$review_scores_rating)

airbnb$comments <- removeWords(airbnb$comments, c(stopwords('en'),'Boston'))
airbnb$comments <- removePunctuation(airbnb$comments)
airbnb$comments <- stripWhitespace(airbnb$comments)
airbnb$comments <- removeNumbers(airbnb$comments)
airbnb$comments <- tolower(airbnb$comments)

tokens <- strsplit(airbnb$comments, split= " ", fixed=T)
vocab <- create_vocabulary(itoken(tokens), ngram=c(1,1))
vocab <- prune_vocabulary(vocab, term_count_min=5)
vocab[[1]][221:225]

iter <- itoken(tokens)
vectorizer <- vocab_vectorizer(vocab)
tcm <- create_tcm(iter, vectorizer,skip_grams_window=5)
str(tcm)

fit.glove<- GlobalVectors$new(word_vectors_size = 50, vocabulary =vocab , x_max=10, learning_rate=0.2)
word.vectors<-fit.glove$fit_transform(x=tcm, n_iter=15)
rownames(word.vectors) <- rownames(tcm)
word.vec.norm <- sqrt(rowSums(word.vectors^2))

good.walks <- word.vectors['walk', , drop=FALSE] - word.vectors['disappointed', , drop=FALSE] + word.vectors['good', , drop=FALSE]
cos.dist<-sim2(x = word.vectors, y=good.walks, method = "cosine", norm = "l2")
head(sort(cos.dist[,1], decreasing = T), 10)

dirty.sink <- word.vectors['sink', , drop=FALSE] - word.vectors['condition', , drop=FALSE] + word.vectors['dirty', , drop=FALSE]
cos.dist<- sim2(x = word.vectors, y=dirty.sink, method = "cosine", norm = "l2")
head(sort(cos.dist[,1], decreasing = T), 10)
