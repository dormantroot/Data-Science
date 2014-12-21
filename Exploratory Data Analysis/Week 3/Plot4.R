##-----------------------------------------------------------------------------
## The following code assumes that files 'summarySCC_PM25.rds' and 
## 'Source_Classification_Code.rds' exist in your working directory
#
# Question 4 : Across the United States, how have emissions from coal 
# combustion-related sources changed from 1999–2008?
##-----------------------------------------------------------------------------
# Read the rd file contents
NEI = readRDS("summarySCC_PM25.rds")
SCC = readRDS("Source_Classification_Code.rds")

# Find all coal sources
sccCoal = SCC[grep("Coal+", SCC$EI.Sector, perl=TRUE, value=FALSE),]

# Find emission of PM2.5 from coal sources that was recorded through out USA
gdf = NEI[which(NEI$SCC %in% sccCoal$SCC),]

# Group emissions by year produced by coal sources through out USA
gdf = ddply(gdf, c("year"), function(x) c(TOTAL=sum(x$Emissions)))

# Define the plotting device
png("plot4.png",res=58, width=480, height=480) 

# Plot
ggplot(gdf, aes(x=year, y=TOTAL)) + geom_line(color="red") +
  xlab("Year") +
  ylab("Total PM2.5 Emission (Tons)") +
  ggtitle("Total Emission from Coal Sources\n Through Out USA During the Year 1999-2008")+ 
  geom_point(colour="red", size=4, shape=21, fill="white")

# Save to PNG file
dev.off()

# Answer: Across United States, emissions from Coal sources have decreased considerably through the years 1999-2008.