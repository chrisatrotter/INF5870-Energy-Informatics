# Question 2

library(lpSolveAPI)

setwd(getwd())
directory <- 'data/'
appliance_file <- 'appliances.csv'
random_appliance_file <- 'random-appliances.csv'
time_frame <- c(1:24)
peak_hour <- c(17:20)

# Function for a randomized price for a given hour
RTP <- c(runif(16, min=0.1, max=0.5), runif(4, min=0.5, max=1.0), runif(4, min=0.1, max=0.5))

# Read in data set with applliances
appliances <- read.csv( paste(directory, appliance_file, sep="") )
random_appliance <- read.csv( paste(directory, random_appliance_file, sep="") )
appliances <- rbind(appliances, random_appliance[sample(1:nrow(random_appliance), round(runif(1, min=1, max=nrow(random_appliance))), replace = FALSE),])

# Number of appliances
a_length <- length(appliances$Appliances)

appliances$Daily.Usage <- as.numeric(as.character(appliances$Daily.Usage))
appliances$Hourly.Usage <- as.numeric(as.character(appliances$Hourly.Usage))
appliances$Earliest <- as.numeric(as.character(appliances$Earliest))
appliances$Latest <- as.numeric(as.character(appliances$Latest))

typeof(appliances$Daily.Usage[1])

# Create a matrix with RTP for a day
daily_rates <- data.frame( time_frame, RTP )
names( daily_rates ) <- c( "time", "cost" )

# Add price matrix
f.obj = rep(daily_rates$cost, a_length)

# Create a matrix with constraints
constraints <- matrix(0, a_length+(a_length*24), a_length*24)
for(i in 1:a_length) {
  for(y in 1:24) {
    if (y >= appliances$Earliest[i] && y <= appliances$Latest[i]) {
      constraints[i, ((i-1)*24)+y] <- 1
      constraints[((i-1)*24)+a_length+y, ((i-1)*24)+y] <- 1
    }
  }
}

# Add matrix with constraints
f.con <- constraints

# Add operator
f.dir <- c(rep("=", a_length),rep("<=", a_length*24))

# Create list with daily and hourly usage
usage <- rep(0,a_length+(a_length*24))
for (i in 1:a_length) {
  usage[i] <- appliances$Daily.Usage[i]
  for(y in 1:24){
    usage[((i-1)*24)+a_length+y] <- appliances$Hourly.Usage[i]
  }
}

# Add matrix with usage
f.rhs <- matrix(usage, nrow=length(usage), byrow=TRUE)

length(rep(daily_rates$cost, a_length))
dim(constraints)
length(c(rep("=", a_length),rep("<=", a_length*24)))
length(usage)

# Run lp
lp ("min", f.obj, f.con, f.dir, f.rhs)