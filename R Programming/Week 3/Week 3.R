#####################################################################################
#### lapply & sapply ################################################################
#####################################################################################
## lapply (for list apply) applies the ''median' function on each component of a list
lapply(list(1:3,25:29), median)


x = list(a = 1:5, b=rnorm(10))
lapply(x,mean)


x = list(a=1:4, b=rnorm(10), c=rnorm(20,1), d=rnorm(100,5))
lapply(x,mean)

x = list(1:4)
lapply(x,runif)


x = 1:4
lapply(x, runif, min=0, max=10)


## we can use anonymous functions with lapply
x = list(a=matrix(1:4,2,2), b=matrix(1:6,3,2))
x

lapply(x, function(elt)
{
  elt[,1]
})



############ sapply (simplified (l)apply)###############
x = list(a=1:4, b=rnorm(10), c=rnorm(20,1), d=rnorm(100,5))
lapply(x, mean)
sapply(x, mean)


############ apply #####################################
x = matrix(rnorm(200), 20, 10)
x
apply(x, 2, mean)  # 2 means, eliminate all rows and leave the columns
apply(x, 1, sum)  # 1 means, eliminate all columns and leave the row

a = array(rnorm(2*2*10), c(2,2,10))
apply(a, c(1,2), mean)



########### tapply ###################################
x = c(rnorm(10), runif(10), rnorm(10, 1))
f = gl(3, 10)

tapply(x, f, range)




########### debugging ###################################
printmessage = function(x)
{
  if(x>0)
    print("x is greater than zero")
  else
    print("x is less than or equal to zero")
  
  invisible(x)
}

printmessage(2)
x = printmessage(NA)


traceback() # prints out the function call stack after an error occurs; does nothing if there’s no error

debug(printmessage)  # debug
printmessage(4)








######################## quiz answers #################################################
library(datasets)
data(iris)
?iris

# question 1
summary(iris[which(iris$Species=='virginica'),]$Sepal.Length)


# question 2
names(iris)
apply(iris[,1:4], 2, mean)


# question 3
library(datasets)
data(mtcars)
?mtcars
tapply(mtcars$mpg, mtcars$cyl, mean)
sapply(split(mtcars$mpg, mtcars$cyl), mean)

split(mtcars$mpg, mtcars$cyl)


# question 4
names(mtcars)
tapply(mtcars$hp, mtcars$cyl, mean)


# question 5
debug(ls)
.Ob <- 1
ls(pattern = "O")


