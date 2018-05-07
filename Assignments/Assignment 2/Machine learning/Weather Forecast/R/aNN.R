#install.packages("caret", dependencies = TRUE)

library(caret)

# Read in data set with applliances
setwd(getwd())

directory <- './data/'
forecast <- 'predicted forecast/'
forecast_model <- c('ForecastTemplate1-kNN.csv', 'ForecastTemplate1-aNN.csv', 'ForecastTemplate1-LR.csv', 'ForecastTemplate1-SVR.csv')
solution_data_file <- 'Solution.csv'
training_data_file <- 'TrainData.csv'
weather_forecast_input_file <- 'WeatherForecastInput.csv'

# Read in data set with applliances
training_data <- read.csv( paste(directory, training_data_file, sep=""))
solution_data <- read.csv( paste(directory, solution_data_file, sep=""))
weather_forecast_input <- read.csv(paste(directory, weather_forecast_input_file, sep=""))

set.seed(333)
# Training of the model (K-nearest neighbors)
model_ann <- train(POWER ~ WS10, data = training_data, method = "nnet",
                   maxit = 1000,
                   tuneGrid = expand.grid(.decay = c(0.5, 0.1), .size = c(5, 6, 7)),
                   trace = FALSE,
                   lineout = 1)

#model_ann
# Predict new data by the trained model
prediction_ann <- predict(model_ann, newdata = weather_forecast_input)

# root mean square error function
rmse <- function(error)
{
  sqrt(mean(error^2))
}

# calculate error
rmse(solution_data$POWER - prediction_ann)


write.table(data.frame(weather_forecast_input$TIMESTAMP, prediction_ann),
            paste(directory, forecast, forecast_model[2], sep=""),
            sep=",",
            col.names= c("TIMESTAMP", "FORECAST"),
            row.names = F)
