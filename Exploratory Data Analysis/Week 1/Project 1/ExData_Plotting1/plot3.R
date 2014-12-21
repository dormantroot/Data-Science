###############################################################################
## plot3.R script file
###############################################################################
## This script creates a line graph representing the values of the energy
## sub metering variables (Sub_metering_1, Sub_metering_2, Sub_metering_3) 
## for each day of the week, during the 1st and 2nd day of February, 2007. 
## The resulting line graph is saved in the current working folder as plot3.png
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
png("plot3.png",res=55, width=480, height=480) 

# Create a line plot showing the values of the variable -'Sub_metering_1'
plot(data$Sub_metering_1,type="l",lwd=1,
     xaxt="n",col="black",
     xlab="",ylab="Energy sub metering",
     main="")

# add the x-axis values
axis(1, at=1,labels=c("Thu"))                   
axis(1, at=length(data$Date)/2,labels=c("Fri"))  
axis(1, at=length(data$Date),labels=c("Sat"))    
                 

# Create a line plot showing the values of the variable -'Sub_metering_2'
lines(data$Sub_metering_2,col="red",type="l",lwd=1)

# Create a line plot showing the values of the variable -'Sub_metering_3'
lines(data$Sub_metering_3,col="blue",type="l",lwd=1)

# Display the legend
legend("topright",legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
       lty=1,lwd=1,col=c("black","red","blue"),
       ncol=1,cex=1.5, 
       bty="1",  
       inset =c(0,0),
       text.col=c("black"))

# Save to PNG file
dev.off()

