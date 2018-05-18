#Installation of packages
packages <- c("rnn", "caret")
if (length(setdiff(packages, rownames(installed.packages())))){
  install.packages(setdiff(packages, rownames(installed.packages())))
}

# Loading of packages
library(rnn)
library(caret)

# Read in data set with applliances
setwd(getwd())

directory <- './data/'
forecast <- 'predicted forecast/'
forecast_model <- c('ForecastTemplate1-kNN.csv', 'ForecastTemplate1-aNN.csv', 'ForecastTemplate1-LR.csv', 'ForecastTemplate1-SVR.csv', 'ForecastTemplate2.csv', 'ForecastTemplate3-LR.csv', 'ForecastTemplate3-RNN.csv')
solution_data_file <- 'Solution.csv'
training_data_file <- 'TrainData.csv'
weather_forecast_input_file <- 'WeatherForecastInput.csv'

# Read in data set with applliances 
training_data <- read.csv( paste(directory, training_data_file, sep=""))
solution_data <- read.csv( paste(directory, solution_data_file, sep=""))
weather_forecast_input <- read.csv(paste(directory, weather_forecast_input_file, sep=""))

# Root mean square error function
rmse <- function(error){
  sqrt(mean(error^2))
}

training_data <- training_data[c("TIMESTAMP", "POWER")]
Power <- training_data$POWER

# Set seed for reproducibility purposes
set.seed(333)

# Training-testing sets
train_lr_data <- training_data[1:15360,]
train_rnn_data <- training_data[14360:15360,]
test <- training_data[15361:16080,]

X <- train_rnn_data$POWER
X <- array(X, dim=c(NROW(X), NCOL(X), 1))

Y <- train_rnn_data$POWER
Y <- array(Y, dim=c(NROW(Y), NCOL(Y), 1))

#Training of the model (Recurrent Neural Networks)
model_rnn <- trainr(Y = Y, X = X, learningrate = 0.01, hidden_dim = 10, numepochs = 150)

test_data <- array(test$POWER, dim = c(NROW(test$POWER), NCOL(test$POWER), 1))

# Predict new data by the trained model
prediction_rnn <- predictr(model_rnn, test_data)


train_lr_data <- data.frame(train_lr_data, train_lr_data$POWER)
colnames(train_lr_data) <- c("TIMESTAMP", "POWER_X", "POWER")

# Training of the model (Linear Regression)
model_lr <- train(POWER ~ POWER_X, data = train_lr_data, method = "lm")

test <- data.frame(test, test$POWER)
colnames(test) <- c("TIMESTAMP", "POWER_X", "POWER")

# Predict new data by the trained model
prediction_lr <- predict(model_lr, newdata = test)

# Calculate LR error
rmse(solution_data$POWER - prediction_lr)

# Calculate RNN error
rmse(solution_data$POWER - prediction_rnn)

# Write results to file
write.table(data.frame(weather_forecast_input$TIMESTAMP, prediction_lr),
            paste(directory, forecast, forecast_model[6], sep=""),
            sep=",",
            col.names= c("TIMESTAMP", "FORECAST"),
            row.names = F)

# Write results to file
write.table(data.frame(weather_forecast_input$TIMESTAMP, prediction_rnn),
            paste(directory, forecast, forecast_model[7], sep=""),
            sep=",",
            col.names= c("TIMESTAMP", "FORECAST"),
            row.names = F)

# Plot predictions
plot_prediction <- function(){
  prediction_plot <- data.frame(predictionslr = prediction_lr,
                                Ypred = prediction_rnn,
                                powers = solution_data$POWER,
                                month = as.POSIXct(solution_data$TIMESTAMP, format = "%Y%m%d %H:%M", origin = "1970-01-01"))
  
  ggplot(prediction_plot, aes(x = month)) +
    geom_line(aes(y = powers), na.rm = TRUE, color = "grey27", size = 1, alpha=1) +
    geom_line(aes(y = predictionslr), na.rm = TRUE, color = "blue", size = 1, alpha=1) +
    geom_line(aes(y = Ypred), na.rm = TRUE, color = "red", size = 1, alpha=1) +
    scale_x_datetime(date_breaks = "4 day", date_labels = "%b %d") +
    xlab("November 2013") +
    ylab("Power")
}

#plot_prediction()


