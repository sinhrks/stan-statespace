library(rstan)

source('common.R', encoding = 'utf-8')
y <- ukdrivers
x <- ukpetrol
w <- ukseats

standata <- within(list(), {
  y <- as.vector(y)
  x <- as.vector(x)
  w <- as.vector(w)
  n <- length(y)
})

fit <- stan(file = 'fig07_02.stan', data = standata, iter = 2000)
stopifnot(is.converged(fit))

yhat <- get_posterior_mean(fit, par = 'yhat')[, 'mean-all chains']
mu <- get_posterior_mean(fit, par = 'mu')[, 'mean-all chains']
seasonal <- get_posterior_mean(fit, par = 'seasonal')[, 'mean-all chains']
beta <- get_posterior_mean(fit, par = 'beta')[, 'mean-all chains']
lambda <- get_posterior_mean(fit, par = 'lambda')[, 'mean-all chains']
sigma_irreg <- get_posterior_mean(fit, par = 'sigma_irreg')[, 'mean-all chains']
sigma_level <- get_posterior_mean(fit, par = 'sigma_level')[, 'mean-all chains']
sigma_seas <- get_posterior_mean(fit, par = 'sigma_seas')[, 'mean-all chains']

stopifnot(is.almost.fitted(sigma_irreg^2, 0.00378629))
stopifnot(is.almost.fitted(sigma_level^2, 0.000267632))
stopifnot(is.almost.fitted(sigma_seas^2, 0.0000011622)

#################################################
# Figure 7.2
#################################################

title <- 'Figure 7.2. Stochastic level plus variables log petrol price and seat belt law.'

# 原系列
p <- autoplot(y)

# stan
yhat <- ts(yhat, start = start(y), frequency = frequency(y))
p <- autoplot(yhat, p = p, ts.colour = 'blue')
p + ggtitle(title)

#################################################
# Figure 7.3
#################################################

title <- 'Figure 7.3. Stochastic seasonal.'
seasonal <- ts(seasonal, start = start(y), frequency = frequency(y))
autoplot(seasonal, ts.colour = 'blue') + ggtitle(title)

#################################################
# Figure 7.4
#################################################

title <- 'Figure 7.4. Irregular component for stochastic level and seasonal model.'
autoplot(y - yhat, ts.linetype = 'dashed') + ggtitle(title)
