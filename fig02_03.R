library(rstan)

source('common.R', encoding = 'utf-8')
y <- ukdrivers

standata <- within(list(), {
  y <- as.vector(y)
  n <- length(y)
})

fit <- stan(file = 'fig02_03.stan', data = standata, iter = 6000)
stopifnot(is.converged(fit))

mu <- get_posterior_mean(fit, par = 'mu')[, 'mean-all chains']
sigma_irreg <- get_posterior_mean(fit, par = 'sigma_irreg')[, 'mean-all chains']
sigma_level <- get_posterior_mean(fit, par = 'sigma_level')[, 'mean-all chains']
stopifnot(is.almost.fitted(mu[[1]], 7.4150))
stopifnot(is.almost.fitted(sigma_irreg^2, 0.00222157))
stopifnot(is.almost.fitted(sigma_level^2, 0.011866))

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
