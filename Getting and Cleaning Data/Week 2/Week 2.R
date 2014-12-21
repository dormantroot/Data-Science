# connecting to USCS MySQL server
library(RMySQL)
ucscDB = dbConnect(MySQL(), user="genome", host="genome-mysql.cse.ucsc.edu")
result = dbGetQuery(ucscDB,"show databases;");
dbDisconnect(ucscDB)

result


# connecting to hg19 database and listing its tables
hg19 = dbConnect(MySQL(), user="genome", db="hg19", host="genome-mysql.cse.ucsc.edu")
allTables = dbListTables(hg19)
length(allTables)

allTables[1:5]

# getting columns of a specific table
dbListFields(hg19, "affyU133Plus2")

# querying
dbGetQuery(hg19, "select count(*) from affyU133Plus2")

# read entire table
affyData = dbReadTable(hg19, "affyU133Plus2")
head(affyData)

# sub query
query = dbSendQuery(hg19, "select * from affyU133Plus2 where misMatches between 1 and 3")
affyMis = fetch(query)
quantile(affyMis$misMatches)

affyMisSmall = fetch(query, n=10);
dbClearResult(query);
dim(affyMisSmall)

dbDisconnect(hg19)



# question 1
# reading from github
oauth_endpoints("github")
myapp <- oauth_app("jtleek", "dd7fba7b3b3a39cfc1ac","3e76fe70fb009ede82e755d4eb37164e2cf14e15")
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)


req <- GET("https://api.github.com/users/jtleek/repos", config(token = github_token))
stop_for_status(req)
c = content(req)



# question 2
acs = read.csv("getdata-data-ss06pid.csv")
names(acs)
sqldf("select pwgtp1 from acs where AGEP < 50")


# question 3
dim(sqldf("select AGEP from acs"))


# question 4
con = url("http://biostat.jhsph.edu/~jleek/contact.html")
htmlCode = readLines(con)
close(con)
nchar(htmlCode[10])
nchar(htmlCode[20])
nchar(htmlCode[30])
nchar(htmlCode[100])


url = "http://biostat.jhsph.edu/~jleek/contact.html"
html = htmlTreeParse(url, useInternalNodes=T)
html



# question 5
acs = read.fwf(
  file=url("https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for"),
  skip=4,
  widths=c(12, 7,4, 9,4, 9,4, 9,4))

sum(acs$V4)
