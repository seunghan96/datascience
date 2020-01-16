####################################
### FIFA players pca & clustering ##
####################################

### Q1 ###
# 1. make correlation matrix with numeric features
cor_mat = cor(fifa[,-c(1,2,3)])

# 2. take 5 factors
# ( filtering by selecting factors with eigen values bigger than 1)
# those 5 factors has 83.5% explained variance ration
ev = eigen(cor_mat)
ev$values[ev$values>1]
cumsum(ev$values/length(ev$values))[1:5]
windows()
plot(cumsum(ev$values/length(ev$values)))

# 3. Fitting FA and assess model fit
fit = factanal(fifa[,-c(1,2,3)], 5, rotation="varimax", scores="regression") 
print(fit$loadings, digits=2, cutoff=.4, sort=TRUE)
# explained variance ratio is different from the above (83.5% vs 80%)
# ( it is just due to the rotation! )
flm = as.matrix(fit$loadings[1:38,])
apply(flm^2,2,sum) # Eigenvalue = How many variables Factor i explains

# 4. Naming Each Factors
# Factor 1 : BASIC
# (+) basic soccer skillss ( dribble, ball control, etc )
# Factor 2 : DEFENSE
# (+) "Defense" skills
# Factor 3 : GOALKEEPING
# (-) "Goal Keeping" skills
# Factor 4 : PHYSICAL
# (+) Physical Abilities ( Height, Weight, ...)
# Factor 5 : SPEED
# (+) Speed


### Q2 ###
bp = data.frame(fifa,fit$scores)
cor(fit$scores) # uncorrelated
names(bp)[42:46] = c("Basic","Defense","Goalkeeping","Physical","Speed")
newdata=bp[42:46]

# Goalkeeping feature : how they do NOT do well in goal keeping
# change the direction of the factor!
newdata$Goalkeeping = -newdata$Goalkeeping

## K-means
k_number<-NULL
for (i in 2:10){
  set.seed(48167)
  k_number<-c(k_number,kmeans(newdata,centers=i)$tot.withinss) 
}
plot(2:10,k_number,type="b") ## I would go with 5 segments

set.seed(48167)
clus5 = kmeans(newdata, 5)

clus5$centers # Center of each cluster
table(clus5$cluster)

newdata$kmean=clus5$cluster
newdata$id = fifa$Name
head(newdata)

plot(newdata$Basic,newdata$Defense,type="n",xlab="Basic Skills",ylab="Defense")
text(newdata$Basic[newdata$kmean==1],newdata$Defense[newdata$kmean==1],labels=newdata$id[newdata$kmean==1],cex=.1,col=1)
text(newdata$Basic[newdata$kmean==2],newdata$Defense[newdata$kmean==2],labels=newdata$id[newdata$kmean==2],cex=.1,col=2)
text(newdata$Basic[newdata$kmean==3],newdata$Defense[newdata$kmean==3],labels=newdata$id[newdata$kmean==3],cex=.1,col=3)
text(newdata$Basic[newdata$kmean==4],newdata$Defense[newdata$kmean==4],labels=newdata$id[newdata$kmean==4],cex=.1,col=4)
text(newdata$Basic[newdata$kmean==5],newdata$Defense[newdata$kmean==5],labels=newdata$id[newdata$kmean==5],cex=.1,col=5)

legend("topleft",c("에이스","동네축구","평범선수","수비형",'공격형'),pch=8,col=c(1,2,3,4,5))

c1 = newdata[newdata$kmean==1,]
c2 = newdata[newdata$kmean==2,]
c3 = newdata[newdata$kmean==3,]
c4 = newdata[newdata$kmean==4,]
c5 = newdata[newdata$kmean==5,]

total = merge(newdata,fifa[,c(1,4)],by.x='id',by.y='Name')
total1 = total[total$kmean==1,]
total2 = total[total$kmean==2,]
total3 = total[total$kmean==3,]
total4 = total[total$kmean==4,]
total5 = total[total$kmean==5,]

tail(total1[order(total1$Rating),],1)
tail(total2[order(total2$Rating),],1)
tail(total3[order(total3$Rating),],1)
tail(total4[order(total4$Rating),],1)
tail(total5[order(total5$Rating),],1)