# Question 1
library(lpSolve)


# import DRM
source(paste(getwd(), "/R/DRM.R", sep=""))

# Pricing Scheme: Time of Use
daily.rates <- c(rep(0.5, 16), rep(1.0, 4), rep(0.5, 4))

# Read in data set with applliances
setwd(getwd())
directory <- 'data/'
appliance_file <- 'appliances.csv'
random_appliance_file <- 'random_appliances.csv'
appliances <- read.csv(paste(directory, appliance_file, sep=""))

# Selecting Dishwasher, Laundry Machine and EV
selected.appliances <- appliances[c(7,8,10),]

# Run DRM
solution <- DRM(daily.rates, selected.appliances)

solution