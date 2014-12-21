# question 1
data = read.csv("getdata-data-ss06hid.csv")

dim(data[which(data$VAL > 23),])



# question 2
data$FES


# question 3
rowIndex = 18:23
colIndex = 7:15
data = read.xlsx("getdata-data-DATA.gov_NGAP.xlsx",sheetIndex=1,colIndex=7:15,rowIndex=18:23)
sum(data$Zip*data$Ext,na.rm=T)


# question 4
doc = xmlTreeParse("getdata-data-restaurants.xml",useInternal=TRUE)
rootNode = xmlRoot(doc)
xmlName(rootNode)
names(rootNode)

rootNode[[1]][[2]] #access second element

table(xpathSApply(rootNode,"//zipcode",xmlValue))



# question 4
DT = fread("getdata-data-ss06pid.csv")
names(DT)
DT$pwgtp15

DT[,mean(pwgtp15),by=SEX]

############### DATA TABLE  ############################################
DT = data.table(x=rnorm(9),y=rep(c("a","b","c"),each=3),z=rnorm(9))
DT

tables() # see all tables in memory
DT[2,]   # subsetting
DT[DT$y=="a",]  # subsetting
DT[c(2,3)]      # subsetting

DT[,c(2,3)]     # subsetting columns (this won't work)
DT[,list(mean(x),sum(z))]

DT[,table(y)]   

DT[,w:=z^2]     # adding new column
DT

DT2 = DT        # changing value of column
DT[,y:=2]


DT[,a:=x>0]            # adding a new column
DT


DT[,b:=mean(x+w),by=a]  # new column b, which a mean of x+w and group by a values (TRUE or FALSE)
DT

DT[,u:=mean(x+w),by=z]
DT
