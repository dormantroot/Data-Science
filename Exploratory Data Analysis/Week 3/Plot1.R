##-----------------------------------------------------------------------------
## The following code assumes that files 'summarySCC_PM25.rds' and 
## 'Source_Classification_Code.rds' exist in your working directory
#
#  Question 1 : Have total emissions from PM2.5 decreased in the United States
#  from 1999 to 2008? Using the base plotting system, make a plot showing the 
#  total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.?
##-----------------------------------------------------------------------------

# Read the rd file contents
NEI = readRDS("summarySCC_PM25.rds")
SCC = readRDS("Source_Classification_Code.rds")

# Group emissions by year across all sources and find the total emission for each of the years
gdf = ddply(NEI, c("year"), function(x) c(TOTAL=sum(x$Emissions)))


# Define the plotting device
png("plot1.png",res=55, width=480, height=480) 

# Plot the graph
plot(gdf$year,gdf$TOTAL, type = "o", ylim = c(0, max(gdf$TOTAL)), xlim=c(1998, 2010),
     col="red",
     xlab="Year",ylab="Total PM2.5 Emission (Tons)",
     main="Total PM2.5 Emissions (in Tons) from Year 1999 to 2008")

# Save to PNG file
dev.off()

# Answer: From the above graph it is clearly evident that emissions from PM2.5 has decreased from year 1999 to 2008