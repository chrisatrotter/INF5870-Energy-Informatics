# Question 2

# Installation of packages
install.packages('lpSolve')
install.packages('magic')
#install.packages('lpSolveAPI')

# Loading of packages
library(lpSolve)
library(magic)
#library(lpSolveAPI)

setwd(getwd())
directory <- 'data/'
appliances_file <- 'appliances.csv'
random_appliances_file <- 'random_appliances.csv'
time.frame <- c(1:24)
peak.hour <- c(17:20)

# Create a randomized real time pricing scheme.
rtp <- c(runif(16, min=0.1, max=0.5), runif(4, min=0.5, max=1.0), runif(4, min=0.1, max=0.5))

# Read in the given set of appliances.
appliances <- read.csv( paste(directory, appliances_file, sep="") )

# Read in random appliances.
random.appliances <- read.csv( paste(directory, random_appliances_file, sep="") )

# Select a random sample of appliances.
random.appliances <- random.appliances[sample(1:nrow(random.appliances), round(runif(1, min=1, max=nrow(random.appliances))), replace = FALSE),]

# Merge both given appliances and random appliances into same dataframe.
appliances <- merge(appliances, random.appliances, all = TRUE)

# Create a new column which is a list of every hour between earliest and latest.
appliances$timespan <- Map(`:`, appliances$Earliest, appliances$Latest)

# Number of appliances
appliances.length <- length(appliances$Appliances)

# Number of constraints
number.of.constraints <- sum(sapply(appliances$timespan, function(x){sum(length(x))}))

# Creating a list of matrices of daily usage constraints to be formatted correctly for LP.
daily.usage.constraint <- t(lapply(appliances$timespan, function(x){matrix(unlist(mapply( time.frame, FUN=function(y) if( y %in% x ) 1 else 0 )),ncol = length(time.frame), byrow = TRUE)}))
daily.usage.constraint <- do.call(adiag, daily.usage.constraint)

# Create a list of matrices of hourly usage constraints to be formatted correctly for LP.
hourly.usage.constraint <- t(sapply(appliances$timespan, function(x){mapply( time.frame, FUN=function(y) if( y %in% x ) rep(c(0,1,0), times=c(y-1, 1, length(time.frame)-y )) )}))
hourly.usage.constraint <- sapply(hourly.usage.constraint, function(x){if(is.list(x)) matrix(as.numeric(unlist(x)),ncol = length(time.frame), byrow = TRUE)  else x })
hourly.usage.constraint <- do.call(adiag, hourly.usage.constraint)

# Structuring the necessary values for LP.
f.obj <- c(rep(rtp, appliances.length ))
f.con <- rbind(daily.usage.constraint, hourly.usage.constraint)
f.dir <- c(rep("=", appliances.length), rep("<=", number.of.constraints))
f.rhs <- c(appliances$Daily.Usage, unlist(mapply(function(x, y){rep(x, length(y))}, appliances$Hourly.Usage, appliances$timespan )))

# Calculate LP
lp("min", f.obj, f.con, f.dir, f.rhs)
lp("min", f.obj, f.con, f.dir, f.rhs)$solution

detach(package:lpSolve)