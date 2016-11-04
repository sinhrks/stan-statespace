source('common.R', encoding = 'utf-8')

## @knitr init_stan

y <- ukdrivers

standata <- within(list(), {
  y <- as.vector(y)
  n <- length(y)
})

## @knitr show_model

model_file <- '../models/fig03_04.stan'
cat(paste(readLines(model_file)), sep = '\n')

## @knitr fit_stan

lmresult <- lm(y ~ x, data = data.frame(x = 1:length(y), y = as.numeric(y)))
init <- list(list(mu = rep(mean(y), length(y)), v = coefficients(lmresult)[[2]],
                  sigma_level = sd(y) / 2, sigma_irreg = 0.001))

fit <- stan(file = model_file, data = standata,
            iter = 6000, chains = 4)
stopifnot(is.converged(fit))

mu <- get_posterior_mean(fit, par = 'mu')[, 'mean-all chains']
v <- get_posterior_mean(fit, par = 'v')[, 'mean-all chains']
sigma_irreg <- get_posterior_mean(fit, par = 'sigma_irreg')[, 'mean-all chains']
sigma_level <- get_posterior_mean(fit, par = 'sigma_level')[, 'mean-all chains']
# stopifnot(is.almost.fitted(mu[[1]], 7.4157))
is.almost.fitted(mu[[1]], 7.4157)
# 日本語テキストは誤植 。原書は以下の値。
stopifnot(is.almost.fitted(v, 0.00028897))
stopifnot(is.almost.fitted(sigma_irreg^2, 0.00211869))
stopifnot(is.almost.fitted(sigma_level^2, 0.0121271))

## @knitr output_figures

title <- 'Figure 3.4. Trend of stochastic level and deterministic slope model.'
title <- '図 3.4 確率的レベルと確定的傾きモデルのトレンド'

# 原系列
p <- autoplot(y)

# stan
yhat <- ts(mu, start = start(y), frequency = frequency(y))
p <- autoplot(yhat, p = p, ts.colour = 'blue')
p + ggtitle(title)

