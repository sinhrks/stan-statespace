library(rstan)

source('common.R', encoding = 'utf-8')
y <- ukdrivers

standata <-
  within(list(), {
    y <- as.vector(y)
    n <- length(y)
  })

fit <- stan(file = 'fig03_01.stan', data = standata, iter = 6000)
stopifnot(is.converged(fit))

mu <- get_posterior_mean(fit, par = 'mu')[, 'mean-all chains']
v <- get_posterior_mean(fit, par = 'v')[, 'mean-all chains']

#################################################
# Figure 3.1
#################################################

title <- 'Figure 3.1. Trend of stochastic linear trend model.'

# 原系列
p <- autoplot(y)

# stan
yhat <- ts(mu, start = start(y), frequency = frequency(y))
p <- autoplot(yhat, p = p, ts.colour = 'blue')
p + ggtitle(title)

#################################################
# Figure 3.2
#################################################

title <- 'Figure 3.2. Slope of stochastic linear trend model.'

# stan
slope <- ts(v, start = start(y), frequency = frequency(y))
autoplot(slope) + ggtitle(title)

#################################################
# Figure 3.3
#################################################

title <- 'Figure 3.3. Irregular component of stochastic linear trend model.'
autoplot(y - yhat, ts.linetype = 'dashed') + ggtitle(title)
