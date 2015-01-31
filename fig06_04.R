library(rstan)

source('common.R', encoding = 'utf-8')
y <- ukdrivers
w <- ukseats

standata <- within(list(), {
  y <- as.vector(y)
  w <- as.vector(w)
  n <- length(y)
})

fit <- stan(file = 'fig06_04.stan', data = standata, iter = 2000)
stopifnot(is.converged(fit))

yhat <- get_posterior_mean(fit, par = 'yhat')[, 'mean-all chains']
mu <- get_posterior_mean(fit, par = 'mu')[, 'mean-all chains']
lambda <- get_posterior_mean(fit, par = 'lambda')[, 'mean-all chains']

stopifnot(is.almost.fitted(mu[[1]], 7.4107))
stopifnot(is.almost.fitted(lambda, -0.3785))

#################################################
# Figure 6.4
#################################################

title <- 'Figure 6.4. Stochastic level and intervention variable.'

# 原系列
p <- autoplot(y)

# stan
yhat <- ts(yhat, start = start(y), frequency = frequency(y))
p <- autoplot(yhat, p = p, ts.colour = 'blue')
p + ggtitle(title)

#################################################
# Figure 6.5
#################################################

title <- 'Figure 6.5. Irregular component for stochastic level model with intervention variable.'
autoplot(y - yhat, ts.linetype = 'dashed') + ggtitle(title)
