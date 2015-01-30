library(rstan)

source('common.R', encoding = 'utf-8')
y <- ukdrivers

standata <-
  within(list(), {
    y <- as.vector(y)
    n <- length(y)
  })

fit <- stan(file = 'fig02_03.stan', data = standata)
stopifnot(is.converged(fit))

mu <- get_posterior_mean(fit, par = 'mu')[, 'mean-all chains']

#################################################
# Figure 2.3
#################################################

title <- 'Figure 2.3. Stochastic level.'

# 原系列
p <- autoplot(y)

# stan
yhat <- ts(mu, start = start(y), frequency = frequency(y))
p <- autoplot(yhat, p = p, ts.colour = 'blue')
p + ggtitle(title)

#################################################
# Figure 2.4
#################################################

title <- 'Figure 2.4. Irregular component for local level model.'
autoplot(y - yhat, ts.linetype = 'dashed') + ggtitle(title)
