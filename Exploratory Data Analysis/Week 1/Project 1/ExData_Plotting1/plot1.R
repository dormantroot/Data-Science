###############################################################################
## plot1.R script file
###############################################################################
## This script creates a frequency histogram of the 'Global_active_power' 
## variable in the 'Electric Power Consumption' dataset. The resulting 
## histogram is saved in the current working folder as plot1.png
###############################################################################


##-----------------------------------------------------------------------------
## Pre-requisites before running the entire script.
##
## 1) Please set your working directory (using the 'setwd' command) to the 
##    location of the required file - 'household_power_consumption.txt'.
##
## 2) You should install the 'sqldf' R package
##-----------------------------------------------------------------------------
library(sqldf)  # load sqldf library

getwd()         # get your current working location
#setwd(.....)   # command to set your working directory location. Note, the directory should contain the 'household_power_consumption.txt' file

# Read only those recordings that happened on February 1st and 2nd of year 2007.
data = read.csv.sql("household_power_consumption.txt", sql="select * from file where Date=='1/2/2007' or Date=='2/2/2007' ", 
                    sep=";", header=TRUE)

# Define the plotting device
png("plot1.png",res=55, width=480, height=480) 

# Create the histogram for 'Global_active_power'
hist(data$Global_active_power, main="Global Active Power", xlab="Global Active Power(kilowatts)", ylab="Frequency", col="red")

# Save to PNG file
dev.off()

