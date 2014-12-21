library(shiny)
runExample("01_hello")
library(shinyapps)

getwd()

runApp("./App-1", display.mode="showcase")

runApp("./App-2", display.mode="showcase")


runApp("./stockVis", display.mode="showcase")

runApp("./PredictIris")


library(manipulate)
myPlot <- function(s) {
  plot(cars$dist - mean(cars$dist), cars$speed - mean(cars$speed))
  abline(0, s)
}

manipulate(myPlot(s), s = slider(0, 2, step = 0.1))

require(devtools)
install_github('rCharts', 'ramnathv')

?iris
require(rCharts)



library(caret)
library(randomForest)
library(datasets)

df = data.frame(6.2, 3.4, 5.4, 1.8)
names(df) = c("Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width")
modFit = randomForest(Species ~ ., data=iris)
pr = predict(modFit, df)
toString(pr)

df = cbind(df, data.frame(toString(pr)))
names(df) = c("SepalLength", "SepalWidth", "PetalLength", "PetalWidth", "Species")
df

names(df) = c("Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width")
iris$Species
df$Species = factor(df$Species, levels=c("setosa","versicolor","virginica"))

eruption.lm = lm(eruptions ~ waiting, data=faithful)
eruption.lm$coefficients[1]

# rchart examples
## Example 1 Facetted Scatterplot
names(iris) = gsub("\\.", "", names(iris))
rPlot(SepalLength ~ SepalWidth | Species, data = iris, color = 'Species', type = 'point')
rPlot(modFit)

## Example 2 Facetted Barplot
hair_eye = as.data.frame(HairEyeColor)
rPlot(Freq ~ Hair | Eye, color = 'Eye', data = hair_eye, type = 'bar')
iris


p = qplot(SepalWidth, SepalLength, col=Species,data=iris)
p + scale_alpha(guide = 'none')
p + geom_point(color="black",size=10,shape=8,x=df$SepalWidth,y=df$SepalLength)

p + scale_y(guide = 'none')

k = list("predictedModel"=df, "userDF"=df)
k$predictedModel$SepalLength
