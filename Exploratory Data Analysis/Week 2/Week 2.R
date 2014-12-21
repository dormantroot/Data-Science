library(lattice)
library(datasets)

# scatter plot with lattice 
xyplot(Ozone~Wind, data=airquality)

# multiple scatter plots with lattice
airquality = transform(airquality, Month=factor(Month)) # convert 'Month' to a factor variable
xyplot(Ozone~Wind | Month, data=airquality, layout=c(5,1))


# lattice panel functions
set.seed(10)
x = rnorm(100)
m = rep(0:1, each=50)
y = x+m-m*x+rnorm(100, sd=0.5)
f = factor(m, labels=c("Group 1", "Group 2"))
xyplot(y~x | f, layout=c(2,1))


# Quizz question 2
library(nlme)
library(lattice)
xyplot(weight ~ Time | Diet, BodyWeight)

?xyplot


# Question 4
library(lattice)
library(datasets)
data(airquality)
p = xyplot(Ozone~Wind | factor(Month), data=airquality)

# Question 7
library(datasets)
library(ggplot2)
data(airquality)

airquality = transform(airquality, Month=factor(Month))
qplot(Wind, Ozone, data=airquality, facets = .~Month)


# Question 9
library(ggplot2)
g = ggplot(movies, aes(votes, rating))
print(g)


# Question 10
qplot(votes, rating, data=movies)+stats_smooth("loess")













