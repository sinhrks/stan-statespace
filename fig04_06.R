library(rstan)

source('common.R', encoding = 'utf-8')
y <- ukdrivers

standata <-
  within(list(), {
    y <- as.vector(y)
    n <- length(y)
  })

stan_fit <- stan(file = 'fig04_06.stan', chains = 0)
sflist <- pforeach(i=1:3)({
  stan(fit = stan_fit, data = standata,
       iter = 6000, chains = 1, seed = i)
})
fit <- sflist2stanfit(sflist)
stopifnot(is.converged(fit))

mu <- get_posterior_mean(fit, par = 'mu')[, 'mean-all chains']
yhat <- get_posterior_mean(fit, par = 'yhat')[, 'mean-all chains']
seasonal <- get_posterior_mean(fit, par = 'seasonal')[, 'mean-all chains']

#################################################
# Figure 4.6
#################################################

title <- 'Figure 4.6. Stochastic level.'

# 原系列
p <- autoplot(y)

# stan
mu <- ts(mu, start = start(y), frequency = frequency(y))
p <- autoplot(mu, p = p, ts.colour = 'blue')
p + ggtitle(title)

#################################################
# Figure 4.7
#################################################

title <- 'Figure 4.7. Stochastic seasonal.'
seasonal <- ts(seasonal, start = start(y), frequency = frequency(y))
autoplot(seasonal, ts.colour = 'blue') + ggtitle(title)

#################################################
# Figure 4.8
#################################################

title <- 'Figure 4.8. Stochastic seasonal for the year 1969.'
s1969 <- ts(seasonal[1:12], start = start(y), frequency = frequency(y))
autoplot(s1969, ts.colour = 'blue') + ggtitle(title)

#################################################
# Figure 4.9
#################################################

title <- 'Figure 4.9. Irregular component for stochastic level and seasonal model.'
autoplot(y - yhat, ts.linetype = 'dashed') + ggtitle(title)

