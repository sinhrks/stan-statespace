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

fit <- stan(file = 'fig07_01.stan', data = standata, iter = 2000)
stopifnot(is.converged(fit))

yhat <- get_posterior_mean(fit, par = 'yhat')[, 'mean-all chains']
mu <- get_posterior_mean(fit, par = 'mu')[, 'mean-all chains']
beta <- get_posterior_mean(fit, par = 'beta')[, 'mean-all chains']
lambda <- get_posterior_mean(fit, par = 'lambda')[, 'mean-all chains']
sigma_irreg <- get_posterior_mean(fit, par = 'sigma_irreg')[, 'mean-all chains']

stopifnot(is.almost.fitted(mu, 6.4016))
stopifnot(is.almost.fitted(beta, -0.45213))
stopifnot(is.almost.fitted(lambda, -0.19714))
stopifnot(is.almost.fitted(sigma_irreg^2, 0.00740223))

#################################################
# Figure 7.1
#################################################

title <- 'Figure 7.1. Deterministic level plus variables log petrol price and seat belt law.'

# 原系列
p <- autoplot(y)

# stan
yhat <- ts(yhat, start = start(y), frequency = frequency(y))
p <- autoplot(yhat, p = p, ts.colour = 'blue')
p + ggtitle(title)

#################################################
# Figure --
#################################################

title <- 'Irregular component'
autoplot(y - yhat, ts.linetype = 'dashed') + ggtitle(title)
