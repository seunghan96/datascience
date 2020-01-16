library(LICORS)
sswplot <- function(data, nc=10, seed=1234){  #nc: 시뮬레이션 군집 수
  ssw_data<-data.frame(group=1:nc,ssw=NA ,ssw2=NA)
  ssw_data[1,2:3] <- (nrow(data)-1)*sum(apply(data,2,var)) 
  
  for (i in 2:nc){
    set.seed(seed)
    ssw_data$ssw[i] <- kmeans(data, centers=i)$tot.withinss
    ssw_data$ssw2[i] <- kmeanspp(data, k=i )$tot.withinss}
  
  ggplot()+
    geom_line(data=ssw_data,aes(group,ssw,colour='black'))+
    geom_line(data=ssw_data,aes(group,ssw2,colour='red'))+
    labs(x='군집의 수',y='군비 내 변동 총합')+
    ggtitle('K-means vs K-means++ : SSW')+
    scale_color_discrete(name = "K-means line", labels = c('K-means', 'K-means++'))}


setwd("C:\\Users\\samsung\\Desktop\\Bitamin\\Machine Learning with R\\9장")
crime <- read.csv("crime.csv",stringsAsFactors=F)

crime <- na.omit(crime)
crime_z <- as.data.frame(lapply(crime[-1],scale))


library(NbClust)
set.seed(1234)
Nb <- NbClust(crime_z,method='kmeans',max.nc=10) # 2개가 적합한 cluster의 수!

set.seed(1234)
A <- kmeans(crime_z,centers=2)
A
A$size
A$centers
aggregate(crime[-1],by=list(cluster=A$cluster),mean)

plot(crime_z[1:2],col=A$cluster)
points(A$centers[,1:2],col=4:6,pch=8,cex=2)

sp <- scatterplot(crime_z,color=A$cluster, type='p',pch=A$cluster)
sp$points3d(A$centers,pch=8,cex=2,col=4:6)

pairs(crime[-1],col=A$cluster,pch=A$cluster)


library(car)
UN <- na.omit(UN)

UN_z <- as.data.frame(lapply(UN[3:7],scale))


library(NbClust)
set.seed(1234)
Nb <- NbClust(UN_z,method='kmeans',max.nc=10) # 3개가 적합한 cluster의 수!

ssw <- (nrow(UN_z)-1)*sum(apply(UN_z,2,var))
for (i in 2:10) {
  set.seed(1234)
  ssw[i] <- kmeans(UN_z,centers=i)$tot.withinss
}

par(mfrow=c(1,1))
plot(1:10,ssw,type="b",xlab='군집의 수',ylab='군집 내 변동 총합 : 이질성',main='k-means')

for (i in 2:10) {
  set.seed(1234)
  ssw[i] <- kmeanspp(UN_z,k=i)$tot.withinss
}
lines(1:10,ssw,type='b',col='red')
legend(x="topright",legend=c('k-means','k-means++'),lty=2,col=c('black','red'))

set.seed(1234)
a <- kmeans(UN_z,centers=3)
set.seed(1234)
b <- kmeanspp(UN_z,k=3)
a$iter # 2
b$iter # 2

b$size
b$centers
aggregate(UN[3:7],by=list(cluster=b$cluster),mean)

plot(UN_z[1:2],col=b$cluster)
points(b$centers[,1:2],col=4:6,pch=8,cex=2)

sp <- scatterplot(UN_z,color=b$cluster, type='p',pch=A$cluster)
sp$points3d(b$centers,pch=8,cex=2,col=4:6)

pairs(crime[3:7],col=b$cluster,pch=b$cluster)