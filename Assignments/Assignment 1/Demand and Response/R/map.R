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

appliances
number.of.constraints <- sum(sapply(appliances$timespan, function(x){sum(length(x))}))
number.of.constraints

daily.usage.constraint <- sapply(appliances$timespan, function(x){mapply( time.frame, FUN=function(y) if( y %in% x ) 1 else 0 )})
daily.usage.constraint

hourly.usage.constraint <- sapply(appliances$timespan, function(x){mapply( time.frame, FUN=function(y) if( y %in% x ) rep(c(0,1,0), times=c(y-1, 1, length(time.frame)-y )) )})

#hourly.usage.constraint <- subset(hourly.usage.constraint, !is.null(hourly.usage.constraint))

#hourly.usage.constraint <- hourly.usage.constraint[!is.null(hourly.usage.constraint)]

hourly.usage.constraint <- Filter(function(x) !is.null(x), hourly.usage.constraint)
hourly.usage.constraint

#hourly.usage.constraint <- sapply( daily.usage.constraint, function(x){ mapply(x, FUN=function(y)
#  if( y == 1 )
#    if(which(y == 1)%%length(time.frame) == 0)
#      rep(c(0,1), times = c(23, 1))
#    else rep(c(0,1,0), times = c(which(y == 1)%%length(time.frame)-1), which(y == 1)%%length(time.frame), length(time.frame)-which(y == 1)%%length(time.frame)+1 ) ) ) } )
#hourly.usage.constraint


# Need to generate each constraint row.
# f.cons = matrix (c(), nrow = number.of.constraints, byrow = TRUE)



