##########################
## Perceptron with iris ##
##########################

# 1. Perceptron 
data(iris)
iris_sub = iris[c(1:50,101:150), c(1,3,5)]
names(iris_sub) = c('sepal','petal','species')
head(iris_sub)

euclidean.norm = function(x) {sqrt(sum(x*x))}
distance.from.plane = function(z,w,b) { sum(z*w)+b }
classify.linear = function(x,w,b){
  distances = apply(x,1,distance.from.plane, w, b)
  return(ifelse(distances<0, -1, +1))
}

perceptron = function(x,y,lr){
  w = c(0,0)
  b = 0
  k = 0
  R = max(apply(x,1,euclidean.norm))
  mark.complete = TRUE
  
  while (mark.complete) {
    mark.complete=FALSE
    yc = classify.linear(x,w,b)
    for (i in 1:nrow(x)) {
      if (y[i] != yc[i]) {
        w = w+lr*y[i]*x[i,]
        b = b+lr*y[i]*R^2
        k = k+1
        mark.complete= TRUE
      }
    }
  }
  return(list(w,b,k))
}


# 2. showing results
x = iris_sub[,c(1,2)]
y = ifelse(iris_sub[,3]=='setosa',-1,1)
lr = 0.3
results = perceptron(x,y,lr)
results
# estimated weight : (sepal) -51.27 / (petal) -357.54
# estimated bias : 1031.328
# number of iters : 964


# 3. Plotting a linear classifier
a=unlist(results)[1]
b=unlist(results)[2] 
c=unlist(results)[3]

library(ggplot2)
ggplot(iris_sub,aes(x=sepal, y=petal)) + geom_point(aes(colour=species, shape=species),size=3)+
  geom_abline(intercept =-(c/b), slope = -(a/b), col = "red")+
  xlab('sepal length') + ylab('petal length') + ggtitle('Species vs Sepal&Petal Length')

