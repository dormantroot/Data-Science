# # Task 1
# setwd("F:/My Development/My Testing Ground/Data Science/Data Science Cert - Code/R Programming/Week 4")
# outcome = read.csv("outcome-of-care-measures.csv", colClasses="character")
# head(outcome)
# ncol(outcome)
# 
# outcome[, 11] = as.numeric(outcome[,11])
# hist(outcome[,11])
# table(outcome[,11])




# names(outcome)[13] = "low30HT"
# names(outcome)[19] = "low30HF"
# names(outcome)[25] = "low30PN"
# 
# names(result)
# result$Hospital.Name
# result = outcome[which(outcome$low30HT != "Not Available" & outcome$State == "TX"), c(2,7,13)]
# 
# result = result[with(result, order(result$low30HT,decreasing=TRUE)), ]
# result = result[with(result, order(result$Hospital.Name,decreasing=FALSE)), ]
# result
# 
# unique(outcome[, c(13)])
# 
# names(outcome)
# outcomeValues = c("heart attack", "heart failure", "pneumonia")
# is.element("heart attack",outcomeValues)
# 
# if("heart attack" != outcomeValues[1])
#  print("yes")
# y = "fruit"
# switch(y, outcomeValues[1]="h", "Neither")

source("http://d396qusza40orc.cloudfront.net/rprog%2Fscripts%2Fsubmitscript3.R")
submit()
