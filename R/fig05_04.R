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

model_file <- '../models/fig05_04.stan'
cat(paste(readLines(model_file)), sep = '\n')

## @knitr fit_stan

lmresult <- lm(y ~ x, data = data.frame(x = 1:length(y), y = as.numeric(y)))
init <- list(list(mu = rep(mean(y), length(y)), beta = coefficients(lmresult)[[2]],
                  sigma_level = sd(y) / 2, sigma_irreg = 0.001))

stan_fit <- stan(file = model_file, chains = 0)
fit <- pforeach(i = 1:4, .final = sflist2stanfit)({
  stan(fit = stan_fit, data = standata, 
       iter = 4000, chains = 1, seed = i, init = init)
})
stopifnot(is.converged(fit))

yhat <- get_posterior_mean(fit, par = 'yhat')[, 'mean-all chains']
mu <- get_posterior_mean(fit, par = 'mu')[, 'mean-all chains']
beta <- get_posterior_mean(fit, par = 'beta')[, 'mean-all chains']
sigma_irreg <- get_posterior_mean(fit, par = 'sigma_irreg')[, 'mean-all chains']
# stopifnot(is.almost.fitted(mu[[1]], 6.824))
is.almost.fitted(mu[[1]], 6.824)
# stopifnot(is.almost.fitted(beta, -0.26105))
is.almost.fitted(beta, -0.26105)
# stopifnot(is.almost.fitted(sigma_irreg^2, 0.0116673))
is.almost.fitted(sigma_irreg^2, 0.0116673)

## @knitr output_figures

title <- 'Figure 5.4. Stochastic level and deterministic explanatory variable ‘log petrol price’.'
title <- '図 5.4 確率的レベルと確定的説明変数「対数石油価格」'

p <- autoplot(y)
yhat <- ts(yhat, start = start(y), frequency = frequency(y))
p <- autoplot(yhat, p = p, ts.colour = 'blue')
p + ggtitle(title)

title <- 'Figure 5.5. Irregular for stochastic level model with deterministic explanatory variable ‘log petrol price’.'
title <- paste('図 5.5 確定的説明変数「対数石油価格」のある',
               '確率的レベル・モデルの不規則要素', sep = '\n')
autoplot(y - yhat, ts.linetype = 'dashed') + ggtitle(title)
