x<-c("a","b","c","d")

for(i in seq_along(x))
{
  print(x[i])
}

args(paste)
args(cat)



cube <-function(x,n){
  x^3
}

cube(3)



x=1:10
if(x>5){
  x=0
}



f <- function(x) {
  g <- function(y) {
    y + z
  }
  z <- 4
  x + g(x)
}
z=10
f(3)



x <- 5
y <- if(x < 3) {
  NA
} else {
  10
}
y


 
k = na.omit(test[c("nitrate")])


g = vector(mode="numeric", length=0)
test = read.csv("specdata/007.csv")
completeCase = na.omit(test)

if(dim(completeCase)[1] > 1)
{
  g = append(g,cor(completeCase$sulfate,completeCase$nitrate))
}


test = read.csv("specdata/009.csv")
completeCase = na.omit(test)

if(dim(completeCase)[1] > 1)
{
  g = append(g,cor(completeCase$sulfate,completeCase$nitrate))
}



test = read.csv("specdata/100.csv")
completeCase = na.omit(test)

if(dim(completeCase)[1] > 1)
{
  g = append(g,cor(completeCase$sulfate,completeCase$nitrate))
}



sapply(1:3, function(x) x^2)


id = c('John Doe','Peter Gynn')
nobs = c(21000, 23400)


k = data.frame(id=character(0), nobs=integer(0))
k





newRow = data.frame(id="jason john", nobs=100)
k = rbind(k, newRow)

k



mean(g)


source("submitscript1.R")
submit()
dormantroot@gmail.com
