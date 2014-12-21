library(randomForest)
library(plyr)
library(ggplot2)
library(gridExtra)
library(caret)
set.seed(3433)

## read data
training = read.csv("pml-training.csv") 
testing = read.csv("pml-testing.csv") 

cNames = c("gyros_dumbbell_x","gyros_dumbbell_y", "gyros_dumbbell_z", "accel_dumbbell_x", "accel_dumbbell_y", "accel_dumbbell_z",
           "magnet_dumbbell_x", "magnet_dumbbell_y", "magnet_dumbbell_z", "gyros_forearm_x", "gyros_forearm_y", "gyros_forearm_z",
           "accel_forearm_x", "accel_forearm_y", "accel_forearm_z", "magnet_forearm_x", "magnet_forearm_y", "magnet_forearm_z")

dfTrain = training[,cNames]
dfTrain = cbind(dfTrain, training$classe)
colnames(dfTrain)[19] = "classe"
dfTest  = testing[,cNames]
names(training)

## Split the training into two for cross validation and out-of-bag/ in-bag error. In other words, I want to find out the
## accurac of our trained model
inTrain = createDataPartition(y=dfTrain$classe, p=0.75, list=FALSE)
dfT = dfTrain[inTrain,]
dfV = dfTrain[-inTrain,]

## Exploration
#~~~ frequency
p1 = ggplot(dfT, aes(x=classe)) + geom_histogram(aes(y=..density..),binwidth=.2, colour="black", fill="white") + 
  ggtitle("'classe' Frequency in Training Set") +  
  geom_density(alpha=.2, fill="#FF6666")

p2 = ggplot(dfV, aes(x=classe)) + geom_histogram(aes(y=..density..), binwidth=.2, colour="black", fill="white") + 
  ggtitle("'classe' Frequency in Validation Set")+  
  geom_density(alpha=.2, fill="#FF6666")

grid.arrange(p1, p2)

#~~~ boxplot
b1 = ggplot(dfT, aes(x=classe, y=gyros_dumbbell_x)) + geom_boxplot() 
b2 = ggplot(dfV, aes(x=classe, y=gyros_dumbbell_y)) + geom_boxplot()
b3 = ggplot(dfV, aes(x=classe, y=gyros_dumbbell_z)) + geom_boxplot()

grid.arrange(b1, b2, b3, main = "Prespective of Gyro Dumbell Activities") # notice the outliers; hoping PCA processing should smooth that out.

## PCA Processing
preProc = preProcess(dfT[,-19], method="pca", thresh=0.80)
trainPC = predict(preProc, dfT[,-19])
testPC  = predict(preProc, dfV[,-19])

## Training the model using random Forest
model = randomForest(dfT$classe ~ ., data=trainPC)

## Predicting the outcome of 'testPC' dataset using
## the trained model
predicted = predict(model,testPC)

## Now let's examine the 'out of bag' error rate on the training set
mean(predict(model)!=dfT$classe)  

## Now let's examine error rate on the testing/validation set. Here we are using cross validation to understand the accuracy of our trained model. 
# Following is the confusion matrix that gives a summary statistics of our cross validation. The numbers in the table indicates observations in the validation/testing set that were predicted/not predicted correctly. For eg, the model predicted the 'classe A' correctly for 1312 observations in the testing dataset. More over, the 'Sensitivity' & 'specificity' row shown below indicates these prediction accurracies for each 'classe' in percentages. Overall, the accuracy of this model is 85%, which is not bad! However, there is still remove for improvement.
confusionMatrix(dfV$classe,predict(model,testPC))

# Now let's apply the trained model to an actual test dataset. Remember, previously we created a validation/test set so as to check the accuracy of our model
outputTestPC  = predict(preProc, dfTest)
outputResult = predict(model,outputTestPC)
outputResult


