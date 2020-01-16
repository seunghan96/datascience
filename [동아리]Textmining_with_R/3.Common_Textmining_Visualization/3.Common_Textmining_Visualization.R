options(stringAsFactor=F)
library(tm)
library(stringr)

# 1-1.
text.df <- read.csv('C:\\Users\\samsung\\Desktop\\Bitamin\\Textmining with R\\3장\\some_review1.csv')

# 1-2.
str_replace_all(text.df,"\\W","")

# 1-3.
reviews <- data.frame(doc_id=seq(1:nrow(text.df)), text=text.df$This.place.is.amazing.it.takes.you.back.to.the.old.days.of.life..Me.and.my.wife.stop.by.and.ordered.the.beef.deep.and.I.ordered.the.pastrami.hands.down.the.pastrami.was.better..This.place.is.road.trip.worthy)

# 1-4.
corpus <- VCorpus(DataframeSource(reviews))

# 1-5.
tryTolower <- function(x){
  y = NA
  try_error = tryCatch(tolower(x),
                       error = 	function(e) e)
  if (!inherits(try_error, 'error'))
    y = tolower(x)
  return(y)
}

custom.stopwords <- c(stopwords('english'))
clean.corpus<-function(corpus){
  corpus <- tm_map(corpus,
                   content_transformer(tryTolower))
  corpus <- tm_map(corpus, removeWords,
                   custom.stopwords)
  corpus <- tm_map(corpus, removePunctuation)
  corpus <- tm_map(corpus, stripWhitespace)
  corpus <- tm_map(corpus, removeNumbers)
  return(corpus)
}

corpus<-clean.corpus(corpus)

# 1-6.    
tdm <- TermDocumentMatrix(corpus, control=list(weighting=weightTf))
tdm.reviews.m<-as.matrix(tdm)

# 1-7.
term.freq<-rowSums(tdm.reviews.m)
freq.df<-data.frame(word=names(term.freq),frequency=term.freq)
freq.df<-freq.df[order(freq.df[,2], decreasing=T),]
freq.df$word<-factor(freq.df$word, levels=unique(as.character(freq.df$word)))

# 1-8.
library(ggplot2)
ggplot(freq.df[1:30,], aes(x=word, y=frequency))+
  geom_bar(stat="identity", fill='darkred')+
  coord_flip()+
  theme_gdocs()+
  geom_text(aes(label=frequency),
            colour="white",hjust=1.25, size=5.0)

# 1-9.
associations<-findAssocs(tdm, 'old', 0.25)
associations<-as.data.frame(associations)
associations$terms<-row.names(associations)
associations$terms<-factor(associations$terms, levels=associations$terms)
ggplot(associations, aes(y=terms)) +
  geom_point(aes(x=old), data=associations, size=5)+
  theme_gdocs()+
  geom_text(aes(x=old,label=old),colour="darkred",hjust=-.25,size=8)+
  theme(text=element_text(size=20), axis.title.y=element_blank())

# 1-10.
library(igraph)
haven <- reviews[grep("haven", reviews$text, ignore.case=T), ]
haven.corpus <- VCorpus(DataframeSource(haven))
haven.corpus <- clean.corpus(haven.corpus)
haven.tdm <- TermDocumentMatrix(haven.corpus,control=list(weighting=weightTf))
haven.m <- as.matrix(haven.tdm)

# 1-11.
haven.adj<-haven.m %*% t(haven.m)
haven.adj<-graph.adjacency(haven.adj, weighted=TRUE,mode="undirected", diag=T)
haven.adj<-simplify(haven.adj)
plot.igraph(haven.adj, vertex.shape="none",
            vertex.label.font=2, vertex.label.color="darkred",
            vertex.label.cex=.7, edge.color="gray85")
title(main='"Haven" Word Network')

library(qdap)
word_network_plot(haven$text)
title(main='"Haven" Word Network')

# 1-12.
# 코딩은 정상적으로 실행이 되었는데 뭔가 눈에 보이는 인사이트가 없어요..ㅠㅠ 뭐지..?ㅋㅋㅋ
  
#############################################################################################

# 2-1.
text.df <- read.csv('C:\\Users\\samsung\\Desktop\\Bitamin\\Textmining with R\\3장\\trump.csv')

str_replace_all(text.df,"\\W","")

corpus <- VCorpus(DataframeSource(text.df))

tryTolower <- function(x){
  y = NA
  try_error = tryCatch(tolower(x),
                       error = 	function(e) e)
  if (!inherits(try_error, 'error'))
    y = tolower(x)
  return(y)
}

custom.stopwords <- c(stopwords('english'))
clean.corpus<-function(corpus){
  corpus <- tm_map(corpus,
                   content_transformer(tryTolower))
  corpus <- tm_map(corpus, removeWords,
                   custom.stopwords)
  corpus <- tm_map(corpus, removePunctuation)
  corpus <- tm_map(corpus, stripWhitespace)
  corpus <- tm_map(corpus, removeNumbers)
  return(corpus)
}

corpus<-clean.corpus(corpus)

tdm <- TermDocumentMatrix(corpus, control=list(weighting=weightTf))
tdm.trump.m<-as.matrix(tdm)

term.freq<-rowSums(tdm.trump.m)
freq.df<-data.frame(word=names(term.freq),frequency=term.freq)
freq.df<-freq.df[order(freq.df[,2], decreasing=T),]
freq.df$word<-factor(freq.df$word, levels=unique(as.character(freq.df$word)))

# 2-1.
tdm2 <- removeSparseTerms(tdm,sparse=0.8)

# 2-2.
hc <- hclust(dist(tdm2, method='euclidean'), method='complete')

# 2-3.
plot(hc, yaxt='n', main='dendogram')

# 2-4.
dend.change <- function(n) { 
  if (is.leaf(n)) {
    a <- attributes(n)
    labCol <- labelColors[clusMember[which(
      names(clusMember)==a$label)]]
    attr(n,"nodePar")<- c(a$nodePar,lab.col=labCol)
  }
  n
}

# 2-5.
hcd <- as.dendrogram(hc)
clusMember <- cutree(hc,4)
labelColors <- c('darkgrey','darkred','black','#bada55')
clusDendro <- dendrapply(hcd, dend.change)
plot(clusDendro, main='dendogram',type='triangle',yaxt='n')