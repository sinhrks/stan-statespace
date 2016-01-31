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

lmresult <- lm(y ~ x, data = data.frame(x = 1:length(y), y = as.numeric(y)))
init <- list(list(mu = rep(mean(y), length(y)),
                  v = rep(coefficients(lmresult)[[2]], length(y) - 1),
                  sigma_level = sd(y) / 2,
                  sigma_drift = sd(y) / 2,
                  sigma_irreg = 0.001))

fit <- stan(file = model_file, data = standata,
            iter = 10000, chains = 4, seed = 12345)
stopifnot(is.converged(fit))

mu <- get_posterior_mean(fit, par = 'mu')[, 'mean-all chains']
v <- get_posterior_mean(fit, par = 'v')[, 'mean-all chains']
sigma <- get_posterior_mean(fit, par = 'sigma')[, 'mean-all chains']
sigma_drift <- sigma[[1]]
sigma_irreg <- sigma[[2]]
sigma_level <- sigma[[3]]

# stopifnot(is.almost.fitted(mu[[1]], 7.4157))
is.almost.fitted(mu[[1]], 7.4157)
stopifnot(is.almost.fitted(v[[1]], 0.00028896))
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

