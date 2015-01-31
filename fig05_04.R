library(rstan)

source('common.R', encoding = 'utf-8')
y <- ukdrivers
x <- ukpetrol

standata <- within(list(), {
  y <- as.vector(y)
  x <- as.vector(x)
  n <- length(y)
})

fit <- stan(file = 'fig05_04.stan', data = standata, iter = 8000)
stopifnot(is.converged(fit))

yhat <- get_posterior_mean(fit, par = 'yhat')[, 'mean-all chains']
sigma_irreg <- get_posterior_mean(fit, par = 'sigma_irreg')[, 'mean-all chains']
sigma_seas <- get_posterior_mean(fit, par = 'sigma_seas')[, 'mean-all chains']
stopifnot(is.almost.fitted(mu[[1]], 7.4157))
stopifnot(is.almost.fitted(v, 0.00028897))
stopifnot(is.almost.fitted(sigma_irreg^2, 0.00211869))
stopifnot(is.almost.fitted(sigma_level^2, 0.0121271))

#################################################
# Figure 5.4
#################################################

title <- 'Figure 5.4. Stochastic level and deterministic explanatory variable ‘log petrol price’.'

# 原系列
p <- autoplot(y)

# stan
yhat <- ts(yhat, start = start(y), frequency = frequency(y))
p <- autoplot(yhat, p = p, ts.colour = 'blue')
p + ggtitle(title)

#################################################
# Figure 5.5
#################################################

title <- 'Figure 5.5. Irregular for stochastic level model with deterministic explanatory variable ‘log petrol price’.'
autoplot(y - yhat, ts.linetype = 'dashed') + ggtitle(title)
