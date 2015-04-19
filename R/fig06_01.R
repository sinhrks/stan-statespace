library(rstan)

source('common.R', encoding = 'utf-8')
y <- ukdrivers
w <- ukseats

standata <- within(list(), {
  y <- as.vector(y)
  w <- as.vector(w)
  n <- length(y)
})

fit <- stan(file = 'fig06_01.stan', data = standata, iter = 2000)
stopifnot(is.converged(fit))

yhat <- get_posterior_mean(fit, par = 'yhat')[, 'mean-all chains']
mu <- get_posterior_mean(fit, par = 'mu')[, 'mean-all chains']
lambda <- get_posterior_mean(fit, par = 'lambda')[, 'mean-all chains']
sigma_irreg <- get_posterior_mean(fit, par = 'sigma_irreg')[, 'mean-all chains']

stopifnot(is.almost.fitted(mu, 7.4374))
stopifnot(is.almost.fitted(lambda, -0.26111))
stopifnot(is.almost.fitted(sigma_irreg^2, 0.0222426))

#################################################
# Figure 6.1
#################################################

title <- 'Figure 6.1. Deterministic level and intervention variable.'

# 原系列
p <- autoplot(y)

# stan
yhat <- ts(yhat, start = start(y), frequency = frequency(y))
p <- autoplot(yhat, p = p, ts.colour = 'blue')
p + ggtitle(title)

#################################################
# Figure 6.2
#################################################

# 後で

#################################################
# Figure 6.3
#################################################

title <- 'Figure 6.3. Irregular component for deterministic level model with intervention variable.'
autoplot(y - yhat, ts.linetype = 'dashed') + ggtitle(title)
