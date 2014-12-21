library(UsingR);
data(galton)
summary(galton)

par(mfrow=c(1,2))
hist(galton$child, col="blue", breaks=100)
hist(galton$parent, col="blue", breaks=100)


library(manipulate)
myHist <- function(mu){
  hist(galton$child,col="blue",breaks=100)
  lines(c(mu, mu), c(0, 150),col="red",lwd=5)
  mse <- mean((galton$child - mu)^2)
  text(63, 150, paste("mu = ", mu))
  text(63, 140, paste("MSE = ", round(mse, 2)))
}
manipulate(myHist(mu), mu = slider(62, 74, step = 0.5))


plot(galton$parent,galton$child,pch=19,col="blue")



freqData = as.data.frame(table(galton$child, galton$parent))
names(freqData) <- c("child", "parent", "freq")
plot(as.numeric(as.vector(freqData$parent)), 
     as.numeric(as.vector(freqData$child)),
     pch = 21, col = "black", bg = "lightblue",
     cex = .15 * freqData$freq, 
     xlab = "parent", ylab = "child")



2*((0.18 - 0.300)^2)+1*((-1.54 - 0.300)^2)+3*((0.42 - 0.300)^2)+1*((0.95 - 0.300)^2)

x = c(0.18, -1.54, 0.42, 0.95)
w = c(2, 1, 3, 1)

sum(w*((x-0.300)^2))
sum(w*((x-1.077)^2))
sum(w*((x-0.1471)^2))
sum(w*((x-0.0025)^2))

x <- c(0.8, 0.47, 0.51, 0.73, 0.36, 0.58, 0.57, 0.85, 0.44, 0.42)
y <- c(1.39, 0.72, 1.55, 0.48, 1.19, -1.59, 1.23, -0.65, 1.49, 0.05)

k = as.data.frame(cbind(x,y))
k

plot(k$x,k$y,pch=19,col="blue")

m = lm(k$y~k$x-1, data =k)
m
abline(m)
m = lm(k$y~k$x, data =k)
abline(m)
m


data(mtcars)
mtcars$mpg
mtcars$wt


plot(mtcars$wt,mtcars$mpg,pch=19,col="blue")
m = lm(mtcars$mpg~mtcars$wt, data=mtcars)
m
abline(m)
m = lm((mtcars$mpg~mtcars$wt-1), data=mtcars)
m
abline(m)



x <- c(8.58, 10.46, 9.01, 9.64, 8.86)

s = sd(x)
m = mean(x)

(8.58-m)/s



x = rnorm(1:10, mean=0, sd=1)
y = rnorm(1:10, mean=0, sd=1)
k = as.data.frame(cbind(x,y))
k
m = lm(k$y~k$x-1, data =k)
abline(m)
m


y <- galton$child
x <- galton$parent
beta1 <- cor(y, x) * sd(y) / sd(x)
beta0 <- mean(y) - beta1 * mean(x)

beta1
beta0
rbind(c(beta0, beta1), coef(lm(y ~ x)))



y <- galton$child
x <- galton$parent
lm(y ~ x)
lm(x ~ y)
(0.6463/0.3256)

cor(y,x)
var(y)/var(x)
(2*sd(y))/sd(x)



x <- c(0.8, 0.47, 0.51, 0.73, 0.36, 0.58, 0.57, 0.85, 0.44, 0.42)
sum((x-0.573)^2)
sum((x-0.8)^2)
sum((x-0.36)^2)
sum((x-0.44)^2)
