source('common.R', encoding = 'utf-8')

## @knitr init_stan

y <- ukdrivers

standata <- within(list(), {
  y <- as.vector(y)
  n <- length(y)
})

## @knitr show_model

model_file <- '../models/fig03_01.stan'
cat(paste(readLines(model_file)), sep = '\n')

## @knitr fit_stan

stan_fit <- stan(file = model_file, chains = 0)
fit <- pforeach(i = 1:4, .final = sflist2stanfit)({
  stan(fit = stan_fit, data = standata, 
       warmup = 8000, iter = 16000, chains = 1, seed = i)
})
stopifnot(is.converged(fit))

mu <- get_posterior_mean(fit, par = 'mu')[, 'mean-all chains']
v <- get_posterior_mean(fit, par = 'v')[, 'mean-all chains']
sigma_irreg <- get_posterior_mean(fit, par = 'sigma_irreg')[, 'mean-all chains']
sigma_level <- get_posterior_mean(fit, par = 'sigma_level')[, 'mean-all chains']
sigma_drift <- get_posterior_mean(fit, par = 'sigma_drift')[, 'mean-all chains']
# stopifnot(is.almost.fitted(mu[[1]], 7.4157))
is.almost.fitted(mu[[1]], 7.4157)
# stopifnot(is.almost.fitted(v[[1]], 0.00028896))
is.almost.fitted(v[[1]], 0.00028896)
stopifnot(is.almost.fitted(sigma_irreg^2, 0.0021181))
stopifnot(is.almost.fitted(sigma_level^2, 0.012128))
stopifnot(is.almost.fitted(sigma_drift^2, 1.5e-11))

## @knitr output_figures

title <- 'Figure 3.1. Trend of stochastic linear trend model.'
title <- '図 3.1 確率的線形トレンド・モデルのトレンド'

# 原系列
p <- autoplot(y)

# stan
yhat <- ts(mu, start = start(y), frequency = frequency(y))
p <- autoplot(yhat, p = p, ts.colour = 'blue')
p + ggtitle(title)

fmt <- function(){
  function(x) format(x, nsmall = 5, scientific = FALSE)
}

title <- 'Figure 3.2. Slope of stochastic linear trend model.'
title <- '図 3.2 確率的線形トレンド・モデルの傾き'
slope <- ts(v, start = start(y), frequency = frequency(y))
autoplot(slope) + scale_y_continuous(labels = fmt()) + ggtitle(title)

title <- 'Figure 3.3. Irregular component of stochastic linear trend model.'
title <- '図 3.3 確率的線形トレンド・モデルに対する不規則要素'
autoplot(y - yhat, ts.linetype = 'dashed') + ggtitle(title)
