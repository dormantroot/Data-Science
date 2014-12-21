x=4
class(x)
y=c(TRUE,4)
class(y)

dim(x)

x=c(1,3,5)
y=c(3,2,10)
z=cbind(x,y)
class(z[1,1])


x=list(2, "a","b",TRUE)
class(x)
class(x[[1]])


a=1:4
b=2:3
z=a+b
str(z)


x=c(17,14,4,5,13,12,10)
x[x>10]=4

data = read.csv("hw1_data.csv") 
names(data)


ozone=data[,"Ozone"]
summary(ozone)

sub = data[which(data$Month==5),]
summary(sub)
