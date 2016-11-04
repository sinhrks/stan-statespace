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

model_file <- '../models/fig07_02.stan'
cat(paste(readLines(model_file)), sep = '\n')

## @knitr fit_stan

lmresult <- lm(y ~ x, data = data.frame(x = 1:length(y), y = as.numeric(y)))
init <- list(list(mu = rep(mean(y), length(y)), seasonal = rep(0, length(y)),
                  beta = coefficients(lmresult)[[2]], lambda = mean(y) / mean(x),
                  sigma_level = sd(y) / 2, sigma_irreg = 0.001))

fit <- stan(file = model_file, data = standata,
            iter = 8000, chains = 4)
stopifnot(is.converged(fit))

yhat <- get_posterior_mean(fit, par = 'yhat')[, 'mean-all chains']
mu <- get_posterior_mean(fit, par = 'mu')[, 'mean-all chains']
seasonal <- get_posterior_mean(fit, par = 'seasonal')[, 'mean-all chains']
beta <- get_posterior_mean(fit, par = 'beta')[, 'mean-all chains']
lambda <- get_posterior_mean(fit, par = 'lambda')[, 'mean-all chains']
sigma <- get_posterior_mean(fit, par = 'sigma_irreg')[, 'mean-all chains']
sigma_seas <- sigma[[1]]
sigma_level <- sigma[[2]]
sigma_irreg <- sigma[[3]]

stopifnot(is.almost.fitted(sigma_irreg^2, 0.00378629))
stopifnot(is.almost.fitted(sigma_level^2, 0.000267632))
stopifnot(is.almost.fitted(sigma_seas^2, 0.0000011622))

## @knitr output_figures

title <- paste('Figure 7.2. Stochastic level plus variables',
               'log petrol price and seat belt law.', sep = '\n')
title <- paste('図 7.2 確率的レベルプラス対数石油価格と',
               'シートベルト法', sep = '\n')

p <- autoplot(y)
yhat <- ts(yhat, start = start(y), frequency = frequency(y))
p <- autoplot(yhat, p = p, ts.colour = 'blue')
p + ggtitle(title)

title <- 'Figure 7.3. Stochastic seasonal.'
title <- '図 7.3 確率的季節要素'
seasonal <- ts(seasonal, start = start(y), frequency = frequency(y))
autoplot(seasonal, ts.colour = 'blue') + ggtitle(title)

title <- 'Figure 7.4. Irregular component for stochastic level and seasonal model.'
title <- '図 7.4 確率的レベルと季節モデルに対する不規則要素'
autoplot(y - yhat, ts.linetype = 'dashed') + ggtitle(title)
