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
forecast_model <- c('ForecastTemplate1-kNN.csv', 'ForecastTemplate1-aNN.csv', 'ForecastTemplate1-LR.csv', 'ForecastTemplate1-SVR.csv', 'ForecastTemplate3-LR.csv', 'ForecastTemplate3-RNN.csv')
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
train_data<- 14300:15360
test <- 15361:16080

#X <- Power[sample(x = train_data, size = 1000)]
X <- Power[train_data]
X <- array(X, dim=c(NROW(X), NCOL(X), 1))

#Y <- Power[sample(x = train_data, size = 1000)]
Y <- Power[train_data]
Y <- array(Y, dim=c(NROW(Y), NCOL(Y), 1))

#model <- elman(Y = Y, X = X, size = 8, learnFuncParams=c(0.1), maxit = 100)
model_rnn <- trainr(Y = Y, X = X, learningrate = 0.01, hidden_dim = 10, numepochs = 150)

test_data <- array(Power[test], dim = c(NROW(Power[test]), NCOL(Power[test]), 1))

# Predicted values
prediction_rnn <- predictr(model_rnn, test_data)

# Training of the model (Supported Vector Regression)
model_lr <- train(POWER ~ POWER, data = train_data[1:15360,], method = "lm")

# Predict new data by the trained model
prediction_lr <- predict(model_lr, newdata = POWER[test])

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


