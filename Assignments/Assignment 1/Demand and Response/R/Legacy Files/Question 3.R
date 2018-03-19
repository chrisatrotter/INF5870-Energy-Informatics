# Question 3
library(lpSolve)

# import DRM
source(paste(getwd(), "/R/DRM.R", sep=""))

# Pricing Scheme: Real Time Pricing
daily.rates <- c(runif(16, min=0.1, max=0.5), runif(4, min=0.5, max=1.0), runif(4, min=0.1, max=0.5))

# Read in data set with applliances
setwd(getwd())
directory <- 'data/'
appliance_file <- 'appliances.csv'
random_appliance_file <- 'random_appliances.csv'

# Read in data set with applliances
appliances <- read.csv( paste(directory, appliance_file, sep="") )
random.appliance <- read.csv( paste(directory, random_appliance_file, sep="") )

# Select appliances and a set of random appliances
selected.appliances <- rbind(appliances, random.appliance[sample(1:nrow(random.appliance), round(runif(1, min=1, max=nrow(random.appliance))), replace = FALSE),])

# Calculate DRM for given houshold
CalculateHousholds <- function(element) {
  # 10 housholds wihtout EV
  if(element <= 10) {
    return (DRM(daily.rates, rbind(appliances[-10,], random.appliance[sample(nrow(random.appliance), 3, replace = FALSE),])))
  }
  return (DRM(daily.rates, rbind(appliances, random.appliance[sample(nrow(random.appliance), 3, replace = FALSE),])))
}

# Calculate DRM for neighbourhood
solution <- sum(mapply(CalculateHousholds, c(1:30)))

solution

