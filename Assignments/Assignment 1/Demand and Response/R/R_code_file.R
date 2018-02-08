
# Question 1
# What strategy to adopt.

peak_hour <- c(5:8)
time_frame <- c(1:24)
peak_price <- 1
off_peal_price <- 0.5

appliances_names <- c("Washing machine", "Electrical Vehicle", "Diswasher")
appliances_costs <- c(1.94, 9.9, 1.44)
appliances <- data.frame( appliances_names, appliances_costs )
names( appliances ) <- c( "Appliances", "Energy cost" )

daily_rates <- data.frame()