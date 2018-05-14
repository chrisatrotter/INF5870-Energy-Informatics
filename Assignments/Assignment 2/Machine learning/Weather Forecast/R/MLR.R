# Installation of packages
packages <- c("caret")
if (length(setdiff(packages, rownames(installed.packages())))){
  install.packages(setdiff(packages, rownames(installed.packages())))
}

# Loading of packages
library(caret)

# Read in data set with applliances
setwd(getwd())

directory <- './data/'
forecast <- 'predicted forecast/'
forecast_model <- c('ForecastTemplate1-kNN.csv', 'ForecastTemplate1-aNN.csv', 'ForecastTemplate1-LR.csv', 'ForecastTemplate1-SVR.csv', 'ForecastTemplate2.csv')
solution_data_file <- 'Solution.csv'
training_data_file <- 'TrainData.csv'
weather_forecast_input_file <- 'WeatherForecastInput.csv'

# Read in data set with applliances
training_data <- read.csv( paste(directory, training_data_file, sep=""))
solution_data <- read.csv( paste(directory, solution_data_file, sep=""))
weather_forecast_input <- read.csv(paste(directory, weather_forecast_input_file, sep=""))

# calculate the wind direction
WDIR <- (270-atan2(training_data$V10,training_data$U10)*180/pi)%% 360

# append column wdir (wind direction)
training_data <- cbind(training_data, WDIR)

set.seed(333)
# Training of the model (multi linear Regression)
model_mlr <- train(POWER ~ WS10 + WDIR, data = training_data, method = "lm")

model_mlr$coefnames
model_mlr$finalModel

WDIR <- (270-atan2(weather_forecast_input$V10,weather_forecast_input$U10)*180/pi)%% 360 

# append column wdir (wind direction)
weather_forecast_input <- cbind(weather_forecast_input, WDIR)

# Predict new data by the trained model
prediction_mlr <- predict(model_lr, newdata = weather_forecast_input )

model_lr <- train(POWER ~ WS10, data = training_data, method = "lm")


# Predict new data by the trained model
prediction_lr <- predict(model_lr, newdata = weather_forecast_input)

# root mean square error function
rmse <- function(error){
  sqrt(mean(error^2))
}

# calculate error
rmse(solution_data$POWER - prediction_mlr)

# Write results to file
write.table(data.frame(weather_forecast_input$TIMESTAMP, prediction_lr),
            paste(directory, forecast, forecast_model[5], sep=""),
            sep=",",
            col.names= c("TIMESTAMP", "FORECAST"),
            row.names = F)

# Prediction plot
prediction_plot <- data.frame(predictionslr = prediction_lr,
                              predictionsmlr = prediction_mlr,
                              powers = solution_data$POWER,
                              month = as.POSIXct(solution_data$TIMESTAMP, format = "%Y%m%d %H:%M", origin = "1970-01-01"))

ggplot(prediction_plot, aes(x = month)) +
  geom_line(aes(y = powers), na.rm = TRUE, color = "red", size = 1, alpha=1) +
  geom_line(aes(y = predictionslr), na.rm = TRUE, color = "green4", size = 1, alpha=1) +
  geom_line(aes(y = predictionsmlr), na.rm = TRUE, color = "Black", size = 1, alpha=1) +
  scale_x_datetime(date_breaks = "4 day", date_labels = "%b %d") +
  xlab("November 2013") +
  ylab("Power")

#plot_prediction()