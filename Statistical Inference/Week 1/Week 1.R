# Expected values
data(Galton)

hist(Galton$child)
hist(Galton$parent)



## Using manipulate
library(manipulate)
myHist = function(mu){
  hist(Galton$child,col="blue",breaks=100)
  lines(c(mu, mu), c(0, 150),col="red",lwd=5)
  mse = mean((Galton$child - mu)^2)
  text(63, 150, paste("mu = ", mu))
  text(63, 140, paste("Imbalance = ", round(mse, 2)))
}
manipulate(myHist(mu), mu = slider(62, 74, step = 0.5))



## The center of mass is the empirical mean
hist(Galton$child,col="blue",breaks=100)
meanChild = mean(Galton$child)
lines(rep(meanChild,100),seq(0,150,length=100),col="red",lwd=5)

pbeta(0.75,1,1)




library(datasets);
data(mtcars)
round(t.test(mtcars$mpg)$conf.int)


a = 3
s = sqrt(0.60)
n = 10
error = qt(0.95,df=n-1)*s/sqrt(n)
left = a-error
right = a+error

(-2*sqrt(9))/qt(0.975, df=8)



n1 = n2 = 9
x1 = 3
x2 = 1
s1 = 1.5
s2 = 1.8
spsq = ( (n1 - 1) * s1^2 + (n2 - 1) * s2^2) / (n1 + n2 - 2)
