# Question 1
# What strategy to adopt.
# A centralized strategy of appliances all running within 1 hour time span.
# *Not very realistic, but no limitations have been set to prevent this kind of assumptions.*

peak_hour <- c(17:20)
time_frame <- c(1:24)
peak_price <- 1
off_peak_price <- 0.5

daily_rates <- data.frame( time_frame )
daily_rates$cost <- mapply( daily_rates$time_frame, FUN=function(x) if( x %in% peak_hour ) peak_price else off_peak_price )
names( daily_rates ) <- c( "time", "cost" )

appliances_names <- c("Washing machine", "Electrical Vehicle", "Diswasher")
appliances_costs <- c(1.94, 9.9, 1.44)
appliances <- data.frame( appliances_names, appliances_costs )
names( appliances ) <- c( "Appliances", "Kwh" )

minimum_cost <- min( mapply( daily_rates$time , sum(appliances$Kwh), FUN=function(time, kwh) daily_rates[time, 2] * kwh ))
minimum_cost