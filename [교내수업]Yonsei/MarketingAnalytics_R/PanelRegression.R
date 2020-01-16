#############################
#### Panel Regression #######
#############################

# Making Dataset
# x1 : types of food ( 0 for rice noodle , 1 for japanes ramen )
# x2 : price of food
# x3 : alcohol ( 0 for not selling, 1 for selling )
# x4 : gender ( 0 for male, 1 for female)
# y : willingness to visit

data = data.frame(id=rep(c(1,2,3,4,5,6),each=8),
                  x1=rep(c(rep(0,4),rep(1,4)),6),
                  x2=rep(c(rep(c(8000,8000,12000,12000),2)),6),
                  x3=rep(c(rep(c(0,1),4)),6),
                  x4=c(rep(0,24),rep(1,24)),
                  y=c(6,5,5,4,7,6,5,6,
                      7,6,5,5,5,6,4,4,
                      5,6,3,3,6,5,4,2,
                      6,4,3,2,7,6,3,3,
                      6,7,5,4,5,6,4,4,
                      6,6,4,5,6,7,3,4))

head(data)

#################
### Part 1-1) ###
#################

# H0 : drivers of sales differ between "male & female"
# H1 : drivers of sales doesn't differ between "male & female"

# total 6 people's willingnies
table(data$y)
hist(data$y)

# male & female's (24 people) willingness
male = data[data$x4==0,]
female = data[data$x4==1,]

table(male$y)
hist(male$y)

table(female$y)
hist(female$y)


#################
### Part 1-2) ###
#################

model1 = lm(y~x4*(x1+x2+x3),data)
model2 = lm(y~x4+(x1+x2+x3),data)
summary(model1)
summary(model2)

anova(model1,model2)


#################
### Part 2-1) ###
#################

# 2 case for showing INDIVIDUALITY
## 1) FE Model
## 2) Individual Regression

####### Case 1) FE model #############
# since other features (x4 is gender -> time(place)-invarying -> no need to put in the model below )
model3 = lm(y~as.factor(id)+x1+x2+x3,data)
summary(model3)

# Make a function that gets inputs and output as...
# input : (1) id, (2) x1 : types of food(0,1), (3) x2 : price of food, (4) x3 : selling alcohol(0,1)
# output : y : willingness to revisit

FE_prediction = function(id,x1,x2,x3){
  coef_x = coef(model3)[1] + coef(model3)[7]*x1 + coef(model3)[8]*x2 + coef(model3)[9]*x3
  if (id==1){
    y = coef_x} 
  else {
    y = coef_x + coef(model3)[id]}
  return(y)
}

# Making an example for 'people with id 1' using FE MODEL
# restaurant 1~8
# actual values & predicted values of willingness to revisit
id1_r1 = FE_prediction(1,0,8000,0)
id1_r2 = FE_prediction(1,0,8000,1)
id1_r3 = FE_prediction(1,0,12000,0)
id1_r4 = FE_prediction(1,0,12000,1)
id1_r5 = FE_prediction(1,1,8000,0)
id1_r6 = FE_prediction(1,1,8000,1)
id1_r7 = FE_prediction(1,1,12000,0)
id1_r8 = FE_prediction(1,1,12000,1)

data.frame(predicted=c(id1_r1,id1_r2,id1_r3,id1_r4,id1_r5,id1_r6,id1_r7,id1_r8),
           actual=head(data,8)$y)


####### Case 2) Individual model #############

par = NULL

for (i in 1:6){
  par0 = coef(lm(y~x1+x2+x3,data=data[data$id==i,]))
  par = rbind(par,par0)
  print(i)
}


INDIV_pred = function(id,x1,x2,x3){
  y_pred = par[id,][1]*1 + par[id,][2]*x1 + par[id,][3]*x2 + par[id,][4]*x3
  return(y_pred)
}

# Making an example for 'people with id 1' using INDIVIDUAL MODEL
# restaurant 1~8
# actual values & predicted values of willingness to revisit

id1_r1 = INDIV_pred(1,0,8000,0)
id1_r2 = INDIV_pred(1,0,8000,1)
id1_r3 = INDIV_pred(1,0,12000,0)
id1_r4 = INDIV_pred(1,0,12000,1)
id1_r5 = INDIV_pred(1,1,8000,0)
id1_r6 = INDIV_pred(1,1,8000,1)
id1_r7 = INDIV_pred(1,1,12000,0)
id1_r8 = INDIV_pred(1,1,12000,1)

data.frame(predicted=c(id1_r1,id1_r2,id1_r3,id1_r4,id1_r5,id1_r6,id1_r7,id1_r8),
           actual=head(data,8)$y)

## Visualizing coeffecients
dev.new(width=12,height=6) 
par(mfrow=c(1,4))
plot(par[,1],main="intercept")
plot(par[,2],main='x1')
plot(par[,2],main='x2')
plot(par[,2],main='x3')


#################
### Part 2-2) ###
#################

# function 'rest_score'
# ( restaurant's score = willingness to revisit by the customers )

# input : (1) x1 : type of food, (2) x2 : price of food, (3) x3 : selling alcohol
# output : willingness to visit from 6 customers

rest_score= function(x1,x2,x3){
  y = NULL
  for (id in c(1:6)){
    y[id] = INDIV_pred(id,x1,x2,x3)} 
  return(y)}

# rice noodle + 8,000 won + alcohol (O)
rest_score(0,8000,1)
restaurant1 = mean(rest_score(0,8000,1))
restaurant1

# japanese ramen + 12,000 won + alcohol (X)
rest_score(1,12000,0)
restaurant2 = mean(rest_score(1,12000,0))
restaurant2

## Market Share ##
# Assumption : people will visit the restaurant by the ratio of the willingness to revisit!
# Since the average willingness score by 6 people ( who represent the whole population )...
# we can say that people visit restaurant 1 and restaurant 2 by the ratio of 5.83 : 4 ( calculated above )

# price consideration (X) --- only considering the number of customers
ms1 = round(restaurant1 / (restaurant1+restaurant2),2)
ms2 = round(restaurant2 / (restaurant1+restaurant2),2)

# price consideration (O)
ms3 = round(restaurant1*8000 / (restaurant1*8000 + restaurant2*12000),2)
ms4 = round(restaurant2*12000 / (restaurant1*8000 + restaurant2*12000),2)


### VISUALIZATION ##

MS_priceX = c(ms1,ms2)
MS_priceO = c(ms3,ms4)
labels = c('restaurant 1','restaurant 2')

# Plot the chart.
piepercent1 = round(100*MS_priceX/sum(MS_priceX), 1)
pie(MS_priceX,labels=piepercent1,main='Market Share (price unconsidered)',col=rainbow(length(MS_priceX)))
legend("topright", c("restaurant1","restaurant2"), cex = 0.8,fill = rainbow(length(MS_priceX)))

piepercent2 = round(100*MS_priceX/sum(MS_priceX), 1)
pie(MS_priceO,labels=piepercent2,main='Market Share (price considered)',col=rainbow(length(MS_priceO)))
legend("topright", c("restaurant1","restaurant2"), cex = 0.8,fill = rainbow(length(MS_priceO)))
