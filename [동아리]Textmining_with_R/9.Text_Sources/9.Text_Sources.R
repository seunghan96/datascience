# (1) 필요한 rvest 라이브러리 불러오기
library(rvest)  

# (2) 크롤링할 url 읽어오기 (single page)
url<-'http://www.amazon.com/gp/help/customer/forums/ ref=cs_hc_g_tv?i.e.=UTF8&forumID=Fx1SKFFP8U1B6N5&cdThr ead=Tx3JJLVOS6N6YSD' 
page<-read_html(url)
# 필요+불필요 정보 다 섞여있어서 골라내야!

# Chrome extension called “SelectorGadget.” It is available at www.selectorgadget.com
# Chrome 우측 상단에 새로운 팝업 생김 -> 돋보기 click
# (3) 
posts<-html_nodes(page, '.thread-body') 
forum.posts<-html_text(posts)
# 이러면 4개의 post만 extract하게 됨!

# XPath는 web link를 가져와
# 하지만 너무 많은 link를 가져오게 됨....

# grep 이용해서 (정규표현식) 일부만 가져오게끔!
# 150개의 link 중, 19.26.34.42 총 4개의 link만을 불러옴

# (4)
# 스크래핑 된 문서의 어디든 : "//"
# 모든(all)" 링크를 가져오기 때문에 : "a"
links<-html_nodes(page,xpath='//a') 

# Permalink 골라내기 ( 고유한 link )
thread.urls<-grep("*Permalink*", links) 

# href 특성 가진 것들
thread.urls<-html_attr(links,"href")[thread.urls] 

# www.amazon.com뒤에 붙여넣어
thread.urls<-paste0('www.amazon.com',thread.urls)


# (5)
# 작가의 이름을 가져오고 싶으면
profile<-grep("*profile*", links) 
# ( To get author names, pass in the links, indexed by “profile”, into “html_text.”)
# ( The “authors” object extracts the author’s screenname, since the name is the text associated with each link)
authors<-html_text(links[profile]) 
author.profiles<-html_attr(links,"href")[profile] 
author.profiles<-paste0('www.amazon.com',author. profiles) 

# (6) dataframe
final.df<- data.frame(forum_post = forum.posts,
                      author = authors,
                      author_urls = author.profiles,
                      thread_urls = thread.urls)

#################################################################################################################

# (7) Multiple Page를 가져오기
# (rvest 이용해서)
library(rvest) 
library(pbapply) 
library(data.table)

# 40개의 page에서 각각 25개의 Topic URL 가져오기
forum.urls <- paste0('http://www.amazon.com/gp/help/customer/forums/ref=cs_hc_g_pg_pg40?i.e.=UTF8&forumID=Fx1 SKFFP8U1B6N5&cdPage=', seq(1:40))

# 각각의 40개의 page를 url_get 함수에 넣으면, conversation 끌어와
url.get<-function(x){page<-read_html(x)  
                     links<-html_nodes(page,xpath="//table[@class='a-bordered thread-list-table']//td/a/@href")  
                     links<-html_text(links)  
                     links<-paste0('http://www.amazon.com',links) }

# 총 1000개의 url이 있을 것
all.urls<-pblapply(forum.urls,url.get) 
all.urls<-unlist(all.urls)

# (1000개의 link) 링크 각각을 밑에 함수에 적용!
forum.scrape<-function(x){page<-read_html(x)  
                          posts<-html_nodes(page, '.thread-body')  
                          forum.posts<-html_text(posts)  
                          links<-html_nodes(page,xpath='//a')  
                          thread.urls<-grep("*Permalink*", links)  
                          thread.urls<-html_attr(links,"href")[thread.urls]  
                          thread.urls<-paste0('amazon.com',thread.urls)  
                          profile<-grep("*profile*", links)  
                          authors<-html_text(links[profile])  
                          author.profiles<-html_attr(links,"href")[profile]  
                          author.profiles<-paste0('amazon.com',author. profiles)  
                          final.df<-data.table(authors, author.profiles, forum.posts, thread.urls)  
                          return(final.df)} 

amzn.forum<-pblapply(all.urls,forum.scrape)

# 행으로 합치기
amzn.forum<-rbindlist(amzn.forum, use.names=TRUE)


###############################

all.urls<-paste0('https://bitcointalk.org/index.php?to pic=976903.',seq(0,5040,by=20))

forum.scrape<-function(forum.url){  
                          x<-read_html(forum.url)  
                          Sys.sleep(1)  
                          posts<-x%>%html_nodes(".post")%>%html_text()%>%as.character()  
                          posts<-paste(posts, collapse='')  
                          return(posts)}

all.posts<-pblapply(all.urls,forum.scrape) 
bitcoin<-do.call(rbind,all.posts)

###################################
# Guardian
# API에 접근하려면, key필요해!
# https://bonobo.capi.gutools.co.uk/register/developer

library(GuardianR)
library(qdap) 

# 자신의 key 입력
key<-'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx' 

# 해당 날짜 범위 안에 있는 'brexit'라는 단어를 찾아냄
text <- get_guardian("Brexit", from.date="2016-0701",to.date="2016-07-06",api.key=key)

# text$body는 article을 담고 있음

# iconv로 string conversion (latin1 -> ASCII)
body<-iconv(text$body, "latin1", "ASCII", sub="") 

# "http"없애기
body<-gsub('http\\S+\\s*', '',body) 

# bracketX로 < & > (HTML tag) 없애기
body<-bracketX(body, bracket="all") 

# DataFrame 형식으로
text.body<-data.frame(id=text$id,text=body)