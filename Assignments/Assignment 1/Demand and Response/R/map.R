# Question 2

library(lpSolveAPI)

setwd(getwd())
directory <- 'data/'
appliances_file <- 'appliances.csv'
random_appliances_file <- 'random_appliances.csv'
time.frame <- c(1:24)
peak.hour <- c(17:20)

rtp <- c(runif(16, min=0.1, max=0.5), runif(4, min=0.5, max=1.0), runif(4, min=0.1, max=0.5))

appliances <- read.csv( paste(directory, appliances_file, sep="") )

random.appliances <- read.csv( paste(directory, random_appliances_file, sep="") )

appliances <- rbind(appliances, random.appliances[sample(1:nrow(random.appliances), round(runif(1, min=1, max=nrow(random.appliances))), replace = FALSE),])

appliances$timespan <- Map(`:`, appliances$Earliest, appliances$Latest)

# Number of appliances
appliances.length <- length(appliances$Appliances)

f.obj = rep(rtp, appliances.length)

#appliances
number.of.constraints <- sum(sapply(appliances$timespan, function(x){sum(length(x))}))
#number.of.constraints

daily.usage.constraint <- unlist(sapply(appliances$timespan, function(x){mapply( time.frame, FUN=function(y) if( y %in% x ) 1 else 0 )}))
daily.usage.constraint <- split(daily.usage.constraint, ceiling(seq_along(daily.usage.constraint)/24))
#daily.usage.constraint

hourly.usage.constraint <- unlist(sapply(appliances$timespan, function(x){unlist(lapply( time.frame, FUN=function(y) if( y %in% x ) rep(c(0,1,0), times=c(y-1, 1, length(time.frame)-y )) ))}))
hourly.usage.constraint <- split(hourly.usage.constraint, ceiling(seq_along(hourly.usage.constraint)/24))

all.constraints <- c(daily.usage.constraint, hourly.usage.constraint)
#all.constraints

f.cons = matrix(c(all.constraints, nrow = number.of.constraints+appliances.length, byrow=TRUE))




