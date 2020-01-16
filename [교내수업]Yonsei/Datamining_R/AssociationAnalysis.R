setwd('C:\\Users\\samsung\\Desktop\\연세대\\2019.2학기\\경영\\데마')

fp.df = read.csv('Faceplate.csv')
fp.mat = as.matrix(fp.df[,-1])
library(arules)
fp.trans = as(fp.mat,'transactions')
inspect(fp.trans)
itemFrequencyPlot(fp.trans)

# get rules
rules = apriori(fp.trans, parameter=list(supp=0.2, conf=0.5, target='rules'))

inspect(rules)
inspect(sort(rules,by='lift'))
insepct(head(sort(rules,by='lift'),n=6))

freq = apriori(fp.trans, parameter=list(supp=0=0.2, target='frequent itemsets'))
inspect(freq)
inspect(sort(freq,by='support'),decreasing=TRUE)

rules1 = apriori(fp.trans, parameter=list(supp=0.02, conf=0.5, minlen=2, target='rules'))
inspect(sort(rules1,by='lift'),decreasing=TRUE)

###########################################

all.books.df = read.csv('CharlesBookclub.csv')
count.books.df = all.books.df[,8:18]
summary(count.books.df)

incid.books.df = ifelse(count.books.df>0,1,0)
incid.books.mat = as.matrix(incid.books.df)
books.trans = as(incid.books.mat, 'transactions')
itemFrequencyPlot(books.trans)

rules = apriori(books.trans,
                parameter=list(supp=200/4000, conf=0.5, target='rules'))
inspect(sort(rules,by='lift'))
