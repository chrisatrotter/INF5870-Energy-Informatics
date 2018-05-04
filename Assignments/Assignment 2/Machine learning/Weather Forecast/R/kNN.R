
#install.packages("RWeka", dependencies = TRUE)
#install.packages("FNN", dependencies = TRUE)

#library
#library(RWeka)
library(FNN)

# Read in data set with applliances
setwd(getwd())

directory <- './data/'
solution_data_file <- 'Solution.csv'
training_data_file <- 'TrainData.csv'
weather_forecast_input_file <- 'WeatherForecastInput.csv'

# Read in data set with applliances
training_data <- read.csv( paste(directory, training_data_file, sep=""))
solution_data <- read.csv( paste(directory, solution_data_file, sep=""))
weather_forecast_input <- read.csv(paste(directory, weather_forecast_input_file, sep=""))

# training the k nearest neighbour with all the traning data.
model_knn <- knn.reg(training_data$POWER ~ training_data$WS10, weather_forecast_input, k = 50, algorithm=c("kd_tree", "cover_tree", "brute"))

#model_knn <- IBk(training_data$POWER ~ training_data$WS10, data = training_data, control = Weka_control(K=50, X=TRUE))

summary(model_knn)

# knn_pred <- knn(training_data, weather_forecast_input, )
normalize <- function(x) {
  return ((x - min(x)) / (max(x) - min(x)))
}

# root mean square error function
rmse <- function(error)
{
  sqrt(mean(error^2))
}

# generate the prediction on the test data
results_knn <- 
  
  
prediction_knn <- results_knn$string
prediction_details_knn <- results_knn$details

summary(prediction_knn)

summary(prediction_details_knn)


# plot the neural networks
plot(powerModel)

# calculate error
errorNN <- powerPredictionNN - solution_data$POWER

rmse(errorNN)

write.table(powerPredictionNN, "ForecastTemplate1-NN.csv", sep=",", col.names="Power Prediction", row.names = F)
