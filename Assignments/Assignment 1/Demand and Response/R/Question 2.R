# Question 2

library(lpSolve)
library(ggplot2)

setwd(getwd())
directory <- 'data/'
appliance_file <- 'appliances.csv'
random_appliance_file <- 'random_appliances.csv'
time.frame <- c(1:24)
peak.hour <- c(17:20)

# Read in data set with applliances
appliances <- read.csv( paste(directory, appliance_file, sep="") )
random.appliance <- read.csv( paste(directory, random_appliance_file, sep="") )
appliances <- rbind(appliances, random.appliance[sample(1:nrow(random.appliance), round(runif(1, min=1, max=nrow(random.appliance))), replace = FALSE),])

# Number of appliances
a.length <- length(appliances$Appliances)


# Function for a randomized price for a given hour
RTP <- c(runif(16, min=0.1, max=0.5), runif(4, min=0.5, max=1.0), runif(4, min=0.1, max=0.5))

# Create a matrix with RTP for a day
daily.rates <- data.frame( time.frame, RTP )
names( daily.rates ) <- c( "time", "cost" )

# Add price matrix
f.obj = rep(daily.rates$cost, a_length)

# Create a matrix with constraints
constraints <- matrix(0, a.length+(a.length*24), a.length*24)

# Create list with daily and hourly usage
usage <- rep(0,a.length+(a.length*24))

# Insert values into constraints and usage
for(i in 1:a.length) {
  usage[i] <- appliances$Daily.Usage[i]
  for(y in appliances$Earliest[i]:appliances$Latest[i]) {
    constraints[i, ((i-1)*24)+y] <- 1
    constraints[((i-1)*24)+a.length+y, ((i-1)*24)+y] <- 1
    usage[((i-1)*24)+a.length+y] <- appliances$Hourly.Usage[i]
  }
}

# Add matrix with constraints
f.con <- constraints

# Add operator
f.dir <- c(rep("=", a.length),rep("<=", a.length*24))

# Add matrix with usage
f.rhs <- matrix(usage, nrow=length(usage), byrow=TRUE)

# Run lp
result <- lp ("min", f.obj, f.con, f.dir, f.rhs)


##########
## PLOT ##
##########

appliance.usage <- data.frame( time_frame, colSums(matrix(result$solution, nrow=alength, ncol=24, byrow = TRUE)) )
names( appliance.usage ) <- c( "time", "usage" )

fill <- "#4271AE"
line <- "#1F3552"


p1 <- ggplot(aes(x=time, y=cost), data = daily.rates) +
  geom_bar(stat = 'identity', position = 'dodge')

p2 <- ggplot(aes(x=time, y=usage), data = appliance.usage) +
  geom_bar(stat = 'identity', position = 'dodge')

p2