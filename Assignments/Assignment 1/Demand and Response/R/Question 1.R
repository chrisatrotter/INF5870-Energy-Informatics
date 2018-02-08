# Question 1
# What strategy to adopt.

peak_hour <- c(17:20)
time_frame <- c(1:24)
peak_price <- 1
off_peak_price <- 0.5

daily_rates <- data.frame( time_frame )
daily_rates$cost <- mapply( daily_rates$time_frame, FUN=function(x) if( x %in% peak_hour ) peak_price else off_peak_price )
names( daily_rates ) <- c( "time", "cost" )

appliances_names_random <- c("coffee maker", "ceiling fan", "hair dryer", "toaster", "microwave", "router", "cellphone charger", "cloth iron")
appliances_names_shiftable <- c("Washing machine", "Electrical Vehicle", "Diswasher", "dryer")
appliances_names_nonshiftable <- c("Lighting", "Heating", "Refrigerator-freezer", "Electric stove", "TV","Computer")
appliances_costs_shiftable <- c(1.94, 9.9, 1.44, 2.5)
appliances_costs_nonshiftable <- c(runif(1, min=1, max=2), runif(1, min=6.4, max=9.6), runif(1, min=1.32, max=3.96), 3.9, runif(1, min=0.15, max=0.6), 0.6)
appliances <- data.frame( appliances_names, appliances_costs )
names( appliances ) <- c( "Appliances", "Kwh" )

#gives a random integer
amount_of_random_appliances <- round(runif(1, min=1, max=8))
#selects random amounts of random appliances
sample(appliances_names_random,amount_of_random_appliances)

minimum_cost <- min( mapply( daily_rates$time , sum(appliances$Kwh), FUN=function(time, kwh) daily_rates[time, 2] * kwh ))
minimum_cost
