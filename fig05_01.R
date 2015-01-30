library(rstan)

source('common.R', encoding = 'utf-8')
y <- ukdrivers
x <- ukpetrol

standata <-
  within(list(), {
    y <- as.vector(y)
    x <- as.vector(x)
    n <- length(y)
  })

fit <- stan(file = 'fig05_01.stan', data = standata, iter = 2000)
stopifnot(is.converged(fit))

yhat <- get_posterior_mean(fit, par = 'yhat')[, 'mean-all chains']

#################################################
# Figure 5.1
#################################################

title <- 'Figure 5.1. Deterministic level and explanatory variable ‘log petrol price’.'

# 原系列
p <- autoplot(y)

# stan
yhat <- ts(yhat, start = start(y), frequency = frequency(y))
p <- autoplot(yhat, p = p, ts.colour = 'blue')
p + ggtitle(title)

#################################################
# Figure 5.2
#################################################

# Same as Figure 1.1.

#################################################
# Figure 5.3
#################################################

title <- 'Figure 5.3. Irregular component for deterministic level model with explanatory variable ‘log petrol price’.'
autoplot(y - yhat, ts.linetype = 'dashed') + ggtitle(title)
