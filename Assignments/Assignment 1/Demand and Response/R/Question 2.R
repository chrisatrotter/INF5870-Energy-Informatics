# Question 2

setwd(getwd())
directory <- 'data/'
appliance_file <- 'appliances.csv'
random_appliance_file <- 'random-appliances.csv'
time_frame <- c(1:24)
peak_hour <- c(17:20)

RTP <- c(runif(16, min=0.1, max=0.5), runif(4, min=0.5, max=1.0), runif(4, min=0.1, max=0.5))

#RTP

appliances <- read.csv( paste(directory, appliance_file, sep="") )
random_appliance <- read.csv( paste(directory, random_appliance_file, sep="") )
appliances <- rbind(appliances, random_appliance[sample(1:nrow(random_appliance), round(runif(1, min=1, max=nrow(random_appliance))), replace = FALSE),])
appliances

daily_rates <- data.frame( time_frame, RTP )
names( daily_rates ) <- c( "time", "cost" )
daily_rates



#appliances name
#appliances_names_random <- c("coffee maker", "ceiling fan", "hair dryer", "toaster", "microwave", "router", "cellphone charger", "cloth iron")
#appliances_names_shiftable <- c("Washing machine", "Electrical Vehicle", "Diswasher", "dryer")
#appliances_names_nonshiftable <- c("Lighting", "Heating", "Refrigerator-freezer", "Electric stove", "TV","Computer")

#appliances costs
#appliances_costs_shiftable <- c(1.94, 9.9, 1.44, 2.5)
#appliances_costs_nonshiftable <- c(runif(1, min=1, max=2), runif(1, min=6.4, max=9.6), runif(1, min=1.32, max=3.96), 3.9, runif(1, min=0.15, max=0.6), 0.6)
#appliances_costs_random <- c(0.08, 0.0075, 0.0250, 0.0240, 0.0600, 0.0006, 0.0005, 0.0275)

#appliances run time
#appliances_runtime_random <- c(1,3,1,1,1,24,3,1)
#appliances_runtime_shiftable <- c(1, 4, 1, 1)
#appliances <- data.frame( appliances_names, appliances_costs )
#names( appliances ) <- c( "Appliances", "Kwh" )

#gives a random integer
#amount_of_random_appliances <- round(runif(1, min=1, max=8))
#selects random amounts of random appliances
#sample(appliances_names_random,amount_of_random_appliances)

#minimum_cost <- min( mapply( daily_rates$time , sum(appliances$Kwh), FUN=function(time, kwh) daily_rates[time, 2] * kwh ))
#minimum_cost