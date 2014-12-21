

set.seed(13435)
X = data.frame("var1" = sample(1:5), "var2"=sample(6:10), "var3"=sample(11:15))
X = X[sample(1:5),]; X$var2[c(1,3)] = NA
X

# arrange by var1 column
arrange(X, var1)

# arrange by var1 column/desc
arrange(X, desc(var1))


# download the Balitmore city data
restData = read.csv("./Week 3/restaurants.csv")
head(restData, n=3)
tail(restData, n=3)
summary(restData)

table(restData$zipCode %in% c("21212")) # zipcodes with 21212 in it
restData[restData$zipCode %in% c("21212","21213"),] # zipcodes with 21212 & 21213 in it

# UCBAdmissions data set
data(UCBAdmissions)
DF = as.data.frame(UCBAdmissions)
xtabs(Freq ~ Gender+Admit, data=DF) # contingency table for Gender & Admit w.r.s.t the Freq column

# warpbreaks data set
data(warpbreaks)
warpbreaks
summary(warpbreaks)
xt = xtabs(breaks~., data=warpbreaks)
xt
ftable(xt)


# adding index column to an existing data set
x = c(1,3,6,4,5,59)
seq(along=x) # creating an index
x

# creating a new binary variables and adding it to restData
restData$zipWrong = ifelse(restData$zipCode<0, TRUE, FALSE)
table(restData$zipWrong, restData$policeDistrict)


# create categorical variables using the CUT function
data(warpbreaks)
warpbreaks # cut the warpbreaks$breaks column into the specified groups
group = c(10, 18.25, 26, 34, 70)  # groups to be broken down into
table(cut(warpbreaks$breaks, breaks=group)) # summaries the grouping


restData # cut the restData$zipCode column into the specified groups
q = quantile(restData$zipCode) # quantiles for the zipCode; we'll use this group the zipCodes
table(cut(restData$zipCode, breaks=q))  # cuts the zipCode into groups;  (0%      25%      50%      75%     100% / -21226.0  21202.0  21218.0  21225.5  21287.0 )


# using the mutate function
restData2 =  mutate(restData, zipGroups = cut2(zipCode,g=4)) # creates a new dataframe from the original dataframe:restData 
                                                             # by adding a new column - zipGroups, which a grouping of the zipCode column by it's quantile values
table(restData2$zipGroups)
names(restData2)


# using the reshape function
mtcars   # the standard R dataset
mtcars$carname = rownames(mtcars) # add a new column 'carname' to the original dataset 'mtcars' with the unique car values
carMelt = melt(mtcars, id=c("carname","gear","cyl"), measure.vars=c("mpg","hp")) # create a new melted dataset with only 3 columns (carname, gear & cyl)
                                                                                 # that contain values "mpg" & "hp"
carMelt
