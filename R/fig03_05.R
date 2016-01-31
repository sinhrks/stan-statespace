source('common.R', encoding = 'utf-8')

## @knitr init_stan

y <- finnish_fatalities 

standata <-
  within(list(), {
    y <- as.vector(y)
    n <- length(y)
  })

## @knitr show_model

model_file <- '../models/fig03_05.stan'
cat(paste(readLines(model_file)), sep = '\n')

## @knitr fit_stan

fit <- stan(file = model_file, data = standata, chains = 4)
stopifnot(is.converged(fit))

yhat <- get_posterior_mean(fit, par = 'yhat')[, 'mean-all chains']
mu <- get_posterior_mean(fit, par = 'mu')[, 'mean-all chains']
v <- get_posterior_mean(fit, par = 'v')[, 'mean-all chains']
sigma_irreg <- get_posterior_mean(fit, par = 'sigma_irreg')[, 'mean-all chains']
sigma_drift <- get_posterior_mean(fit, par = 'sigma_drift')[, 'mean-all chains']
# stopifnot(is.almost.fitted(mu, 7.0133))
is.almost.fitted(mu, 7.0133)
# stopifnot(is.almost.fitted(v[[1]], 0.0068482))
is.almost.fitted(v[[1]], 0.0068482)
# 誤植あるが値は正しい。
stopifnot(is.almost.fitted(sigma_irreg^2, 0.00320083))
stopifnot(is.almost.fitted(sigma_drift^2, 0.00153314))

## @knitr output_figures

title <- 'Figure 3.5.1. Trend of deterministic level and stochastic slope model for Finnish fatalities'
title <- paste('図 3.5.1 フィンランド事故データの',
               '確定的レベルと確率的傾きモデルのトレンド', sep = '\n')
# 原系列
p <- autoplot(y)

# stan
yhat <- ts(yhat, start = start(y), frequency = frequency(y))
p <- autoplot(yhat, p = p, ts.colour = 'blue')
p + ggtitle(title)

title <- 'Figure 3.5.2 Stochastic slope component for Finnish fatalities.'
title <- paste('図 3.5.2 フィンランド事故データの',
               '確定的レベルと確率的傾きモデルの確率的傾き要素', sep = '\n')
slope <- ts(v, start = start(y), frequency = frequency(y))
autoplot(slope) + ggtitle(title)

title <- 'Figure 3.6. Irregular component for Finnish fatalities.'
title <- '図 3.6 フィンランド事故データに対する不規則要素'

autoplot(y - yhat, ts.linetype = 'dashed') + ggtitle(title)
