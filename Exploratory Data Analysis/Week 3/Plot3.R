##-----------------------------------------------------------------------------
## The following code assumes that files 'summarySCC_PM25.rds' and 
## 'Source_Classification_Code.rds' exist in your working directory
#
# Question 3 : Of the four types of sources indicated by the type 
# (point, nonpoint, onroad, nonroad) variable, which of these four sources have 
# seen decreases in emissions from 1999–2008 for Baltimore City? Which have seen 
# increases in emissions from 1999–2008? Use the ggplot2 plotting system to make 
# a plot answer this question.
##-----------------------------------------------------------------------------
# Read the rd file contents
NEI = readRDS("summarySCC_PM25.rds")
SCC = readRDS("Source_Classification_Code.rds")

# Extract emission data for Baltimore City (fips == "24510")
gdf = NEI[which(NEI$fips == "24510"),]

# For the city of Baltimore, group emissions by year across all sources and find the total emission for each of the years
gdf = ddply(gdf, c("type","year"), function(x) c(TOTAL=sum(x$Emissions)))

# Define the plotting device
png("plot3.png",res=58, width=480, height=480) 

# Plot
ggplot(gdf, aes(x=year, y=TOTAL, colour=type)) + geom_line() +
  xlab("Year") +
  ylab("Total PM2.5 Emission (Tons)") +
  ggtitle("Total Emission from PM2.5 in Baltimore City \nFrom Different Sources During the Year 1999-2008") +
  scale_colour_discrete(name = "Emission \nSource Type")+ 
  geom_point(colour="red", size=4, shape=21, fill="white")

# Save to PNG file
dev.off()

# Answer: Sources that have seen DECREASES in emission from 1999-2008 for Baltimore City:
#         NONPOINT
#         NON-ROAD
#         ON-ROAD

#         Sources that have seen INCREASES in emission from 1999-2008 for Baltimore City:
#         POINT