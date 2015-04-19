library(rstan)

source('common.R', encoding = 'utf-8')
y <- ukdrivers

standata <- within(list(), {
  y <- as.vector(y)
  n <- length(y)
})

fit <- stan(file = 'fig03_04.stan', data = standata,
            warmup = 6000, iter = 8000)
stopifnot(is.converged(fit))

mu <- get_posterior_mean(fit, par = 'mu')[, 'mean-all chains']
v <- get_posterior_mean(fit, par = 'v')[, 'mean-all chains']
sigma_irreg <- get_posterior_mean(fit, par = 'sigma_irreg')[, 'mean-all chains']
sigma_level <- get_posterior_mean(fit, par = 'sigma_level')[, 'mean-all chains']
# テキスト誤植
stopifnot(is.almost.fitted(mu[[1]], 7.4157))
stopifnot(is.almost.fitted(v, 0.00028897))
stopifnot(is.almost.fitted(sigma_irreg^2, 0.00211869))
stopifnot(is.almost.fitted(sigma_level^2, 0.0121271))

#################################################
# Figure 3.4
#################################################

title <- 'Figure 3.4. Trend of stochastic level and deterministic slope model.'
title <- '図 3.4 確率的レベルと確定的傾きモデルのトレンド'

# 原系列
p <- autoplot(y)

# stan
yhat <- ts(mu, start = start(y), frequency = frequency(y))
p <- autoplot(yhat, p = p, ts.colour = 'blue')
p + ggtitle(title)
