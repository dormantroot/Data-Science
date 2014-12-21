##-----------------------------------------------------------------------------
## The following code assumes that files 'summarySCC_PM25.rds' and 
## 'Source_Classification_Code.rds' exist in your working directory
#
# Question 6 : Compare emissions from motor vehicle sources in Baltimore City 
# with emissions from motor vehicle sources in Los Angeles County, 
# California (fips == "06037"). Which city has seen greater changes over time 
# in motor vehicle emissions?
##-----------------------------------------------------------------------------
# Read the rd file contents
NEI = readRDS("summarySCC_PM25.rds")
SCC = readRDS("Source_Classification_Code.rds")

# Find all motor vehicle emission sources
sccCoal = SCC[which(SCC$Data.Category=="Onroad"),]

# Find emission of PM2.5 from motor vehicle sources that was recorded through out USA
gdf = NEI[which(NEI$SCC %in% sccCoal$SCC),]

# Extract emission data for Baltimore City (fips == "24510") and Los Angeles County (fips == "06037")
gdf = gdf[which(gdf$fips == "24510" | gdf$fips == "06037"),]

# Assign proper names for 'fips'
gdf[which(gdf$fips == "24510"),]$fips = "Baltimore City"
gdf[which(gdf$fips == "06037"),]$fips = "Los Angeles County"

# Group emissions by fips (Baltimore & Los Angeles) and year produced by motor vehical sources
gdf = ddply(gdf, c("fips","year"), function(x) c(TOTAL=sum(x$Emissions)))

# Define the plotting device
png("plot6.png",res=58, width=480, height=480) 

# Plot
ggplot(gdf, aes(x=year, y=TOTAL, colour=fips)) + geom_line() +
  xlab("Year") +
  ylab("Total PM2.5 Emission (Tons)") +
  ggtitle("Total Emission from Motor Vehicles in Baltimore City \n vs Los Angeles County During the Year 1999-2008") +
  scale_colour_discrete(name = "US County")+ 
  geom_point(colour="red", size=4, shape=21, fill="white")

# Save to PNG file
dev.off()

# Answer: Motor vehicle emission has been considerably high in Los Angeles county since 1999. More over, 
# compared to the same year (1999) in Baltimore City the emission was 10 time higher in Los Angeles county. 
# For Baltimore City the emission rate has decreased steadly through 1999-2008, where as for Los Angeles County 
# the rate increased tremendously, hitting the highest point in 2005. Even though the emission rate did decrease 
# for Los Angeles after 2005, the rate as of 2008 is still higher than what it was in 1999.
#
# In short, Los Angeles County has seen greater changes in emission due to motor vehicles.