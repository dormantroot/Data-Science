

# quizz question 1
library(AppliedPredictiveModeling)
data(segmentationOriginal)
library(caret)

df = segmentationOriginal
inTrain <- createDataPartition(y=df$Case,p=0.75, list=FALSE)
training <- df[inTrain,]
testing <- df[-inTrain,]
set.seed(125)
modFit <- rpart(Case ~ .,method="class",data=training)
modFit

# quizz question 5
library(ElemStatLearn)
data(vowel.train)
data(vowel.test) 

tr = vowel.train
tr$y = as.factor(tr$y)

te = vowel.test
te$y = as.factor(te$y)

set.seed(33833)

modFit <- train(y~ .,data=tr,method="rf",prox=TRUE)
varImp (modFit, useModel=TRUE)
