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
#appliances$timespan <- (function(x) x)(appliances[appliances$Appliances,])
#within(appliances, {timespan <- Map(Earliest, Latest, list); appliances})

#appliances$timespan <- mapply(list, appliances$Earliest, appliances$Latest)
#appliances

#earliest <- list(appliances$Earliest)
#latest <- list(appliances$Latest)

#appliances <- map(earliest, latest, list)

#timespan <- with(appliances, seq(earliest, latest, 1))
#appliances$timespan <- (function(x, y) list(x:y))(appliances$Earliest, appliances$Latest)
#timespan
#appliances$timespan <- list(appliances[appliances$Appliances,4]:appliances[appliances$Appliances,5])

#appliances$timespan <- with(appliances, Earliest+Latest)
#appliances

appliances$timespan <- Map(`:`, appliances$Earliest, appliances$Latest)
appliances


random_appliance <- read.csv( paste(directory, random_appliance_file, sep="") )
appliances <- rbind(appliances, random_appliance[sample(1:nrow(random_appliance), round(runif(1, min=1, max=nrow(random_appliance))), replace = FALSE),])
appliances

daily_rates <- data.frame( time_frame, RTP )
names( daily_rates ) <- c( "time", "cost" )
daily_rates


p <- rep(daily_rates$cost, length(appliances$Appliances))

