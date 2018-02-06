library(readr)
library(downloader)

# directory <- 'http://api.bitcoincharts.com/v1/csv/'
# filename <- 'coinbaseUSD.csv.gz'

#directory <- 'C:\\Skole, Programmering\\Data Science\\Bitcoin Data\\Dataset\\'
#filename <- 'coinbaseUSD.csv'
#filename <- 'sample.csv'

grabRemote <- function( directory, filename, bitcoinData ) {
  temp <- tempfile()
  download.file( paste( directory, filename, sep = "" ), destfile = temp )
  bitcoinData <- read.csv( gzfile( temp ), nrows = 1000 )
  unlink( temp )
  return( bitcoinData )
}

print("stupid potato")
