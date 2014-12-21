library(plyr)
library(ggplot2)
library(gridExtra)
library(caret)
library(GGally)
data(mtcars)
library(plyr)
set.seed(3433)

mtcars$am
df$am
str(df)


# mtcars
df = mtcars
df = rename(mtcars, c("mpg"="MilePerGallon", "cyl"="NumOfCyclinders", "disp"="Displacement", "hp"="HorsePower", "drat"="RearAxleRatio", "wt"="Weight","am"="Transmission","qsec"="qsec","vs"="V/S", "gear"="NumOfFowardGears","carb"="NumOfCarburetors"))
df$Transmission = as.factor(df$Transmission)
df$Transmission = revalue(df$Transmission, c("0"="Automatic", "1"="Manual"))

inTrain = createDataPartition(y=df$Transmission, p=0.75, list=FALSE)
dfT = df[inTrain,]
dfV = df[-inTrain,]


# Exploration
# Here's a visual cue on how the different variables affect the mileage. 
ggpairs(data=dfT, # data.frame with variables
        columns=c("MilePerGallon","Transmission","NumOfCyclinders","HorsePower","Weight"), # columns to plot, default to all.
        title="tips data", # title of the plot
        colour = "Transmission")


#~~~~~ frequency
ggplot(dfT, aes(x=Transmission)) + geom_histogram(aes(y=..density..),binwidth=.2, colour="black", fill="white") + 
  ggtitle("Transmission Frequency in Training Set") +  
  geom_density(alpha=.2, fill="#FF6666")


#~~~ boxplot
b1 = ggplot(dfT, aes(x=Transmission, y=MilePerGallon)) + geom_line() + geom_point() 
b2 = ggplot(dfT, aes(x=HorsePower, y=MilePerGallon)) + geom_line() + geom_point() 
b3 = ggplot(dfT, aes(x=NumOfCyclinders, y=MilePerGallon)) + geom_line() + geom_point() 
b4 = ggplot(dfT, aes(x=Weight, y=MilePerGallon)) + geom_line() + geom_point() 

grid.arrange(b1, b2, b3, b4, main = "Mileage Perspective") # notice the outliers; hoping PCA processing should smooth that out.


## PCA Processing
cols = c("MilePerGallon", "NumOfCyclinders", "Displacement", "HorsePower","RearAxleRatio", "Weight","qsec","V/S", "NumOfFowardGears","NumOfCarburetors")
preProc = preProcess(dfT[,cols], method="pca", thresh=0.80)
trainPC = predict(preProc, dfT[,cols])

## Training the model with all variables
dfT$Transmission = as.numeric(dfT[,"Transmission"])
model = lm(Transmission ~ ., data = dfT)
plot(resid(model))
abline(h=0)
summary(model)

deviance(model) # residual sum of squares
confint(model)
anova(model)


## Training the model with just "MilePerGallon", "NumOfCyclinders", "HorsePower","Weight"
model = lm(Transmission ~ MilePerGallon+NumOfCyclinders+HorsePower+Weight, data = dfT)
plot(resid(model))
abline(h=0)
summary(model)

deviance(model) # residual sum of squares
confint(model)
anova(model)