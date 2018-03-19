# Demand Respons Management
DRM <- function(daily.rates, appliances){
  # Number of appliances
  a.length <- length(appliances$Appliances)
  
  # Create a matrix with constraints
  constraints <- matrix(0, a.length+(a.length*24), a.length*24)
  
  # Create list with daily and hourly usage
  usage <- rep(0,a.length+(a.length*24))
  
  # Insert values into constraints and usage
  for(i in 1:a.length) {
    usage[i] <- appliances$Daily.Usage[i]
    for(y in appliances$Earliest[i]:appliances$Latest[i]) {
      constraints[i, ((i-1)*24)+y] <- 1
      constraints[((i-1)*24)+a.length+y, ((i-1)*24)+y] <- 1
      usage[((i-1)*24)+a.length+y] <- appliances$Hourly.Usage[i]
    }
  }
  
  # Add price matrix
  f.obj = rep(daily.rates, a.length)
  
  # Add constraints matrix
  f.con <- constraints
  
  # Add operators
  f.dir <- c(rep("=", a.length),rep("<=", a.length*24))
  
  # Add usage matrix
  f.rhs <- matrix(usage, nrow=length(usage), byrow=TRUE)
  
  # Run lp
  return (lp ("min", f.obj, f.con, f.dir, f.rhs))
}
