# Read in data set with applliances
setwd(getwd())
directory <- 'data/'
solution_data_file <- 'Solution.csv'
training_data_file <- 'TrainData.csv'
weather_forecast_input_file <- 'WeatherForecastInput.csv'

# Read in data set with applliances
training_data <- read.csv( paste(directory, training_data_file, sep="") )
solution_data <- read.csv( paste(directory, solution_data_file, sep="") )
weather_forecast_input <- read.csv(paste(directory, weather_forecast_input_file, sep=""))

knn_pred <- knn(training_data, weather_forecast_input, )