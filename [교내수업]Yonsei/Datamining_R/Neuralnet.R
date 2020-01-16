library(neuralnet)

###########################
##### Tiny Dataset ########
###########################
tiny.df = data.frame(obs=c(1:6),
                     Fat=c(0.2,0.1,0.2,0.2,0.4,0.3),
                     Salt=c(0.9,0.1,0.4,0.5,0.5,0.8),
                     Acceptance=c('like','dislike','dislike','dislike','like','like'))

tiny.df$Like = tiny.df$Acceptance=='like'
tiny.df$Dislike = tiny.df$Acceptance=='dislike'

tiny.nn = neuralnet(Like+Dislike ~ Salt+Fat, data=tiny.df,
                    linear.output = F, hidden=3)
plot(tiny.nn)
tiny.nn$weights
tiny.nn_predict = compute(tiny.nn, data.frame(tiny.df$Salt, tiny.df$Fat))

tiny.nn_predict$net.result
tiny.predicted.class = apply(tiny.nn_predict$net.result, 1, which.max)-1
tiny.predicted.class

library(caret)
confusionMatrix(factor(ifelse(tiny.predicted.class=='1','dislike','like')),tiny.df$Acceptance)

#########################################
##### Classifying Accident Severity #####
#########################################

# import data
setwd('C:\\Users\\samsung\\Desktop\\연세대\\2019.2학기\\경영\\데마')
accidents.df = read.csv('accidentsnn_ch11_size999.csv',na.strings="")
vars = c("ALCHL_I","PROFIL_I_R",'VEH_INVL')

# train/test split
set.seed(2)
train.index = sample(rownames(accidents.df),dim(accidents.df)[1]*0.6)
valid.index = setdiff(rownames(accidents.df),train.index)

# combine
library(nnet)
train = cbind(accidents.df[train.index,vars],
              class.ind(accidents.df[train.index,]$SUR_COND),
              class.ind(accidents.df[train.index,]$MAX_SEV_IR))
names(train) = c(vars,paste('SUR_COND_',c(1,2,3,4,9),sep=""),
                 paste('MAX_SEV_IR_',c(0,1,2),sep=""))
head(train)

valid = cbind(accidents.df[valid.index,vars],
              class.ind(accidents.df[valid.index,]$SUR_COND),
              class.ind(accidents.df[valid.index,]$MAX_SEV_IR))
names(valid) = c(vars,paste('SUR_COND_',c(1,2,3,4,9),sep=""),
                 paste('MAX_SEV_IR_',c(0,1,2),sep=""))
head(valid)

# Modeling
nn1 = neuralnet(MAX_SEV_IR_O + MAX_SEV_IR_1 + MAX_SEV_IR_2 ~
                  ALCHL_I + PROFIL_I_R + VEH_INVL + SUR_COND_1 + SUR_COND_2
                + SUR_COND_3 + SUR_COND_4, data=train,hidden=2)
plot(nn1)

nn2 = neuralnet(MAX_SEV_IR_O + MAX_SEV_IR_1 + MAX_SEV_IR_2 ~
                  ALCHL_I + PROFIL_I_R + VEH_INVL + SUR_COND_1 + SUR_COND_2
                + SUR_COND_3 + SUR_COND_4, data=train,hidden=c(2,2))
plot(nn2)

## evaluation
# (1) train dataset
train.pred = compute(nn1,train[,-c(8:11)])
train.pred$net.result
train.class = apply(train.pred$netresult, 1, which.max)-1
head(train.class, n=20)

confusionMatrix(factor(train.class),factor(accidents.df[train.index,]$MAX_SEV_IR))
class(train.class)
class(accidents.df$MAX_SEV_IR)

# (2) valid dataset
valid.pred = compute(nn1,valid[,-c(8:11)])
valid.pred$net.result
valid.class = apply(valid.pred$netresult, 1, which.max)-1
head(valid.class, n=20)

confusionMatrix(factor(valid.class),factor(accidents.df[valid.index,]$MAX_SEV_IR))
class(valid.class)
class(accidents.df$MAX_SEV_IR)