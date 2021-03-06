# Chapter 2. Text Mining Basics

# Set Options
options(stringsAsFactors=F)
Sys.setlocale('LC_ALL','C')

library(stringi)
library(stringr)
library(qdap)

# nchar : number of characters in string ( space도 포함 )
text.df <- read.csv('C:\\Users\\samsung\\Desktop\\Bitamin\\Textmining with R\\2장. Basics of Text Mining\\oct_delta.csv')
str(text.df)
head(text.df$text)

nchar(head(text.df$text))
nchar(text.df[4,5])
mean(nchar(text.df$text)) 

# omit strings with a length equal to 0
subset.doc <- subset(text.df, nchar(text.df$text)>0)

# sub : 단어 A->B replace하기
sub('thanks','thank you', text.df[1,5], ignore.case=T)
sub('pls','please',text.df[1:5,5], ignore.case=F)

fake.text <- 'R text mining is good but text mining in python is also'
sub('text mining','tm',fake.text, ignore.case=F)

# gsub : (sub는 first pattern만 바꾸지만, gsub는 다 바꿈)
gsub('text mining','tm',fake.text,ignore.case=F)
gsub('&amp','',text.df[5,5])     # & = '&amp'
gsub('[[:punct:]]','',text.df[1:5,5])

# qdap
library(qdap)
patterns <- c('good','also','text mining')
replacements <- c('great','just as suitable','tm')
mgsub(patterns, replacements, fake.text)   # 더 효율적이다!

# paste
patterns <- month.abb
replacements <- seq(1:12)

text.df$month <- mgsub(patterns, replacements, text.df$month)
head(text.df$month)

text.df$combined <- paste(text.df$month, text.df$date, text.df$year, sep='-')
head(text.df$combined)

# lubridate ( swith the newly created dates into an official date format )
library(lubridate)
text.df$combined <- mdy(text.df$combined) # month-day-year 순으로 바꾸기
head(text.df$combined)

text.df$text[1:2]  # 두번째에 AA가 붙음... 분리 시키는 법?
agents <- strsplit(text.df$text,'[*]')
agents[1:2]

# substring
substring('R text mining is great', 18,22)
last.chars <- function(text,num) {
  last <- substr(text, nchar(text)-num+1, nchar(text))
  return(last)
}

last.chars('R text mining is great',5)
last.chars(text.df$text[1:2], 2)

# table (categorial factors로 보기 위해)
weekdays <- subset(text.df, text.df$combined>=mdy('10-05-2015') & text.df$combined<=mdy('10-09-2015')) # 10/5~10/9것만 추출
table(as.factor(last.chars(weekdays$text,2)))  # 결과값 : table summary of last 2 characters

# grep ( global regular expression print ) ---> 열number 반환
# ( return the position of the searched pattern )
grep('sorry', text.df$text, ignore.case=T) # 'sorry'라는 단어가 들어간 text의 열들은?
text.df$text[413] # 413열에도 있다!

# grepl ( 비슷하지만, return되는 값은 다름 ) ---> T/F값으로 반환
sorry <- grepl('sorry', text.df$text, ignore.case=T)
sum(sorry) / nrow(text.df) # 특정 단어가 포함되어 있는 비율

# grep / grepl 응용
grep(c('sorry|apologize'), text.df$text, ignore.case=T) # sorry OR apologize 단어 들어간 열 number
sum(grepl('http',text.df$text, ignore.case=T)) / nrow(text.df) # 4%의 비율로 'http'가 들어감
sum(grepl('[0-9]{3}|[0-9]{4}', text.df$text)) / nrow(text.df)

# stringi / string r
library(stringi)
stri_count(text.df$text, fixed='http') # text에 'http'라는 단어가 있으면 1, 없으면 0
library(stringr)
str_detect(text.df$text, 'http')  # text에 'http'라는 단어가 있으면 TRUE, 없으면 FALSE

# 두개의 패턴이 동시에 있는지 알아보려면
patterns <- with(text.df, str_detect(text.df$text,'http') & str_detect(text.df$text,'DM'))
text.df[patterns,5]

# 전처리
options(stringsAsFactors=FALSE)
Sys.setlocale('LC_ALL','C')
library(tm)
library(stringi)

tweets <- data.frame(doc_id=seq(1:nrow(text.df)), text=text.df$text)

tryTolower <- function (x) {
  y=NA # return NA (에러 있으면)
  try_error = tryCatch(tolower(x), error=function(e) e) # try Catch error
  if(!inherits(try_error,'error')) # if not error
    y=tolower(x)
  return(y)
}

custom.stopwords <- c(stopwords('english'), 'lol','smh','delta')

clean.corpus <- function(corpus) {
  corpus <- tm_map(corpus, content_transformer(tryTolower))
  corpus <- tm_map(corpus, removeWords, custom.stopwords)
  corpus <- tm_map(corpus, removePunctuation)
  corpus <- tm_map(corpus, stripWhitespace)
  corpus <- tm_map(corpus, removeNumbers)
  return(corpus)
}

corpus <- VCorpus(DataframeSource(tweets))
corpus <- clean.corpus(corpus)
as.list(corpus)[1]

# spellcheck
tm.definition <- 'Txt mining is the process of distilling actionable insyghts from text.'
which_misspelled(tm.definition) # find misspelled words 

check_spelling_interactive(tm.definition)  # correction choice

# 한번에 여러개 고치기
fix.text <- function(myStr) {
  check <- check_spelling(myStr)
  splitted <- strsplit(myStr,split=' ')
  for (i in 1:length(check$row)) {
    splitted[[check$row[i]]][as.numeric(check$word.no[i])]=check$suggestion[i]
  }
  df <- unlist(lapply(splitted, function(x) paste(x,collapse=' ')))
  return(df)
}

fix.text(tm.definition)


# frequent terms
tdm <- TermDocumentMatrix(corpus, control=list(weighting=weightTf))
tdm.tweets.m <- as.matrix(tdm)
dim(tdm.tweets.m)
tdm.tweets.m[2250:2255,1340:1342]

term.freq <- rowSums(tdm.tweets.m)
freq.df <- data.frame(word=names(term.freq), frequency=term.freq)
freq.df <- freq.df[order(freq.df[,2], decreasing=T),]
freq.df[1:10,]
