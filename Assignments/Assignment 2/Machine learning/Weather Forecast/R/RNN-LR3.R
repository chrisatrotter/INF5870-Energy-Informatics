#install.packages("caret", dependencies = TRUE)

library(caret)
library(rnn)

# Read in data set with applliances
setwd(getwd())

directory <- '../data/'
forecast <- 'predicted forecast/'
forecast_model <- c('ForecastTemplate1-kNN.csv', 'ForecastTemplate1-aNN.csv', 'ForecastTemplate1-LR.csv', 'ForecastTemplate1-SVR.csv', 'ForecastTemplate3-LR.csv', 'ForecastTemplate3-RNN.csv')
solution_data_file <- 'Solution.csv'
training_data_file <- 'TrainData.csv'
weather_forecast_input_file <- 'WeatherForecastInput.csv'

# Read in data set with applliances 
training_data <- read.csv( paste(directory, training_data_file, sep=""))
solution_data <- read.csv( paste(directory, solution_data_file, sep=""))
weather_forecast_input <- read.csv(paste(directory, weather_forecast_input_file, sep=""))

training_data <- training_data[c("TIMESTAMP", "POWER")]
Power <- training_data$POWER

TotalDataLength <- length(Power)
TotalTrainLength <- 15000
ActualTrainLength <- 300

X <- Power[(TotalTrainLength - ActualTrainLength) : (TotalTrainLength -1)]
X <- array(X, dim=c(NROW(X), NCOL(X), 1))

Y <- Power[(TotalTrainLength - ActualTrainLength +1) : (TotalTrainLength)]
Y <- array(Y, dim=c(NROW(Y), NCOL(Y), 1))

model <- trainr(Y = Y, X = X, learningrate = 0.01, hidden_dim = 10, numepochs = 150)

Xpred <- Power[(TotalTrainLength - ActualTrainLength + 1): TotalDataLength]
Xpred <- array(Xpred, dim = c(NROW(Xpred), NCOL(Xpred), 1))

Ypred <- predictr(model, Xpred)

rmse(solution_data$POWER - Ypred[661:1380,])

lr_training <- training_data[14701:15000,]
lr_testing <- training_data[15001:15336,]
# linear regression with power
set.seed(333)
# Training of the model (Supported Vector Regression)
model_lr <- train(POWER ~ POWER, data = lr_training, method = "lm")

# Predict new data by the trained model
prediction_lr <- predict(model_lr, newdata = lr_testing)

# root mean square error function
rmse <- function(error)
{
  sqrt(mean(error^2))
}

# calculate error
rmse(solution_data$POWER - prediction_lr)

write.table(data.frame(weather_forecast_input$TIMESTAMP, prediction_lr),
            paste(directory, forecast, forecast_model[3], sep=""),
            sep=",",
            col.names= c("TIMESTAMP", "FORECAST"),
            row.names = F)
