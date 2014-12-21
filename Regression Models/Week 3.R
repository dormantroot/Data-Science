library(datasets);
data(swiss);
str(swiss)
library(caret)
data(mtcars)


# question 1
head(mtcars)
model = lm(mpg ~ factor(cyl)+wt, data = mtcars)
summary(model)


lm(mpg ~ I(wt * 0.5) + factor(cyl), data = mtcars)



x <- c(0.586, 0.166, -0.042, -0.614, 11.72)
y <- c(0.549, -0.026, -0.127, -0.751, 1.344)
m = lm(y~x)
hat(m)




x <- c(0.586, 0.166, -0.042, -0.614, 11.72)
y <- c(0.549, -0.026, -0.127, -0.751, 1.344)
model5 <- lm(y~x)
hatvalues(model5)[1:5]
dfbetas(model5)[5,2]
