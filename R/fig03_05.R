library(rstan)

source('common.R', encoding = 'utf-8')
y <- finnish_fatalities 

standata <-
  within(list(), {
    y <- as.vector(y)
    n <- length(y)
  })

fit <- stan(file = 'fig03_05.stan', data = standata)
stopifnot(is.converged(fit))

yhat <- get_posterior_mean(fit, par = 'yhat')[, 'mean-all chains']
mu <- get_posterior_mean(fit, par = 'mu')[, 'mean-all chains']
v <- get_posterior_mean(fit, par = 'v')[, 'mean-all chains']
sigma_irreg <- get_posterior_mean(fit, par = 'sigma_irreg')[, 'mean-all chains']
sigma_drift <- get_posterior_mean(fit, par = 'sigma_drift')[, 'mean-all chains']
# テキスト誤植
stopifnot(is.almost.fitted(mu, 7.0133))
stopifnot(is.almost.fitted(v[[1]], 0.0068482))
stopifnot(is.almost.fitted(sigma_irreg^2, 0.00320083))
stopifnot(is.almost.fitted(sigma_drift^2, 0.00153314))

#################################################
# Figure 3.5.1
#################################################

title <- 'Figure 3.5.1. Trend of deterministic level and stochastic slope model for Finnish fatalities'
title <- '図 3.5.1 フィンランド事故データの確定的レベルと確率的傾きモデルのトレンド'

# 原系列
p <- autoplot(y)

# stan
yhat <- ts(yhat, start = start(y), frequency = frequency(y))
p <- autoplot(yhat, p = p, ts.colour = 'blue')
p + ggtitle(title)

#################################################
# Figure 3.5.2
#################################################

title <- 'Figure 3.5.2 Stochastic slope component for Finnish fatalities.'
title <- '図 3.5.2 フィンランド事故データの確定的レベルと確率的傾きモデルの確率的傾き要素'

slope <- ts(v, start = start(y), frequency = frequency(y))
autoplot(slope) + ggtitle(title)

#################################################
# Figure 3.6
#################################################

title <- 'Figure 3.6. Irregular component for Finnish fatalities.'
title <- '図 3.6 フィンランド事故データに対する不規則要素'

autoplot(y - yhat, ts.linetype = 'dashed') + ggtitle(title)
