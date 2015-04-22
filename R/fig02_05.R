source('common.R', encoding = 'utf-8')

## @knitr init_stan

y <- norwegian_fatalities

standata <- within(list(), {
  y <- as.vector(y)
  n <- length(y)
})

## @knitr show_model

# can use the same model as fig02_03
model_file <- '../models/fig02_03.stan'
cat(paste(readLines(model_file)), sep = '\n')

## @knitr fit_stan

stan_fit <- stan(file = model_file, chains = 0)
fit <- pforeach(i = 1:4, .final = sflist2stanfit)({
  stan(fit = stan_fit, data = standata, chains = 1, seed = i)
})
stopifnot(is.converged(fit))

mu <- get_posterior_mean(fit, par = 'mu')[, 'mean-all chains']
sigma_irreg <- get_posterior_mean(fit, par = 'sigma_irreg')[, 'mean-all chains']
sigma_level <- get_posterior_mean(fit, par = 'sigma_level')[, 'mean-all chains']
# stopifnot(is.almost.fitted(mu[[1]], 6.3048))
is.almost.fitted(mu[[1]], 6.3048)
stopifnot(is.almost.fitted(sigma_irreg^2, 0.00326838))
# stopifnot(is.almost.fitted(sigma_level^2, 0.0047026))
is.almost.fitted(sigma_level^2, 0.0047026)

## @knitr output_figures

title <- 'Figure 2.5. Stochastic level for Norwegian fatalities.'
title <- '図 2.5 ノルウェイの事故に対する確率的レベル'

# 原系列
p <- autoplot(y)

# stan
yhat <- ts(mu, start = start(y), frequency = frequency(y))
p <- autoplot(yhat, p = p, ts.colour = 'blue')
p + ggtitle(title)

title <- 'Figure 2.6. Irregular component for Norwegian fatalities.'
title <- '図 2.6 ノルウェイの事故に対する確率的要素'
autoplot(y - yhat, ts.linetype = 'dashed') + ggtitle(title)

