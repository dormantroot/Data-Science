##-----------------------------------------------------------------------------
## The following code assumes that files 'summarySCC_PM25.rds' and 
## 'Source_Classification_Code.rds' exist in your working directory
#
# Question 5 : How have emissions from motor vehicle sources changed 
# from 1999–2008 in Baltimore City?
##-----------------------------------------------------------------------------
# Read the rd file contents
NEI = readRDS("summarySCC_PM25.rds")
SCC = readRDS("Source_Classification_Code.rds")

# Find all motor vehicle emission sources
sccCoal = SCC[which(SCC$Data.Category=="Onroad"),]

# Find emission of PM2.5 from motor vehicle sources that was recorded through out USA
gdf = NEI[which(NEI$SCC %in% sccCoal$SCC),]

# Extract emission data for Baltimore City (fips == "24510")
gdf = gdf[which(gdf$fips == "24510"),]

# Group emissions by year produced by motor vehical sources in Baltimore City
gdf = ddply(gdf, c("year"), function(x) c(TOTAL=sum(x$Emissions)))

# Define the plotting device
png("plot5.png",res=58, width=480, height=480) 

# Plot
ggplot(gdf, aes(x=year, y=TOTAL)) + geom_line(color="red") +
  xlab("Year") +
  ylab("Total PM2.5 Emission (Tons)") +
  ggtitle("Total Emission from Motor Vehicle Sources\n in Balitmore City During the Year 1999-2008")+ 
  geom_point(colour="red", size=4, shape=21, fill="white")

# Save to PNG file
dev.off()

# Answer: In Baltimore City, emissions from Motor Vehicle sources have decreased considerably through the years 1999-2008.