library(rstan)
library(pforeach)

source('common.R', encoding = 'utf-8')
y <- ukinflation

standata <- within(list(), {
  y <- as.vector(y)
  n <- length(y)
})

# can use the same model as fig04_06
stan_fit <- stan(file = 'fig04_06.stan', chains = 0)
sflist <- pforeach(i=1:3)({
  stan(fit = stan_fit, data = standata,
       iter = 2000, chains = 1, seed = i)
})
fit <- sflist2stanfit(sflist)
stopifnot(is.converged(fit))

mu <- get_posterior_mean(fit, par = 'mu')[, 'mean-all chains']
yhat <- get_posterior_mean(fit, par = 'yhat')[, 'mean-all chains']
seasonal <- get_posterior_mean(fit, par = 'seasonal')[, 'mean-all chains']

sigma_irreg <- get_posterior_mean(fit, par = 'sigma_irreg')[, 'mean-all chains']
sigma_level <- get_posterior_mean(fit, par = 'sigma_level')[, 'mean-all chains']
sigma_seas <- get_posterior_mean(fit, par = 'sigma_seas')[, 'mean-all chains']
stopifnot(is.almost.fitted(mu[[208]], 0.0020426))
stopifnot(is.almost.fitted(sigma_irreg^2, 3.3717e-5))
stopifnot(is.almost.fitted(sigma_level^2, 2.1197e-5))
stopifnot(is.almost.fitted(sigma_seas^2, 0.0109e-5))

#################################################
# Figure 4.10.1
#################################################

title <- 'Figure 4.10.1. Stochastic level.'

# 原系列
p <- autoplot(y)

# stan
mu <- ts(mu, start = start(y), frequency = frequency(y))
p <- autoplot(mu, p = p, ts.colour = 'blue')
p + ggtitle(title)

#################################################
# Figure 4.10.2
#################################################

title <- 'Figure 4.10.2. Stochastic seasonal.'
seasonal <- ts(seasonal, start = start(y), frequency = frequency(y))
autoplot(seasonal, ts.colour = 'blue') + ggtitle(title)

#################################################
# Figure 4.10.3
#################################################

title <- 'Figure 4.10.3. Irregular component for stochastic level and seasonal model.'
autoplot(y - yhat, ts.linetype = 'dashed') + ggtitle(title)

