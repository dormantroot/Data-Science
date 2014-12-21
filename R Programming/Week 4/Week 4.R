# Generating random variables from normal distribution
x = rnorm(10)   #generate random numbers from normal distribution
x
summary(x)

x = rnorm(10, 20, 2) #generate random numbers from normal distribution with
                     # mean = 20, sd = 2
x
summary(x)



# Generate random numbers from a linear model, where x, the predictor, is a normal distribution
set.seed(20)
x = rnorm(100)  # standard normal distribution; mean=0, sd=1
e = rnorm(100, 0, 2) # standard normal distribution; mean=0, sd=2
y = 0.5 + 2 * x + e  # the linear model
summary(y)

plot(x,y)



# Generate random numbers from a linear model, where x, the predictor, is a binomial distribution
set.seed(20)
x = rbinom(100, 1, 0.5) # binomial distribution
e = rnorm(100, 0, 2)
y = 0.5 + 2 * x + e

summary(y)
plot(x,y)



# R profiling
system.time(readLines("http://www.jhsph.edu"))
hilbert = function(n)
          {
            i = 1:n
            1/ outer (i-1, i, "+")
          }
x = hilbert(1000)
system.time(svd(x))

hilbert = function(n)  # R profiling using the Rprof
{
  i = 1:n
  1/ outer (i-1, i, "+")
}
x = hilbert(1000)

Rprof("hilbert")
y = (svd(x))
Rprof(NULL)
summaryRprof("hilbert")
