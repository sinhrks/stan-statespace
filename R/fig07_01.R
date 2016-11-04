source('common.R', encoding = 'utf-8')

## @knitr init_stan

y <- ukdrivers
x <- ukpetrol
w <- ukseats

standata <- within(list(), {
  y <- as.vector(y)
  x <- as.vector(x)
  w <- as.vector(w)
  n <- length(y)
})

## @knitr show_model

model_file <- '../models/fig07_01.stan'
cat(paste(readLines(model_file)), sep = '\n')

## @knitr fit_stan

fit <- stan(file = model_file, data = standata,
            iter = 2000, chains = 4)
stopifnot(is.converged(fit))

yhat <- get_posterior_mean(fit, par = 'yhat')[, 'mean-all chains']
mu <- get_posterior_mean(fit, par = 'mu')[, 'mean-all chains']
beta <- get_posterior_mean(fit, par = 'beta')[, 'mean-all chains']
lambda <- get_posterior_mean(fit, par = 'lambda')[, 'mean-all chains']
sigma_irreg <- get_posterior_mean(fit, par = 'sigma_irreg')[, 'mean-all chains']

# stopifnot(is.almost.fitted(mu, 6.4016))
is.almost.fitted(mu, 6.4016)
# stopifnot(is.almost.fitted(beta, -0.45213))
is.almost.fitted(beta, -0.45213)
stopifnot(is.almost.fitted(lambda, -0.19714))
stopifnot(is.almost.fitted(sigma_irreg^2, 0.00740223))

## @knitr output_figures

title <- paste('Figure 7.1. Deterministic level plus variables',
               'log petrol price and seat belt law.', sep = '\n')
title <- paste('図 7.1 確定的レベルプラス対数石油価格と',
               'シートベルト法', sep = '\n')

p <- autoplot(y)
yhat <- ts(yhat, start = start(y), frequency = frequency(y))
p <- autoplot(yhat, p = p, ts.colour = 'blue')
p + ggtitle(title)

