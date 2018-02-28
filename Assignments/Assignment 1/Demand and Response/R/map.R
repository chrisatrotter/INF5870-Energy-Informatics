# Question 2

# Installation of packages
install.packages('lpSolve')
install.packages('magic')
#install.packages('lpSolveAPI')

# Loading of packages
library(lpSolve)
library(magic)
#library(lpSolveAPI)

setwd(getwd())
directory <- 'data/'
appliances_file <- 'simple_appliances.csv'
random_appliances_file <- 'random_appliances.csv'
time.frame <- c(1:24)
peak.hour <- c(17:20)

rtp <- c(runif(16, min=0.1, max=0.5), runif(4, min=0.5, max=1.0), runif(4, min=0.1, max=0.5))

appliances <- read.csv( paste(directory, appliances_file, sep="") )
#random.appliances <- read.csv( paste(directory, random_appliances_file, sep="") )
#appliances <- rbind(appliances, random.appliances[sample(1:nrow(random.appliances), round(runif(1, min=1, max=nrow(random.appliances))), replace = FALSE),])

appliances$timespan <- Map(`:`, appliances$Earliest, appliances$Latest)

# Number of appliances
appliances.length <- length(appliances$Appliances)

#appliances
number.of.constraints <- sum(sapply(appliances$timespan, function(x){sum(length(x))}))

daily.usage.constraint <- t(lapply(appliances$timespan, function(x){matrix(unlist(mapply( time.frame, FUN=function(y) if( y %in% x ) 1 else 0 )),ncol = length(time.frame), byrow = TRUE)}))
#daily.usage.constraint
#daily.usage.constraint <- do.call(bdiag, daily.usage.constraint)
#daily.usage.constraint <- 
daily.usage.constraint <- do.call(adiag, daily.usage.constraint)
#daily.usage.constraint
#daily.usage.constraint <- split(daily.usage.constraint, ceiling(seq_along(daily.usage.constraint)/24))
#daily.usage.constraint <- diag(daily.usage.constraint)
#daily.usage.constraint


hourly.usage.constraint <- t(sapply(appliances$timespan, function(x){mapply( time.frame, FUN=function(y) if( y %in% x ) rep(c(0,1,0), times=c(y-1, 1, length(time.frame)-y )) )}))
#hourly.usage.constraint <- do.call(rbind, hourly.usage.constraint)
hourly.usage.constraint <- sapply(hourly.usage.constraint, function(x){if(is.list(x)) matrix(as.numeric(unlist(x)),ncol = length(time.frame), byrow = TRUE)  else x })
hourly.usage.constraint <- do.call(adiag, hourly.usage.constraint)
#hourly.usage.constraint

#f.con <- rbind(daily.usage.constraint, hourly.usage.constraint)
#hourly.usage.constraint <- matrix(hourly.usage.constraint, nrow = number.of.constraints, ncol = length(time.frame), byrow = TRUE)
#test1 <- appliances.length*length(time.frame)

#hourly.usage.constraint <- lapply(hourly.usage.constraint , function(x) split(x, ceiling(seq_along(x)/length(time.frame))))
#hourly.usage.constraint <- t(sapply(hourly.usage.constraint, '[', 1:max(sapply(hourly.usage.constraint, length))))
#hourly.usage.constraint <- do.call(rbind, hourly.usage.constraint)
#hourly.usage.constraint <- diag(hourly.usage.constraint)
#hourly.usage.constraint
#hourly.usage.constraint <- do.call(diag,)
#hourly.usage.constraint <- do.call(rbind, lapply(hourly.usage.constraint, FUN = function(x) split(x, ceiling(seq_along(x)/length(time.frame)))))
  
#test1 <- c(unlist(sapply(appliances$timespan, function(x){length(x)})))
#test1

#test3 <- split(hourly.usage.constraint, rep(hourly.usage.constraint, test1))
#test3

#test2 <- hourly.usage.constraint[0:test1[1]]
#test2 <- split(test2, ceiling(seq_along(test2)/24))
#test2

#hourly.usage.constraint
#hourly.usage.constraint <- split(hourly.usage.constraint, sample(rep(hourly.usage.constraint, test2)))
#test2
#hourly.usage.constraint
#test2 <- c(unlist(sapply(appliances$timespan, function(x){length(x)*length(time.frame)})))
#hourly.usage.constraint <- split(hourly.usage.constraint, factor(test2), lex.order = FALSE)

#hourly.usage.constraint <- split(hourly.usage.constraint, ceiling(seq_along(hourly.usage.constraint)/24))
#colnames(hourly.usage.constraint) <- appliances$Appliances
#hourly.usage.constraint

#colnames(daily.usage.constraint) <- appliances$Appliances
#daily.usage.constraint

#hourly.usage.constraint <- split(hourly.usage.constraint, sample(rep(hourly.usage.constraint, sapply(appliances$timespan, function(x){length(x)*length(time.frame)}))))
#hourly.usage.constraint



f.obj <- c(rep(rtp, appliances.length ))

#f.con <- matrix(c(daily.usage.constraint, hourly.usage.constraint), ncol = appliances.length*length(time.frame), nrow = appliances.length+number.of.constraints, byrow = TRUE)
#f.con <- matrix(c(all.constraints), nrow = number.of.constraints+appliances.length, byrow = TRUE)

f.con <- rbind(daily.usage.constraint, hourly.usage.constraint)
#f.con

f.dir <- c(rep("=", appliances.length), rep("<=", number.of.constraints))

f.rhs <- c(appliances$Daily.Usage, unlist(mapply(function(x, y){rep(x, length(y))}, appliances$Hourly.Usage, appliances$timespan )))

#my_lp <- data.frame(f.obj, f.con, f.dir, f.rhs)
#my_lp

lp("min", f.obj, f.con, f.dir, f.rhs)

detach(package:lpSolve)
#detach(package:lpSolveAPI)
