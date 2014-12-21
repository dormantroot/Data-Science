?par

library(datasets)
hist(airquality$Ozone) # histogram

with(airquality, plot(Wind, Ozone)) # Scatter plot
title(main="Ozone and Wind in New York City")

airquality = transform(airquality, Month=factor(Month))
str(airquality$Month)
boxplot(Ozone ~ Month, airquality, xlab="Month", ylab="Ozone (ppb)")

example(points)

