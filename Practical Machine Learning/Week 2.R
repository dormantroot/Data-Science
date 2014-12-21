library(caret)
library(kernlab)
data(spam)

inTrain = createDataPartition(y=spam$type, p=0.75, list=FALSE)
training = spam[inTrain,]
testing = spam[-inTrain,]

set.seed(32343)
modelFit = train(type ~.,data=training, method="glm")
modelFit
modelFit$finalModel


predictions = predict(modelFit, newdata=testing)
predictions


#k-fold
set.seed(32323)
folds = createFolds(y=spam$type,k=10,list=TRUE,returnTrain=TRUE)
folds
?createFolds

?createResample



library(caret); library(kernlab); data(spam)
inTrain <- createDataPartition(y=spam$type,
                               p=0.75, list=FALSE)
training <- spam[inTrain,]
testing <- spam[-inTrain,]
hist(training$capitalAve,main="",xlab="ave. capital run length")



?preProcess

preObj = preProcess(training[,-58],method=c("center","scale"))
trainCapAveS <- predict(preObj,training[,-58])$capitalAve
mean(trainCapAveS)
preObj
training




# quizz one question
library(AppliedPredictiveModeling)
library(caret)
data(AlzheimerDisease)

data.frame(diagnosis, predictors)



#quizz question 2
library(Hmisc)
library(AppliedPredictiveModeling)
data(concrete)
library(caret)
set.seed(975)
inTrain = createDataPartition(mixtures$CompressiveStrength, p = 3/4)[[1]]
training = mixtures[ inTrain,]
testing = mixtures[-inTrain,]

group = cut2(training$FlyAsh, g=3)
plot(training$CompressiveStrength, col=group)


# quizz question 3
library(AppliedPredictiveModeling)
data(concrete)
library(caret)
set.seed(975)
inTrain = createDataPartition(mixtures$CompressiveStrength, p = 3/4)[[1]]
training = mixtures[ inTrain,]
testing = mixtures[-inTrain,]

library(scales) 
sp10 = ggplot(training, aes(x=Superplasticizer)) + geom_histogram(binwidth=.0001)
sp10 + scale_y_continuous(trans = log2_trans())


# quizz question 4
library(caret)
library(AppliedPredictiveModeling)
set.seed(3433)
data(AlzheimerDisease)
adData = data.frame(diagnosis,predictors)
inTrain = createDataPartition(adData$diagnosis, p = 3/4)[[1]]
training = adData[ inTrain,]
testing = adData[-inTrain,]


trainingIL = cbind(training[,grep("^IL", colnames(training))],training[1])
preProc = preProcess(trainingIL[,-13],method="pca",thresh=0.90)
trainPC = predict(preProc,trainingIL[,-13])
modelFit = train(trainingIL$diagnosis ~ .,method="glm",data=trainPC)

summary(modelFit$finalModel)





# quizz question 5
library(caret)
library(AppliedPredictiveModeling)
set.seed(3433)
data(AlzheimerDisease)
adData = data.frame(diagnosis,predictors)
inTrain = createDataPartition(adData$diagnosis, p = 3/4)[[1]]
training = adData[ inTrain,]
testing = adData[-inTrain,]

trainingIL = cbind(training[,grep("^IL", colnames(training))],training[1])
testingIL = cbind(testing[,grep("^IL", colnames(testing))],testing[1])

preProc = preProcess(trainingIL[,-13],method="pca",thresh=0.80)
trainPC = predict(preProc,trainingIL[,-13])
testPC <- predict(preProc,testingIL[,-13])

PCFit = train(trainingIL$diagnosis ~ .,method="glm",data=trainPC)
NoPCFit = train(trainingIL$diagnosis ~ .,method="glm",data=trainingIL)

confusionMatrix(testingIL$diagnosis,predict(PCFit,testPC))
confusionMatrix(testingIL$diagnosis,predict(NoPCFit,testingIL))
