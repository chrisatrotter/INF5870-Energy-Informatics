# Question 1
library(lpSolve)
library(ggplot2)
library(gridExtra)

# import DRM
source(paste(getwd(), "/R/DRM.R", sep=""))

# Pricing Scheme: Time of Use
ToU <- c(rep(0.5, 16), rep(1.0, 4), rep(0.5, 4))
# Pricing Scheme: Real Time Pricing
RTP <- c(runif(16, min=0.1, max=0.5), runif(4, min=0.5, max=1.0), runif(4, min=0.1, max=0.5))
# Daily Rates for ToU and RTP
daily.rates <- data.frame(ToU, RTP)
colnames(daily.rates) <- c("ToU", "RTP")

# Read in data set with applliances
setwd(getwd())
directory <- 'data/'
appliance_file <- 'appliances.csv'
random_appliance_file <- 'random_appliances.csv'

# Read in data set with applliances
appliances <- read.csv( paste(directory, appliance_file, sep="") )
random.appliance <- read.csv( paste(directory, random_appliance_file, sep="") )

# Solution for Question 1
Q1 <- function() {
  # Selecting Dishwasher, Laundry Machine and EV
  selected.appliances <- appliances[c(7,8,10),]
  
  # Run DRM
  return (DRM(daily.rates$ToU, selected.appliances))
}

# Solution for Question 2
Q2 <- function() {
  # Select appliances and a set of random appliances
  selected.appliances <- rbind(appliances, random.appliance[sample(nrow(random.appliance), 3, replace = FALSE),])

  # Run DRM
  return (DRM(daily.rates$RTP, selected.appliances))
}

# Solution for Question 3
Q3 <- function() {
  # Calculate DRM for given houshold
  CalculateHoushold <- function(element) {
    # 10 housholds wihtout EV
    if(element <= 10) {
      # Select appliances (no EV) and a set of random appliances, run DRM
      return (DRM(daily.rates$RTP, rbind(appliances[-10,], random.appliance[sample(nrow(random.appliance), 3, replace = FALSE),])))
    }
    # Select appliances and a set of random appliances, run DRM
    return (DRM(daily.rates$RTP, rbind(appliances, random.appliance[sample(nrow(random.appliance), 3, replace = FALSE),])))
  }
  
  # Calculate DRM for neighbourhood (30 housholds)
  return (mapply(CalculateHoushold, c(1:30)))
}

# Run all simulations, retrieve cost
s1 <- Q1()$objval
s2 <- Q2()$objval
s3 <- sum(unlist(Q3()[11,]))

# All solutions in one data set
results <- data.frame(s1, s2, s3)
colnames(results) <- c("Question 1", "Question 2", "Question 3")
rownames(results) <- "Price"


# Create plot for Time-of-Use (ToU)
plot.tou <- ggplot(aes(x=c(1:24), y=ToU), data = daily.rates) +
            geom_bar(stat = 'identity', position = 'dodge') + 
            labs(x = "Hour", y = "Price", title = "Price Scheme: Time-of-Use (ToU)")

# Create plot for Time-of-Use (ToU)
plot.rtp <- ggplot(aes(x=c(1:24), y=RTP), data = daily.rates) +
            geom_bar(stat = 'identity', position = 'dodge') + 
            labs(x = "Hour", y = "Price", title = "Price Scheme: Real-Time-Pricing (RTP)")

# Plot both price schemes
grid.arrange(plot.tou, plot.rtp, nrow = 1)

# Print results
print (results)