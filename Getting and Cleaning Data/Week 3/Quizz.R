# question 1
houseHoldData = read.csv("./Week 3/getdata-data-ss06hid.csv")
x = houseHoldData[,c("ACR","AGS")]
agricultureLogical = ifelse((X$ACR == "3" & X$AGS =="6"), TRUE, FALSE)
str(agricultureLogical)
which(agricultureLogical)


# question 2
file.info("./Week 3/getdata-jeff.jpg")
img = readJPEG("./Week 3/getdata-jeff.jpg", native=TRUE)
quantile(img, probs=c(0.30, 0.80))


# question 3
gdp = read.csv("./Week 3/getdata-data-GDP.csv")
edu = read.csv("./Week 3/getdata-data-EDSTATS_Country.csv")

eduSubset = edu[,c("CountryCode","Income.Group","Long.Name")]  # retrieve 'CountryCode' & 'Income.Group' columns from edu dataset
# gdpSubset = gdp[(!gdp$X.3 %in% c("..","(millions of", "US dollars)","")),c("X","X.3")] # from gdp dataset return those observations where the values in 'X.3' column doesn't
#                                                                                        # belong to any of these values - c("..","(millions of", "US dollars)",""). Furthermore, only return
#                                                                                        # 'X' & 'X.3' columns from the resulting dataset


gdpSubset = gdp[grep("^[0-9]+$",gdp$Gross.domestic.product.2012, perl=TRUE, value=FALSE),c("X","X.3","Gross.domestic.product.2012")] # find those obs from gdp where the ranking is from
                                                                                                                                     # 1 to 190
names(gdpSubset)[3] = "Ranking" # Rename column for usability

mergedData = merge(gdpSubset,eduSubset,by.x="X",by.y="CountryCode",all=FALSE)  # match eduSubset and gdpSubset based on 'CountryCode' & 'gdp' columns respectively; FALSE indicate that only 
                                                                               # those rows that match in both datasets
mergedData$Ranking = factor(mergedData$Ranking)  # Since the unwanted levels where removed in the above, update the dataset 'mergedData' using the factor function
formatLevel <- function (x)   # function to format the level as it contains unwanted characters : , " "
{
  gsub(",+","",gsub("^\\s+|\\s+$", "", x))
}

mergedData$Ranking = as.numeric(formatLevel(as.character(mergedData$Ranking))) # Convert all of the factors into numeric.
mergedData[order(-mergedData$Ranking),][13,]   # sort the 'mergedData' dataset by decreasing GDP rank




# question 3
x = mean(mergedData[which(mergedData$Income.Group == "High income: OECD"),c("Ranking")])
y = mean(mergedData[which(mergedData$Income.Group == "High income: nonOECD"),c("Ranking")])



# question 4
q = quantile(mergedData$Ranking, c(0, 0.2,0.5,0.75,0.80)) # quantiles for the Ranking; we'll use this group the mergedData. I selected these prob - 0, 0.2,0.5,0.75,0.80 b/c
                                                          # in finding the top 38 high ranking countries. Using those probs gave me these groups - 1.0  38.6  95.0 143.0 152.4 
table(cut(mergedData$Ranking, breaks=q), mergedData$Income.Group)  # cuts the mergedData into groups;  1.0  38.6  95.0 143.0 152.4 and further group them by income.groups


