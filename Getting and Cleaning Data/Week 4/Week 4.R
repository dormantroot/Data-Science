reviews = read.csv("./Week 4/reviews.csv");
solutions = read.csv("./Week 4/solutions.csv");
head(reviews, 2)
head(solutions, 2)

# sub
names(reviews)
sub("_","",names(reviews),)

# gsub
testName = "this_is_a_test"
gsub("_","",testName)

# using the stringr library
nchar("Jeffrey Leek")

substr("Jeffrey Leek",1,7)
paste("Jeffery","Leek", sep="")


# date
date()
class(date())

class(Sys.Date())
d2 = Sys.Date()
format(d2, "%a %b %d")

x = c("1jan1960","2jan1960","31mar1960","30jul1960"); # creating dates
z = as.Date(x, "%d%b%Y")
z
z[1] - z[2]
