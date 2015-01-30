library(rstan)

source('common.R', encoding = 'utf-8')
y <- norwegian_fatalities

standata <-
  within(list(), {
    y <- as.vector(y)
    n <- length(y)
  })

# can use the same model as fig02_03
fit <- stan(file = 'fig02_03.stan', data = standata, iter = 4000)
stopifnot(is.converged(fit))

mu <- get_posterior_mean(fit, par = 'mu')[, 'mean-all chains']

#################################################
# Figure 2.5
#################################################

title <- 'Figure 2.5. Stochastic level for Norwegian fatalities.'

# 原系列
p <- autoplot(y)

# stan
yhat <- ts(mu, start = start(y), frequency = frequency(y))
p <- autoplot(yhat, p = p, ts.colour = 'blue')
p + ggtitle(title)

#################################################
# Figure 2.6
#################################################

title <- 'Figure 2.6. Irregular component for Norwegian fatalities.'
autoplot(y - yhat, ts.linetype = 'dashed') + ggtitle(title)

