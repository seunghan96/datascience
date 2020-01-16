#################################
#### Walmart Sales Management ###
#################################
# FINAL PROJECT


setwd('C:\\Users\\samsung\\Desktop\\연세대\\2019.2학기\\경영\\마틱스\\final project 2')

##############################
## 1. Import three datasets ##
##############################

## 1) store : store information ( Type of store & Size of store )
## 2) sales : sales of departments of every stores
## 3) features : Temperature, Fuel Price, CPI, Unemployment Rate, Holiday Y/N for every store location & every week

store = read.csv('stores.csv')
sales = read.csv('train.csv')
features = read.csv('features.csv')

# change datatype of some columns
head(sales)
tail(sales)
str(sales)
dim(sales)

sales$Store = as.factor(sales$Store)
sales$Dept = as.factor(sales$Dept)

head(store)
str(store)
dim(store)
store$Store = as.factor(store$Store)

head(features)
str(features)
dim(features)
features$Store = as.factor(features$Store)

######################################
## 2. Merge three datasets into one ##
######################################
data = merge(sales,features[c(1,2,3,4,10,11,12)],by=c('Store','Date'))
data = merge(data, store,by=c('Store'))
head(data)
dim(data)

#############
## 3. EDA ###
#############

# every store has similiar proportion in the dataset
sort(prop.table(table(data$Store))) 

# we can know that the 'type' of the store heavliy relies on 'Size' of the store
store = store[order(-store$Size),] 
store 

# we will only make model based on the "Top 10 size store"
barplot(store$Size,
        main = "Size of Each Store",
        xlab = "Size",
        ylab = "Store ID",
        names.arg = store$Store,
        col = store$Type,
        horiz = TRUE
        )

# Relationship between (1) "Size" & (2) "mean Sales" of the store
library(dplyr)
sales.mean.by.store = data %>% group_by(Store) %>% summarize(mean_sales = mean(Weekly_Sales, na.rm = TRUE))
sales.mean.by.store = data.frame(sales.mean.by.store)
sales.size.corr = merge(sales.mean.by.store, unique(data[c(1,12)]), by=c('Store'))
head(sales.size.corr)

# How about giving solutions to the stores, which are not making enough Sales, on behalf of their large Size?
plot(x=sales.size.corr$Size, y=sales.size.corr$mean_sales,pch=20,cex=2,
     xlab='SIZE of the Store',
     ylab='SALES of the Store')

############################
## 4. Feature Extraction ###
############################

# which store is operating at the lowest efficiency?
# make a new feature, "ratio"
# ( ratio = Average Sales / Size )
# ( assumption : efficiency depends on the "sales-to-size ratio" )

sales.size.corr$ratio = sales.size.corr$mean_sales / sales.size.corr$Size
sales.size=sales.size.corr[order(sales.size.corr$ratio),]

# but, is it worth to make a solution based on a store, which has small Size & small Sales? NO!
# take the 10 LEAST EFFICIENT STORE, whose market size is at least bigger than the average of all the stores!
bad.eff.stores = sales.size[sales.size$Size>mean(sales.size$Size),][1:10,]
bad.eff.stores

########################
## 5. Final Dataset ####
########################
store.need.help = data[data$Store %in% bad.eff.stores$Store,]
dim(store.need.help)

# the sale heavily relies on "department" of the Store!
dept.sales = data.frame(store.need.help %>% group_by(Dept) %>% summarize(mean_sales = mean(Weekly_Sales, na.rm = TRUE)))
dept.sales = dept.sales[order(-dept.sales$mean_sales),]

finaldata = store.need.help[store.need.help$Dept %in% dept.sales[1:4,]$Dept,]
finaldata = finaldata[c(1,3,4,5,6,7,8,9,12)]

# checking Multicolinearity
# ( indexes that shows the trend of economy : CPI, Fuel_Price, Unemployment )
library(corrplot)
mydata.cor = cor(finaldata[c(3,5,6,7,8)], method = c("spearman"))
corrplot(mydata.cor)
cor(finaldata$Unemployment, finaldata$CPI)
cor(finaldata$Fuel_Price, finaldata$CPI)
cor(finaldata$Fuel_Price, finaldata$Unemployment)

### final data1 
### for Fixed Effect Model 
### give random effect according to the "Department" of the store
finaldata$IsHoliday.x = as.numeric(finaldata$IsHoliday.x)
head(finaldata)

### final data2 
### simple Linear Model
### make "Department" of store as dummmy variable
library(dummies)
finaldata2 = finaldata 
finaldata2 = cbind(finaldata2,dummy(finaldata2$Dept, sep=":"))
finaldata2 = finaldata2[,colSums(finaldata2!=0)>0][-c(2)]

head(finaldata)
head(finaldata2)

###################
## 6. Modeling ####
###################

### 1. Fixed Effect ####

finaldata$Weekly_Sales = scale(finaldata$Weekly_Sales)
finaldata$Temperature = scale(finaldata$Temperature)
finaldata$CPI = scale(finaldata$CPI)
finaldata$Size= scale(finaldata$Size)
head(finaldata)

## due to standard scaling, should becareful when interpreting the coefficients!
FEmodel = lm(Weekly_Sales ~as.factor(Dept)+IsHoliday.x+Temperature+Fuel_Price+CPI+Unemployment+Size, data=finaldata)
summary(FEmodel)


### 2. Linear Regression ####
head(finaldata2)

finaldata2$Weekly_Sales = scale(finaldata2$Weekly_Sales)
finaldata2$Temperature = scale(finaldata2$Temperature)
finaldata2$CPI = scale(finaldata2$CPI)
finaldata2$Size= scale(finaldata2$Size)

LRmodel = lm(Weekly_Sales ~ IsHoliday.x+Temperature+Fuel_Price+CPI+Unemployment+Size+
               finaldata2$`finaldata2:90` + finaldata2$`finaldata2:92` + finaldata2$`finaldata2:95`,data=finaldata2)
summary(LRmodel)
