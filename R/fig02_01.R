source('common.R', encoding = 'utf-8')

## @knitr init_stan

y <- ukdrivers

standata <- within(list(), {
  y <- as.vector(y)
  n <- length(y)
})

## @knitr show_model

model_file <- '../models/fig02_01.stan'
cat(paste(readLines(model_file)), sep = '\n')

## @knitr fit_stan

fit <- stan(file = model_file, data = standata,
            iter = 2000, chains = 4)
stopifnot(is.converged(fit))

mu <- get_posterior_mean(fit, par = 'mu')[, 'mean-all chains']

## @knitr output_figures

title <- 'Figure 2.1. Deterministic level.'
title <- '図 2.1 確定的レベル'

# 原系列
p <- autoplot(y)

# stan
p <- p + geom_hline(yintercept = mu, colour = 'blue')

# 通常の計算結果
p <- p + geom_hline(yintercept = mean(y),
                    colour = 'red', linetype = 'dashed')
p + ggtitle(title)

title <- 'Figure 2.2. Irregular component for deterministic level model.'
title <- '図 2.2 確定的レベルに対する不規則要素'
autoplot(y - mu, ts.linetype = 'dashed') + ggtitle(title)
