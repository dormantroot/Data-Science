# Question 1
survey = read.csv("./Week 4/american_community_survey.csv");
names(survey)
splitNames = strsplit(names(survey), "wgtp")
splitNames[123]


# Question 2
rank = read.csv("./Week 4/gross_domestic_product_rank.csv");
head(rank,10)
rank$X.3
gdpSubset = rank[grep("^[0-9]+$",rank$Gross.domestic.product.2012, perl=TRUE, 
                        value=FALSE),c("X","X.3","Gross.domestic.product.2012")] # find those obs from gdp where the ranking is from # 1 to 190

formatLevel <- function (x)   # function to format the level as it contains unwanted characters : , " "
{
  gsub(",+","",gsub("^\\s+|\\s+$", "", x))
}

gdpSubset$X.3 = as.numeric(formatLevel(as.character(gdpSubset$X.3))) # Convert all of the factors into numeric.

names(gdpSubset)
summary(gdpSubset$X.3)
mean(gdpSubset$X.3)


# Question 3
rank = read.csv("./Week 4/gross_domestic_product_rank.csv");
rank$X.2                                                                           
grep("^United",rank$X.2)
rank[c(5,10,36),]


# Question 4
gdp = read.csv("./Week 4/gross_domestic_product_rank.csv");
edu = read.csv("./Week 4/educational_data.csv");

mergedData = merge(gdp,edu,by.x="X",by.y="CountryCode",all=FALSE)  # match eduSubset and gdpSubset based on 'CountryCode' & 'gdp' columns respectively; FALSE indicate that only 
                                                                  # those rows that match in both datasets
mergedData$Special.Notes
mergedData[grep("^Fiscal year end: June 30",edu$Special.Notes),]$Special.Notes
head(mergedData,20)


# Question 5
library(quantmod)
amzn = getSymbols("AMZN", auto.assign=FALSE)
sampleTimes = index(amzn)
sampleTimes

length(grep("^2012",sampleTimes))  # values collected in 2012
length(grep("Monday",weekdays(sampleTimes[grep("^2012",sampleTimes)]))) # number of values collected in 2012, specifically on a Monday


