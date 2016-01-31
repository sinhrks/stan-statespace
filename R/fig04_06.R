source('common.R', encoding = 'utf-8')

## @knitr init_stan

y <- ukdrivers

standata <- within(list(), {
  y <- as.vector(y)
  n <- length(y)
})

## @knitr show_model

model_file <- '../models/fig04_06.stan'
cat(paste(readLines(model_file)), sep = '\n')

## @knitr fit_stan

fit <- stan(file = model_file, data = standata,
            iter = 10000, chains = 4)
stopifnot(is.converged(fit))

yhat <- get_posterior_mean(fit, par = 'yhat')[, 'mean-all chains']
mu <- get_posterior_mean(fit, par = 'mu')[, 'mean-all chains']
seasonal <- get_posterior_mean(fit, par = 'seasonal')[, 'mean-all chains']

sigma_irreg <- get_posterior_mean(fit, par = 'sigma_irreg')[, 'mean-all chains']
sigma_level <- get_posterior_mean(fit, par = 'sigma_level')[, 'mean-all chains']
stopifnot(is.almost.fitted(sigma_irreg^2, 0.00351385))
stopifnot(is.almost.fitted(sigma_level^2, 0.000945723))

## @knitr output_figures

title <- 'Figure 4.6. Stochastic level.'
title <- '図 4.6 確率的レベル'

# 原系列
p <- autoplot(y)

# stan
mu <- ts(mu, start = start(y), frequency = frequency(y))
p <- autoplot(mu, p = p, ts.colour = 'blue')
p + ggtitle(title)

title <- 'Figure 4.7. Stochastic seasonal.'
title <- '図 4.7 確率的季節'

seasonal <- ts(seasonal, start = start(y), frequency = frequency(y))
autoplot(seasonal, ts.colour = 'blue') + ggtitle(title)

title <- 'Figure 4.8. Stochastic seasonal for the year 1969.'
title <- '図 4.8 1969年に対する確率的季節'

s1969 <- ts(seasonal[1:12], start = start(y), frequency = frequency(y))
autoplot(s1969, ts.colour = 'blue') + ggtitle(title)

title <- 'Figure 4.9. Irregular component for stochastic level and seasonal model.'
title <- '図 4.9 確率的レベルと季節モデルに対する不規則要素'

autoplot(y - yhat, ts.linetype = 'dashed') + ggtitle(title)

