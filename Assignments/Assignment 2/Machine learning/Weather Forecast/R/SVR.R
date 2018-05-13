# Installation of packages
packages <- c("caret")
if (length(setdiff(packages, rownames(installed.packages())))){
  install.packages(setdiff(packages, rownames(installed.packages())))
}

#Loading of packages
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
# Training of the model (Supported Vector Regression)
model_svr <- train(POWER ~ WS10, data = training_data, method = "svmRadial",
                   trControl = trainControl(method = "cv", number = 10, savePredictions = TRUE))

# Predict new data by the trained model
prediction_svr <- predict(model_svr, newdata = weather_forecast_input)

# Root mean square error function
rmse <- function(error)
{
  sqrt(mean(error^2))
}

# Calculate error
rmse(solution_data$POWER - prediction_svr)

# Write results to file
write.table(data.frame(weather_forecast_input$TIMESTAMP, prediction_svr),
            paste(directory, forecast, forecast_model[4], sep=""),
            sep=",",
            col.names= c("TIMESTAMP", "FORECAST"),
            row.names = F)

# Plot functions
# The plot of the support vector regression function ( Yi - (aXi + b) <= e and (aXi + b) - Yi <= e ).
plot_function <- function(){
  ggplot() +
    geom_point(data = training_data, aes(x = WS10, y = POWER), color = "gray27") +
    geom_point(aes(x = weather_forecast_input$WS10, y = prediction_svr), color = 'red', size = 2)
}

# The plot of the prediction and actual power usage for November 2013.
plot_prediction <- function(){
  prediction_plot <- data.frame(predictions = prediction_svr,
                                powers = solution_data$POWER,
                                month = as.POSIXct(solution_data$TIMESTAMP, format = "%Y%m%d %H:%M", origin = "1970-01-01"))
  
  ggplot(prediction_plot, aes(x = month)) +
    geom_line(aes(y = powers), na.rm = TRUE, color = "gray27", size = 1) +
    geom_line(aes(y = predictions), na.rm = TRUE, color = "red", size = 1) +
    scale_x_datetime(date_breaks = "4 day", date_labels = "%b %d") +
    xlab("November 2013") +
    ylab("Power")
}

#plot_function()
#plot_prediction()