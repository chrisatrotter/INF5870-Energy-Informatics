
library(caret)

# Read in data set with applliances
setwd(getwd())

directory <- '../data/'
forecast <- 'predicted forecast/'
forecast_model <- c('ForecastTemplate1-kNN.csv', 'ForecastTemplate1-aNN.csv', 'ForecastTemplate1-LR.csv', 'ForecastTemplate1-SVR.csv')
solution_data_file <- 'Solution.csv'
training_data_file <- 'TrainData.csv'
weather_forecast_input_file <- 'WeatherForecastInput.csv'

# Read in data set with applliances
training_data <- read.csv( paste(directory, training_data_file, sep=""))
solution_data <- read.csv( paste(directory, solution_data_file, sep=""))
weather_forecast_input <- read.csv(paste(directory, weather_forecast_input_file, sep=""))

#WDIR <- (270-atan2(training_data$V10,training_data$U10)*180/pi)%% 360 



control <- trainControl(method="repeatedcv", 
                        number=10, 
                        repeats=6)

set.seed(333)
# Training of the model (Supported Vector Regression)
model_lr <- train(POWER ~ WS10 + WDIR, data = training_data, method = "lm", trControl = control, tuneLength = 10)

# Predict new data by the trained model
prediction_lr <- predict(model_lr, newdata = weather_forecast_input)

# root mean square error function
rmse <- function(error)
{
  sqrt(mean(error^2))
}

# calculate error
rmse(solution_data$POWER - prediction_lr)