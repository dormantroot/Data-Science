##-----------------------------------------------------------------------------
## The following code assumes that files 'summarySCC_PM25.rds' and 
## 'Source_Classification_Code.rds' exist in your working directory
#
#  Question 2: Have total emissions from PM2.5 decreased in the Baltimore City, 
#  Maryland (fips == "24510") from 1999 to 2008? Use the base plotting system to 
#  make a plot answering this question.
##-----------------------------------------------------------------------------

# Read the rd file contents
NEI = readRDS("summarySCC_PM25.rds")
SCC = readRDS("Source_Classification_Code.rds")

# Extract emission data for Baltimore City (fips == "24510")
gdf = NEI[which(NEI$fips == "24510"),]

# For the city of Baltimore, group emissions by year across all sources and find the total emission for each of the years
gdf = ddply(gdf, c("year"), function(x) c(TOTAL=sum(x$Emissions)))

# Define the plotting device
png("plot2.png",res=55, width=480, height=480) 

# Plot
plot(gdf$year,gdf$TOTAL, type = "o", ylim = c(0, max(gdf$TOTAL)), xlim=c(1998, 2010),
     col="red",
     xlab="Year",ylab="Total PM2.5 Emission (Tons)",
     main="Total PM2.5 Emissions (in Tons) for Baltimore City from Year 1999 to 2008")

# Save to PNG file
dev.off()

# Answer: From the above graph it is clearly evident that in the City of Baltimore emission 
# from PM2.5 decreased from year 1999 to 2008. However, the fall in the emission rate wasn't steady. 
# As you can in the figure, the emission did decrease from 1999 to 2002, but bumped back up in 2005 before 
# finally receding to lowest level in 2008.