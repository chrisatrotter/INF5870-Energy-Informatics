#library(h2o)

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

# training the neuralnet with the 3000 training data (12001 - 15000)
powerModel <- neuralnet(training_data_sample$POWER ~ training_data_sample$WS10, data = training_data_sample, hidden=10,stepmax=1e5)

# generate the prediction on the test data
modelResults <- compute(powerModel, input$WS10)
powerPredictionNN <- modelResults$net.result

# plot the neural networks
plot(powerModel)

# root mean square error function
rmse <- function(error)
{
  sqrt(mean(error^2))
}

# calculate error
errorNN <- powerPredictionNN - solution_data$POWER

rmse(errorNN)

write.table(powerPredictionNN, "ForecastTemplate1-NN.csv", sep=",", col.names="Power Prediction", row.names = F)