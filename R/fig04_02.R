source('common.R', encoding = 'utf-8')

## @knitr init_stan

y <- ukdrivers

standata <- within(list(), {
  y <- as.vector(y)
  n <- length(y)
})

## @knitr show_model

model_file <- '../models/fig04_02.stan'
cat(paste(readLines(model_file)), sep = '\n')

## @knitr fit_stan

fit <- stan(file = model_file, data = standata,
            iter = 2000, chains = 4)
stopifnot(is.converged(fit))

mu <- get_posterior_mean(fit, par = 'mu')[, 'mean-all chains']
yhat <- get_posterior_mean(fit, par = 'yhat')[, 'mean-all chains']
seasonal <- get_posterior_mean(fit, par = 'seasonal')[, 'mean-all chains']

## @knitr output_figures

title <- 'Figure 4.2. Combined deterministic level and seasonal.'
title <- '図 4.2 結合した確定的なレベルと季節要素'
 
# 原系列
p <- autoplot(y)

# stan
yhat <- ts(yhat, start = start(y), frequency = frequency(y))
p <- autoplot(yhat, p = p, ts.colour = 'blue')
p + ggtitle(title)

title <- 'Figure 4.3. Deterministic level.'
title <- '図 4.3 確定的レベル'
 
p <- autoplot(y)
p <- p + geom_hline(yintercept = mu, colour = 'blue')
p + ggtitle(title)


title <- 'Figure 4.4. Deterministic seasonal.'
title <- '図 4.3 確定的季節'
 
seasonal <- ts(seasonal, start = start(y), frequency = frequency(y))
autoplot(seasonal, ts.colour = 'blue') + ggtitle(title)

title <- 'Figure 4.5. Irregular component for deterministic level and seasonal model.'
title <- '図 4.5 確定的なレベルと季節モデルに対する不規則要素'
 
autoplot(y - yhat, ts.linetype = 'dashed') + ggtitle(title)

