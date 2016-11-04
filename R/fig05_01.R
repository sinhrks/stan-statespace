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

model_file <- '../models/fig05_01.stan'
cat(paste(readLines(model_file)), sep = '\n')

## @knitr fit_stan

fit <- stan(file = model_file, data = standata,
            iter = 2000, chains = 4)
stopifnot(is.converged(fit))

yhat <- get_posterior_mean(fit, par = 'yhat')[, 'mean-all chains']
mu <- get_posterior_mean(fit, par = 'mu')[, 'mean-all chains']
beta <- get_posterior_mean(fit, par = 'beta')[, 'mean-all chains']
sigma_irreg <- get_posterior_mean(fit, par = 'sigma_irreg')[, 'mean-all chains']

# stopifnot(is.almost.fitted(mu, 5.8787))
is.almost.fitted(mu, 5.8787)
# stopifnot(is.almost.fitted(beta, -0.67166))
is.almost.fitted(beta, -0.67166)
stopifnot(is.almost.fitted(sigma_irreg^2, 0.0230137))

## @knitr output_figures

title <- 'Figure 5.1. Deterministic level and explanatory variable ‘log petrol price’.'
title <- '図 5.1 確定的レベルと説明変数「対数石油価格」'

p <- autoplot(y)
yhat <- ts(yhat, start = start(y), frequency = frequency(y))
p <- autoplot(yhat, p = p, ts.colour = 'blue')
p + ggtitle(title)

title <- paste('Figure 5.2. Conventional classical regression representation of ',
               'deterministic level and explanatory variable log petrol price.', sep = '\n')
title <- paste('図 5.2 確定的レベルと説明変数「対数石油価格」の',
               '伝統的な古典的回帰表現', sep = '\n')
df <- data.frame(drivers = as.vector(ukdrivers),
                petrol = as.vector(ukpetrol),
                stan = as.vector(ukpetrol) * beta + mu)

p <- ggplot(df, aes(x = petrol)) +
  geom_point(aes(y = drivers)) +
  geom_line(aes(y = stan), colour = 'blue') + 
  stat_smooth(aes(y = drivers), method = 'lm', colour = 'red',
              linetype = 'dashed', se = FALSE)
p + ggtitle(title)

title <- 'Figure 5.3. Irregular component for deterministic level model with explanatory variable ‘log petrol price’.'
title <- paste('図 5.3 説明変数「対数石油価格」のある',
               '確定的モデルの不規則要素', sep = '\n')
autoplot(y - yhat, ts.linetype = 'dashed') + ggtitle(title)
