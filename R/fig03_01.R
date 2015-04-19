source('common.R', encoding = 'utf-8')

## @knitr init_stan

y <- ukdrivers

standata <- within(list(), {
  y <- as.vector(y)
  n <- length(y)
})

# initial values
mus <- matrix(rnorm(length(y) * 4, mean = mean(y), sd = 0.1), ncol = 4)
vs <- matrix(rnorm((length(y) - 1) * 4, mean = 0, sd = 0.001), ncol = 4)
irregs <- abs(rnorm(4, sd = 0.001))
levels <- abs(rnorm(4, sd = 0.001))
drifts <- abs(rnorm(4, sd = 0.0001))
inits <- list(list(mu = mus[, 1], v = vs[, 1], sigma_irreg = irregs[1],
                   sigma_level = levels[1], sigma_drift = drifts[1]),
              list(mu = mus[, 2], v = vs[, 2], sigma_irreg = irregs[2],
                   sigma_level = levels[2], sigma_drift = drifts[2]),
              list(mu = mus[, 3], v = vs[, 3], sigma_irreg = irregs[3],
                   sigma_level = levels[3], sigma_drift = drifts[3]),
              list(mu = mus[, 4], v = vs[, 4], sigma_irreg = irregs[4],
                   sigma_level = levels[4], sigma_drift = drifts[4]))

## @knitr show_model

model_file <- '../models/fig03_01.stan'
cat(paste(readLines(model_file)), sep = '\n')

## @knitr fit_stan

stan_fit <- stan(file = model_file, chains = 0)
sflist <- pforeach(i=1:4)({
  stan(fit = stan_fit, data = standata, # init = inits,
       warmup = 8000, iter = 16000, chains = 1, seed = i)
})
fit <- sflist2stanfit(sflist)
stopifnot(is.converged(fit))

mu <- get_posterior_mean(fit, par = 'mu')[, 'mean-all chains']
v <- get_posterior_mean(fit, par = 'v')[, 'mean-all chains']
sigma_irreg <- get_posterior_mean(fit, par = 'sigma_irreg')[, 'mean-all chains']
sigma_level <- get_posterior_mean(fit, par = 'sigma_level')[, 'mean-all chains']
sigma_drift <- get_posterior_mean(fit, par = 'sigma_drift')[, 'mean-all chains']
stopifnot(is.almost.fitted(mu[[1]], 7.4157))
stopifnot(is.almost.fitted(v[[1]], 0.00028896))
stopifnot(is.almost.fitted(sigma_irreg^2, 0.0021181))
stopifnot(is.almost.fitted(sigma_level^2, 0.012128))
stopifnot(is.almost.fitted(sigma_drift^2, 1.5e-11))

## @knitr fig_3.1

title <- 'Figure 3.1. Trend of stochastic linear trend model.'
title <- '図 3.1 確率的線形トレンド・モデルのトレンド'

# 原系列
p <- autoplot(y)

# stan
yhat <- ts(mu, start = start(y), frequency = frequency(y))
p <- sfautoplot(yhat, p = p, ts.colour = 'blue')
p + ggtitle(title)

## @knitr fig_3.2

fmt <- function(){
  function(x) format(x, nsmall = 5, scientific = FALSE)
}

title <- 'Figure 3.2. Slope of stochastic linear trend model.'
title <- '図 3.2 確率的線形トレンド・モデルの傾き'
slope <- ts(v, start = start(y), frequency = frequency(y))
autoplot(slope) + scale_y_continuous(labels = fmt()) + ggtitle(title)

## @knitr fig_3.3

title <- 'Figure 3.3. Irregular component of stochastic linear trend model.'
title <- '図 3.3 確率的線形トレンド・モデルに対する不規則要素'
autoplot(y - yhat, ts.linetype = 'dashed') + ggtitle(title)
