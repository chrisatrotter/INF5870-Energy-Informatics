#library
library(neuralnet)

# Read in data set with applliances
setwd(getwd())
directory <- '../data/'
solution_data_file <- 'Solution.csv'
training_data_file <- 'TrainData.csv'
weather_forecast_input_file <- 'WeatherForecastInput.csv'

# Read in data set with applliances
training_data <- read.csv( paste(directory, training_data_file, sep="") )
solution_data <- read.csv( paste(directory, solution_data_file, sep="") )
testData <- read.csv(paste(directory, weather_forecast_input_file, sep=""))
testData

powerModel <- neuralnet(training_data$POWER ~ training_data$WS10, data = training_data, hidden=10)

# generate the prediction on the test data
modelResults <- compute(powerModel, testData$WS10)
powerPredictionNN <- modelResults$net.result

# plot the neural networks
plot(powerModel)

# calculate error
