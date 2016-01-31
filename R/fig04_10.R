source('common.R', encoding = 'utf-8')

## @knitr init_stan

y <- ukinflation

standata <- within(list(), {
  y <- as.vector(y)
  n <- length(y)
})

## @knitr show_model

model_file <- '../models/fig04_10.stan'
cat(paste(readLines(model_file)), sep = '\n')

## @knitr fit_stan

fit <- stan(file = model_file, data = standata,
            iter = 2000, chains = 4)
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

## @knitr output_figures

title <- 'Figure 4.10.1. Stochastic level.'
title <- '図 4.10.1 英国インフレーション系列の確率的レベル'

# 原系列
p <- autoplot(y)

# stan
mu <- ts(mu, start = start(y), frequency = frequency(y))
p <- autoplot(mu, p = p, ts.colour = 'blue')
p + ggtitle(title) + xlab('') + ylab('')

title <- 'Figure 4.10.2. Stochastic seasonal.'
title <- '図 4.10.2 英国インフレーション系列の確率的季節'

seasonal <- ts(seasonal, start = start(y), frequency = frequency(y))
autoplot(seasonal, ts.colour = 'blue') + ggtitle(title)

title <- 'Figure 4.10.3. Irregular component for stochastic level and seasonal model.'
title <- '図 4.10.3 英国インフレーション系列の不規則要素'
autoplot(y - yhat, ts.linetype = 'dashed') + ggtitle(title)

