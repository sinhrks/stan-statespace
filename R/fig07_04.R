source('common.R', encoding = 'utf-8')

## @knitr init_stan

y <- ukinflation
w <- ukpulse

standata <- within(list(), {
  y <- as.vector(y)
  w <- as.vector(w)
  n <- length(y)
})

## @knitr show_model

model_file <- '../models/fig07_04.stan'
cat(paste(readLines(model_file)), sep = '\n')

## @knitr fit_stan

fit <- stan(file = model_file, data = standata,
            iter = 2000, chains = 4)
stopifnot(is.converged(fit))

yhat <- get_posterior_mean(fit, par = 'yhat')[, 'mean-all chains']
mu <- get_posterior_mean(fit, par = 'mu')[, 'mean-all chains']
seasonal <- get_posterior_mean(fit, par = 'seasonal')[, 'mean-all chains']
lambda <- get_posterior_mean(fit, par = 'lambda')[, 'mean-all chains']
sigma_irreg <- get_posterior_mean(fit, par = 'sigma_irreg')[, 'mean-all chains']
sigma_level <- get_posterior_mean(fit, par = 'sigma_level')[, 'mean-all chains']
sigma_seas <- get_posterior_mean(fit, par = 'sigma_seas')[, 'mean-all chains']

stopifnot(is.almost.fitted(sigma_irreg^2, 2.1990e-5))
stopifnot(is.almost.fitted(sigma_level^2, 1.8595e-5))
stopifnot(is.almost.fitted(sigma_seas^2, 0.0110e-5))

## @knitr output_figures

title <- paste('Figure 7.7.1. Local level (including pulse interventions) ',
               'for UK inflation time series data.', sep = '\n')
title <- paste('図 7.7.1 英国インフレーション時系列データに',
               '対するローカル・レベル(含むパルス干渉変数)', sep = '\n')
p <- autoplot(y)
yhat <- ts(yhat, start = start(y), frequency = frequency(y))
p <- autoplot(yhat, p = p, ts.colour = 'blue')
p + ggtitle(title)

title <- 'Figure 7.7.2. Local seasonal for UK inflation time series data.'
title <- '図 7.7.2 ローカル季節'
seasonal <- ts(seasonal, start = start(y), frequency = frequency(y))
autoplot(seasonal, ts.colour = 'blue') + ggtitle(title)

title <- 'Figure 7.7.3. Irregular for UK inflation time series data.'
title <- '図 7.7.3 不規則要素'
autoplot(y - yhat, ts.linetype = 'dashed') + ggtitle(title)
