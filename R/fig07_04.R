library(rstan)

source('common.R', encoding = 'utf-8')
y <- ukinflation
w <- ukpulse

standata <- within(list(), {
  y <- as.vector(y)
  w <- as.vector(w)
  n <- length(y)
})

fit <- stan(file = 'fig07_04.stan', data = standata, iter = 2000)
stopifnot(is.converged(fit))

yhat <- get_posterior_mean(fit, par = 'yhat')[, 'mean-all chains']
mu <- get_posterior_mean(fit, par = 'mu')[, 'mean-all chains']
seasonal <- get_posterior_mean(fit, par = 'seasonal')[, 'mean-all chains']
lambda <- get_posterior_mean(fit, par = 'lambda')[, 'mean-all chains']
sigma_irreg <- get_posterior_mean(fit, par = 'sigma_irreg')[, 'mean-all chains']
sigma_level <- get_posterior_mean(fit, par = 'sigma_level')[, 'mean-all chains']
sigma_seas <- get_posterior_mean(fit, par = 'sigma_seas')[, 'mean-all chains']

stopifnot(is.almost.fitted(sigma_irreg^2, 2.1990e-5))
stopifnot(is.almost.fitted(sigma_level^2, 1.8595e-5))
stopifnot(is.almost.fitted(sigma_seas^2, 0.0110e-5))

#################################################
# Figure 7.7.1
#################################################

title <- 'Figure 7.7.1. Local level (including pulse interventions) for UK inflation time series data.'

# 原系列
p <- autoplot(y)

# stan
yhat <- ts(yhat, start = start(y), frequency = frequency(y))
p <- autoplot(yhat, p = p, ts.colour = 'blue')
p + ggtitle(title)

#################################################
# Figure 7.7.2
#################################################

title <- 'Figure 7.7.2. Local seasonal for UK inflation time series data.'

seasonal <- ts(seasonal, start = start(y), frequency = frequency(y))
autoplot(seasonal, ts.colour = 'blue') + ggtitle(title)

#################################################
# Figure 7.7.3
#################################################

title <- 'Figure 7.7.3. Irregular for UK inflation time series data.'
autoplot(y - yhat, ts.linetype = 'dashed') + ggtitle(title)
