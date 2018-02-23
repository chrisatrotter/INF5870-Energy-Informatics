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

daily.rates <- data.frame( time.frame, rtp )
names( daily.rates ) <- c( "time", "cost" )

# Number of appliances
appliances.length <- length(appliances$Appliances)

f.obj = rep(daily.rates$cost, appliances.length)

appliances
number.of.constraints <- appliances.length + sum(sapply(appliances$timespan, function(x){sum(length(x))}))
number.of.constraints

# Need to generate each constraint row.
# f.cons = matrix (c(), nrow = number.of.constraints, byrow = TRUE)



