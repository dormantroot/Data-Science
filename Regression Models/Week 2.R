library(UsingR)
data(diamond)


plot(diamond$carat, diamond$price, 
     xlab = "Mass (carats)", 
     ylab = "Price (SIN $)", 
     bg = "lightblue", 
     col = "black", cex = 1.1, pch = 21,frame = FALSE)
abline(lm(price ~ carat, data = diamond), lwd = 2)


data(mtcars)
mtcars$mpg
mtcars$wt



m1 = lm(mtcars$mpg~mtcars$wt, data=mtcars)
x = sum(m1$residuals^2)
m1
m2 = lm((mtcars$mpg~mtcars$wt-1), data=mtcars)
y = sum(m2$residuals^2)
m2

y/x

x/y


x <- c(0.61, 0.93, 0.83, 0.35, 0.54, 0.16, 0.91, 0.62, 0.62)
y <- c(0.67, 0.84, 0.6, 0.18, 0.85, 0.47, 1.1, 0.65, 0.36)

fit <- lm(y ~ x); 

sumCoef <- summary(fit)$coefficients
sumCoef[1,1] + c(-1, 1) * qt(.975, df = fit$df) * sumCoef[1, 2]
sumCoef[2,1] + c(-1, 1) * qt(.975, df = fit$df) * sumCoef[2, 2]
