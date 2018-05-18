#Installation of packages
packages <- c("rnn")
if (length(setdiff(packages, rownames(installed.packages())))){
  install.packages(setdiff(packages, rownames(installed.packages())))
}

# Loading of packages
library(rnn)

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
train <- 1:15360
test <- 15361:1608

X <- Power[sample(x = train, size = 1000)]
X <- array(X, dim=c(NROW(X), NCOL(X), 1))

Y <- Power[sample(x = train, size = 1000)]
Y <- array(Y, dim=c(NROW(Y), NCOL(Y), 1))

#model <- elman(Y = Y, X = X, size = 8, learnFuncParams=c(0.1), maxit = 100)
model <- trainr(Y = Y, X = X, learningrate = 0.01, hidden_dim = 10, numepochs = 150)

Xpred <- Power[test]
Xpred <- array(Xpred, dim = c(NROW(Xpred), NCOL(Xpred), 1))

# Predicted values
Ypred <- predictr(model, Xpred)

# Calculate error
rmse(solution_data$POWER - Ypred)


# Training of the model (Supported Vector Regression)
model_lr <- train(POWER ~ ., data = training_data[train,], method = "lm")

# Predict new data by the trained model
prediction_lr <- predict(model_lr, newdata = lr_testing)

