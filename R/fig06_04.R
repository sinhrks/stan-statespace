source('common.R', encoding = 'utf-8')

## @knitr init_stan

y <- ukdrivers
w <- ukseats

standata <- within(list(), {
  y <- as.vector(y)
  w <- as.vector(w)
  n <- length(y)
})

## @knitr show_model

model_file <- '../models/fig06_04.stan'
cat(paste(readLines(model_file)), sep = '\n')

## @knitr fit_stan

fit <- stan(file = model_file, data = standata,
            iter = 2000, chains = 4)
stopifnot(is.converged(fit))

yhat <- get_posterior_mean(fit, par = 'yhat')[, 'mean-all chains']
mu <- get_posterior_mean(fit, par = 'mu')[, 'mean-all chains']
lambda <- get_posterior_mean(fit, par = 'lambda')[, 'mean-all chains']
sigma_irreg <- get_posterior_mean(fit, par = 'sigma_irreg')[, 'mean-all chains']

stopifnot(is.almost.fitted(mu[[1]], 7.4107))
# stopifnot(is.almost.fitted(lambda, -0.3785))
is.almost.fitted(lambda, -0.3785)
# stopifnot(is.almost.fitted(sigma_irreg^2, 0.0104111))
is.almost.fitted(sigma_irreg^2, 0.0104111)

## @knitr output_figures

title <- 'Figure 6.4. Stochastic level and intervention variable.'
title <- '図 6.4 確率的レベルと干渉変数'

p <- autoplot(y)
yhat <- ts(yhat, start = start(y), frequency = frequency(y))
p <- autoplot(yhat, p = p, ts.colour = 'blue')
p + ggtitle(title)

title <- paste('Figure 6.5. Irregular component for',
               'stochastic level model with intervention variable.', sep = '\n')
title <- paste('図 6.5 確率的レベル・モデルに',
               '干渉変数がある場合の不規則要素', sep = '\n')
# テキストのタイトルは誤植
autoplot(y - yhat, ts.linetype = 'dashed') + ggtitle(title)
