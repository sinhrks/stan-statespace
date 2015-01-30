library(rstan)

source('common.R', encoding = 'utf-8')
y <- finnish_fatalities 

standata <-
  within(list(), {
    y <- as.vector(y)
    n <- length(y)
  })

# can use the same model as fig03_01
fit <- stan(file = 'fig03_01.stan', data = standata)
stopifnot(is.converged(fit))

mu <- get_posterior_mean(fit, par = 'mu')[, 'mean-all chains']
v <- get_posterior_mean(fit, par = 'v')[, 'mean-all chains']


#################################################
# Figure 3.5.1
#################################################

title <- 'Figure 3.5.1. Trend of deterministic level and stochastic slope model for Finnish fatalities'

# 原系列
p <- autoplot(y)

# stan
yhat <- ts(mu, start = start(y), frequency = frequency(y))
p <- autoplot(yhat, p = p, ts.colour = 'blue')
p + ggtitle(title)

#################################################
# Figure 3.5.2
#################################################

title <- 'Figure 3.5.2 Stochastic slope component for Finnish fatalities.'

# stan
slope <- ts(v, start = start(y), frequency = frequency(y))
autoplot(slope) + ggtitle(title)

#################################################
# Figure 3.6
#################################################

title <- 'Figure 3.6. Irregular component for Finnish fatalities.'
autoplot(y - yhat, ts.linetype = 'dashed') + ggtitle(title)