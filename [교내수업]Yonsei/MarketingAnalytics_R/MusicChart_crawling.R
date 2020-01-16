#####################################
### Making an own Billboard Chart ###
#####################################

library(rvest)
library(RCurl)
library(stringr)
library(magrittr)

billboard2 = data.frame(matrix(0,ncol=31,nrow=100))

for (i in seq(1,31)){
  if (i<10){
    url = paste("https://www.billboard.com/charts/Hot-100/2018-12-0",i,sep='')
  } else {
    url = paste("https://www.billboard.com/charts/Hot-100/2018-12-",i,sep='')
  }
  bb = read_html(url) 
  chart = html_nodes(bb, css='.chart-list-item__title-text')%>% html_text()
  for (j in seq(1,100)){
    x = gsub("\r", "", chart[j])
    x = strsplit(x,'\\n')[[1]][2]
    billboard2[j,i] = x
  }
}

billboard2$weight = seq(100,1)
dim(billboard2)
colnames(billboard2)

library(questionr)

a = data.frame(wtd.table(billboard2$X3,weights=billboard2$weight))
b = data.frame(wtd.table(billboard2$X6,weights=billboard2$weight))
c = data.frame(wtd.table(billboard2$X9,weights=billboard2$weight))
d = data.frame(wtd.table(billboard2$X12,weights=billboard2$weight))
e = data.frame(wtd.table(billboard2$X15,weights=billboard2$weight))
f = data.frame(wtd.table(billboard2$X18,weights=billboard2$weight))
g = data.frame(wtd.table(billboard2$X21,weights=billboard2$weight))
h = data.frame(wtd.table(billboard2$X24,weights=billboard2$weight))
i = data.frame(wtd.table(billboard2$X27,weights=billboard2$weight))
j = data.frame(wtd.table(billboard2$X30,weights=billboard2$weight))

library(dplyr)
df <- bind_rows(a,b,c,d,e,f,g,h,i,j) %>%
  group_by(Var1) %>%
  summarise_all(funs(sum))

df = data.frame(df)

TOP100 = df[order(df$Freq,decreasing=TRUE),][1:100,]
TOP100$rank = c(1:dim(TOP100)[1])
head(TOP100,10)
