#library
library(neuralnet)

# Read in data set with applliances
setwd(getwd())

directory <- '../data/'
solution_data_file <- 'Solution.csv'
training_data_file <- 'TrainData.csv'
weather_forecast_input_file <- 'WeatherForecastInput.csv'

# Read in data set with applliances
training_data <- read.csv( paste(directory, training_data_file, sep=""))
solution_data <- read.csv( paste(directory, solution_data_file, sep=""))
input <- read.csv(paste(directory, weather_forecast_input_file, sep=""))

training_data_sample <- training_data[12001:15000,]
testData <- training_data[15001:15336,]


powerModel <- neuralnet(training_data_sample$POWER ~ training_data_sample$WS10, data = training_data_sample, hidden=10)

# generate the prediction on the test data
modelResults <- compute(powerModel, testData$WS10)
powerPredictionNN <- modelResults$net.result

# plot the neural networks
plot(powerModel)

rmse <- function(error)
{
  sqrt(mean(error^2))
}

# calculate error
errorNN <- powerPredictionNN - testData$POWER

rmse(errorNN)