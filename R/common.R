#' Data reader and common utility functions

## @knitr install_packages

# install.packages('ggfortify')

## @knitr load_packages

library(rstan)
library(ggplot2)
ggplot2::theme_set(theme_bw(base_family="HiraKakuProN-W3"))
library(ggfortify)

# do in parallel
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

## @knitr ukdrivers

ukdrivers <- read.table('../data/UKdriversKSI.txt', skip = 1)
ukdrivers <- ts(ukdrivers[[1]], start = c(1969, 1), frequency = 12)
ukdrivers <- log(ukdrivers)

## @knitr ukdriversm

ukdriversm <- read.table('../data/UKfrontrearseatKSI.txt', skip = 1)
colnames(ukdriversm) <- c('UK drivers KSI', 'front seat KSI', 'rear Seat KSI',
                          'Kilometers driven', 'petrol price')
ukdriversm <- ts(ukdriversm, start = c(1969, 1), frequency = 12)

## @knitr ukpetrol

ukpetrol <- read.table('../data/logUKpetrolprice.txt', skip = 1)
ukpetrol <- ts(ukpetrol, start = start(ukdrivers), frequency = frequency(ukdrivers))

## @knitr ukseats

ukseats <- c(rep(0, (1982 - 1968) * 12 + 1), rep(1, (1984 - 1982) * 12 - 1))
ukseats <- ts(ukseats, start = start(ukdrivers), frequency = frequency(ukdrivers))

## @knitr ukinflation

ukinflation <- read.table('../data/UKinflation.txt', skip = 1)
ukinflation <- ts(ukinflation[[1]], start = c(1950, 1), frequency = 4)

## @knitr ukpulse

ukpulse <- rep(0, length.out = length(ukinflation))
ukpulse[4*(1975-1950)+2] <- 1
ukpulse[4*(1979-1950)+3] <- 1
ukpulse <- ts(ukpulse, start = start(ukinflation), frequency = frequency(ukinflation))

## @knitr fatalities

fatalities <- read.table('../data/NorwayFinland.txt', skip = 1)
colnames(fatalities) <- c('year', 'Norwegian_fatalities',
                          'Finnish_fatalities')
norwegian_fatalities <- fatalities[['Norwegian_fatalities']]
norwegian_fatalities <- log(ts(norwegian_fatalities, start = 1970, frequency = 1))
finnish_fatalities <- fatalities[['Finnish_fatalities']]
finnish_fatalities <- log(ts(finnish_fatalities, start = 1970, frequency = 1))

## @knitr func_defs

# モデルが収束しているか確認
is.converged <- function(stanfit) {
  summarized <- summary(stanfit)  
  all(summarized$summary[, 'Rhat'] < 1.1)
}

# 値がだいたい近いか確認
is.almost.fitted <- function(result, expected, tolerance = 0.001) {
  if (abs(result - expected) > tolerance) {
    print(paste('Result is ', result))
    return(FALSE)
  } else {
    return(TRUE)
  }
}
