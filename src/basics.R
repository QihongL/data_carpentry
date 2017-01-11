# init 
rm(list=ls());
library(dplyr);
library(ggplot2);
qplot(Sepal.Length, Petal.Length, data = iris, color = Species)

datapath = '../data_carpentry/data/raw/'
dataURL = 'http://kbroman.org/datacarp/portal_data_joined.csv'
fname = 'portal_data_joined.csv'
# read local data 
surveys = read.csv(paste(datapath,fname,sep=''))
# read data from URL
surveys = read.csv(paste(datapath,"portal_data_joined.csv",sep=''))
# download data
download.file(dataURL,paste(datapath,"portal_data_joined_DL.csv",sep=''))

# summary
head(surveys)
summary(surveys)
str(surveys)

# subset 
surveys[2,3]
surveys[2,]
surveys[,7]
surveys['sex']
surveys$sex
surveys$sex[10]

# indexing
surveys$sex[1:10]
surveys$sex[c(1,3,4)]
surveys[1,1:10]
surveys_by_10 = surveys[seq(10, nrow(surveys), by=10),]

# vector
c(1,3,4)
1:10
seq(1,10)
seq(10,1,by=-2)
seq(1,10,length = 5)


# matrix operations
X = replicate(3, rnorm(4)) # 4x3 matrix
b = c(1,3,4) # 3x1 vector (column vec by default)
X * b

# NA values
x = c(1,2,NA)
mean(x)
x[!is.na(x)]
mean(x, na.rm = T) == mean(x[!is.na(x)])

# read in the data, treating empty cell as "NA"
surveys_noblanks = read.csv(paste(datapath,fname,sep=''), na.strings = "")
summary(surveys_noblanks)
head(surveys_noblanks)
str(surveys_noblanks)

# factor
sex = factor(c("m","f","f","m",'f'))
levels(sex)
sex = factor(c("m","f","f","m",'f'), levels = c('m','f')) # re-order the levels 
levels(sex)
nlevels(sex)
table(sex)

surveys_chr = read.csv(paste(datapath,fname,sep=''), stringsAsFactors = F) 
str(surveys_chr) # now they are char strings (instead of factors)
