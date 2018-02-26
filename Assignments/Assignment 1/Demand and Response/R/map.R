# Question 2

# Installation of packages
install.packages('lpSolve')
#install.packages('lpSolveAPI')

# Loading of packages
library(lpSolve)
#library(lpSolveAPI)

setwd(getwd())
directory <- 'data/'
appliances_file <- 'simple_appliances.csv'
random_appliances_file <- 'random_appliances.csv'
time.frame <- c(1:24)
peak.hour <- c(17:20)

rtp <- c(runif(16, min=0.1, max=0.5), runif(4, min=0.5, max=1.0), runif(4, min=0.1, max=0.5))

appliances <- read.csv( paste(directory, appliances_file, sep="") )
random.appliances <- read.csv( paste(directory, random_appliances_file, sep="") )
#appliances <- rbind(appliances, random.appliances[sample(1:nrow(random.appliances), round(runif(1, min=1, max=nrow(random.appliances))), replace = FALSE),])

appliances$timespan <- Map(`:`, appliances$Earliest, appliances$Latest)

# Number of appliances
appliances.length <- length(appliances$Appliances)

#appliances
number.of.constraints <- sum(sapply(appliances$timespan, function(x){sum(length(x))}))

daily.usage.constraint <- unlist(sapply(appliances$timespan, function(x){mapply( time.frame, FUN=function(y) if( y %in% x ) 1 else 0 )}))
daily.usage.constraint <- split(daily.usage.constraint, ceiling(seq_along(daily.usage.constraint)/24))

hourly.usage.constraint <- unlist(sapply(appliances$timespan, function(x){unlist(lapply( time.frame, FUN=function(y) if( y %in% x ) rep(c(0,1,0), times=c(y-1, 1, length(time.frame)-y )) ))}))
hourly.usage.constraint <- split(hourly.usage.constraint, ceiling(seq_along(hourly.usage.constraint)/24))

all.constraints <- c(unlist(daily.usage.constraint), unlist(hourly.usage.constraint))


f.obj <- c(rep(rtp, appliances.length ))

#f.con <- matrix(c(daily.usage.constraint, hourly.usage.constraint), ncol = appliances.length*length(time.frame), nrow = appliances.length+number.of.constraints, byrow = TRUE)

#f.con <- matrix(c(all.constraints), nrow = number.of.constraints+appliances.length, byrow = TRUE)
f.dir <- c(rep("=", appliances.length), rep("<=", number.of.constraints))

f.rhs <- c(appliances$Daily.Usage, unlist(mapply(function(x, y){rep(x, length(y))}, appliances$Hourly.Usage, appliances$timespan ))), nrow = appliances.length+number.of.constraints, byrow = TRUE)

my_lp <- data.frame(f.obj, f.con, f.dir, f.rhs)
my_lp

lp("min", f.obj, f.con, f.dir, f.rhs)

detach(package:lpSolve)
#detach(package:lpSolveAPI)
