##############
## MAROON 5 ##
##############
# 5songs
# 조 이름 : R유레디 

library(devtools)
library(tm)
library(stringr)

setwd('C:\\Users\\samsung\\Desktop\\연세대\\2019.2학기\\경영\\마틱스')
song = read.csv('maroon5.csv',sep='\n',fileEncoding='utf-8',header=FALSE)

x = VCorpus(VectorSource(song$V1))
x0 = x

x<-tm_map(x,removeNumbers) #Remove numbers
x<-tm_map(x,removeWords, stopwords("english")) #Remove stopwords
x<-tm_map(x,removePunctuation) #Remove punctuation
x<-tm_map(x,content_transformer(tolower)) #To lower cases
x<-tm_map(x,removeWords,c("here","there","finally","we","our","keep","coming")) 
x<-tm_map(x,stripWhitespace) # Remove white spaces

## STEP3. Making word matrix
x_mat = TermDocumentMatrix(x, control=list(tokenize="scan", wordLengths=c(2, 12)))  ## tokenize by blank, word lengths 2~12
x_mat0 = x_mat
x_mat = removeSparseTerms(x_mat, sparse=0.98) ## Theshold for sparse term: 2% have used
x_mat

library(wordcloud)
library(RColorBrewer)
x_tab=rowSums(as.matrix(x_mat))
x_tab=x_tab[order(x_tab,decreasing=TRUE)]
x_tab0=x_tab ## Keep the original properly
n=length(x_tab)
windows()
palete <- brewer.pal(7,"Set2") ## Setting the color
wordcloud(names(x_tab),freq=x_tab,scale=c(5,1),rot.per=0.25,min.freq=4,random.order=F,random.color=F,colors=palete)

