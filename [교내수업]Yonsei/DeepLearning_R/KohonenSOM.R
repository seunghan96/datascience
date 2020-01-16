###################################
##### SOM with wine dataset #######
###################################

library("kohonen")
data("wines")
str(wines)
head(wines)
dim(wines)

# train(150) test(27) split
training = sample(nrow(wines), 150)
Xtraining = scale(wines[training, ])
Xtest = scale(wines[-training, ],
              center = attr(Xtraining, "scaled:center"),
              scale = attr(Xtraining, "scaled:scale"))
trainingdata = list(measurements = Xtraining, vintages = vintages[training])
testdata = list(measurements = Xtest, vintages = vintages[-training])

# 2 X 2
# Conclusion : Since there is not much cluster, the error doesn't seems to get much smaller 
set.seed(1)
som.wines = som(scale(wines), grid = somgrid(2, 2, "hexagonal"))
par(mfrow = c(1, 2))
plot(som.wines, main = "Wine data Kohonen SOM")
plot(som.wines, type = "changes", main = "Wine data: SOM")

mygrid = somgrid(2, 2, "hexagonal")
som.wines = supersom(trainingdata, grid = mygrid)
som.prediction = predict(som.wines, newdata = testdata)
som.prediction2 = predict(som.wines, newdata = trainingdata)
table(vintages[-training], som.prediction$predictions[["vintages"]])
table(vintages[training], som.prediction2$predictions[['vintages']])

# 4 X 4
set.seed(1)
som.wines = som(scale(wines), grid = somgrid(4, 4, "hexagonal"))
par(mfrow = c(1, 2))
plot(som.wines, main = "Wine data Kohonen SOM")
plot(som.wines, type = "changes", main = "Wine data: SOM")

mygrid = somgrid(4, 4, "hexagonal")
som.wines = supersom(trainingdata, grid = mygrid)
som.prediction = predict(som.wines, newdata = testdata)
som.prediction2 = predict(som.wines, newdata = trainingdata)
table(vintages[-training], som.prediction$predictions[["vintages"]])
table(vintages[training], som.prediction2$predictions[['vintages']])

# 10 X 10
set.seed(1)
som.wines = som(scale(wines), grid = somgrid(10, 10, "hexagonal"))
par(mfrow = c(1, 2))
plot(som.wines, main = "Wine data Kohonen SOM")
plot(som.wines, type = "changes", main = "Wine data: SOM")

mygrid = somgrid(10, 10, "hexagonal")
som.wines = supersom(trainingdata, grid = mygrid)
som.prediction = predict(som.wines, newdata = testdata)
som.prediction2 = predict(som.wines, newdata = trainingdata)
table(vintages[-training], som.prediction$predictions[["vintages"]])
table(vintages[training], som.prediction2$predictions[['vintages']])



# 2 X 2 : Since there is not much cluster, the error doesn't seems to get much smaller . Also, the model seems to be so simple
# 4 x 4 : There are more cluster in this case than the previous case. There is a point where the loss reduces with a large amount
# 10 X 10 : This should have the lowest loss, compared with the previous two cases. But in the aspect of intepretation of the model, it is too compicated. There are 100 clusters in total!
# We have to think both, the accuracy(lowering the loss) and interpretation(not making too much clusters)
# So I think the one with 4*4 nodes is the best!


# We can not make 14*14 grids, since there is only 177 datasets, and it does not make sense to make 196 clusters with 177 data!
# The number of cluster should be less than the number of datasets.


######################################################################




