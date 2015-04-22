source('common.R', encoding = 'utf-8')

## @knitr init_stan

y <- ukdrivers
x <- ukpetrol

standata <- within(list(), {
  y <- as.vector(y)
  x <- as.vector(x)
  n <- length(y)
})

## @knitr show_model

model_file <- '../models/fig04_06.stan'
cat(paste(readLines(model_file)), sep = '\n')

## @knitr fit_stan

stan_fit <- stan(file = model_file, chains = 0)
fit <- pforeach(i = 1:4, .final = sflist2stanfit)({
  stan(fit = stan_fit, data = standata,
       iter = 2000, chains = 1, seed = i)
})
stopifnot(is.converged(fit))

yhat <- get_posterior_mean(fit, par = 'yhat')[, 'mean-all chains']
mu <- get_posterior_mean(fit, par = 'mu')[, 'mean-all chains']
beta <- get_posterior_mean(fit, par = 'beta')[, 'mean-all chains']
sigma_irreg <- get_posterior_mean(fit, par = 'sigma_irreg')[, 'mean-all chains']

stopifnot(is.almost.fitted(mu, 5.8787))
stopifnot(is.almost.fitted(beta, -0.67166))
stopifnot(is.almost.fitted(sigma_irreg^2, 0.0230137))

## @knitr output_figures

title <- 'Figure 5.1. Deterministic level and explanatory variable ‘log petrol price’.'

# 原系列
p <- autoplot(y)

# stan
yhat <- ts(yhat, start = start(y), frequency = frequency(y))
p <- autoplot(yhat, p = p, ts.colour = 'blue')
p + ggtitle(title)

# Figure 5.2 is the same as Figure 1.1.

title <- 'Figure 5.3. Irregular component for deterministic level model with explanatory variable ‘log petrol price’.'
autoplot(y - yhat, ts.linetype = 'dashed') + ggtitle(title)
