library(rstan)

source('common.R', encoding = 'utf-8')
y <- ukdrivers

standata <- within(list(), {
  y <- as.vector(y)
  n <- length(y)
})

fit <- stan(file = 'fig03_04.stan', data = standata)
stopifnot(is.converged(fit))

mu <- get_posterior_mean(fit, par = 'mu')[, 'mean-all chains']
all.equal(mu[[1]], 7.4150, tolerance = 0.01)
mu <- get_posterior_mean(fit, par = 'sigma_level')[, 'mean-all chains']
almost_fitted(fit, 'mu', 7.4150)


#################################################
# Figure 3.4
#################################################

title <- 'Figure 3.4. Trend of stochastic level and deterministic slope model.'

# 原系列
p <- autoplot(y)

# stan
yhat <- ts(mu, start = start(y), frequency = frequency(y))
p <- autoplot(yhat, p = p, ts.colour = 'blue')
p + ggtitle(title)



