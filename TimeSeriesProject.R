## USE FORECAST LIBRARY.

library(forecast)

## CREATE DATA FRAME FOR S&P500 STOCK PRICES. 

# Set working directory for locating files.
setwd("/Users/manideepelasagaram/Desktop/Time series project")


# Create data frame.
airpassenger.data <- read.csv("AirPassengers.csv")

# See the first and last 6 records of the file for S&P500 data.
head(airpassenger.data )
tail(airpassenger.data )

#convert to timeseries data
airpassenger.ts <- ts(airpassenger.data$Passengers, 
                 start = c(1949, 1), end = c(1960, 12), freq = 12)

# Use plot() function to create plot For AirPassenger. 
plot(airpassenger.ts, 
     xlab = "Time", ylab = "Passengers (in 00's)", 
     ylim = c(100, 700), xaxt = 'n',
     main = "Forecasting Air Passengers")
# Establish x-axis scale interval for time in months.
axis(1, at = seq(1949, 1960, 1), labels = format(seq(1949, 1960, 1)))

## TEST PREDICTABILITY OF Air passengers.

# Use Arima() function to fit AR(1) model for S&P500 close prices.
# The ARIMA model of order = c(1,0,0) gives an AR(1) model.
airpassenger.ar1<- Arima(airpassenger.ts, order = c(1,0,0))
summary(airpassenger.ar1)

# Apply z-test to test the null hypothesis that beta 
# coefficient of AR(1) is equal to 1.
ar1 <- 0.9646
s.e. <- 0.0214
null_mean <- 1
alpha <- 0.05
z.stat <- (ar1-null_mean)/s.e.
z.stat
p.value <- pnorm(z.stat)
p.value
if (p.value<alpha) {
  "Reject null hypothesis"
} else {
  "Accept null hypothesis"
}

# Create first difference of Airpassenger data using diff() function.
diff.close.price <- diff(airpassenger.ts, lag = 1)
diff.close.price

# Develop data frame with Airpassenger, Airpassenger lag 1, and first
# differenced data.
diff.df <- data.frame(airpassenger.ts, c("", round(airpassenger.ts[1:143],2)), 
                      c("", round(diff.close.price,2)))

names(diff.df) <- c("AirPassenger", "AirPassenger Lag-1", 
                    "First Difference")
diff.df 

# Use Acf() function to identify autocorrealtion for first differenced
# Airpassenger and plot autocorrelation for different lags 
# (up to maximum of 12).
Acf(diff.close.price, lag.max = 12, 
    main = "Autocorrelation for Differenced Close Airpassenger")

###------------------------------------------------------------------------------------------

## CREATE TIME SERIES PARTITION.

# Define the numbers of months in the training and validation sets,
# nTrain and nValid, respectively.
# Total number of period length(ridership.ts) = 159.
# nvalid = 60 months for the last 12 months (January 2014 to December 2018).
# nTrain = 276 months, from January 1991 to December 2013.
nValid <- 24 
nTrain <- length(airpassenger.ts) - nValid
train.ts <- window(airpassenger.ts, start = c(1949, 1), end = c(1949, nTrain))
valid.ts <- window(airpassenger.ts, start = c(1949, nTrain + 1), 
                   end = c(1949, nTrain + nValid))





