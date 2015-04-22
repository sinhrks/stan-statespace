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

stan_fit <- stan(file = model_file, chains = 0)
fit <- pforeach(i = 1:4, .final = sflist2stanfit)({
  stan(fit = stan_fit, data = standata,
       iter = 2000, chains = 1, seed = i)
})
stopifnot(is.converged(fit))

mu <- get_posterior_mean(fit, par = 'mu')[, 'mean-all chains']
yhat <- get_posterior_mean(fit, par = 'yhat')[, 'mean-all chains']
seasonal <- get_posterior_mean(fit, par = 'seasonal')[, 'mean-all chains']

## @knitr output_figures

title <- 'Figure 4.2. Combined deterministic level and seasonal.'

# 原系列
p <- autoplot(y)

# stan
yhat <- ts(yhat, start = start(y), frequency = frequency(y))
p <- autoplot(yhat, p = p, ts.colour = 'blue')
p + ggtitle(title)

title <- 'Figure 4.3. Deterministic level.'

p <- autoplot(y)
p <- p + geom_hline(yintercept = mu, colour = 'blue')
p + ggtitle(title)


title <- 'Figure 4.4. Deterministic seasonal.'

seasonal <- ts(seasonal, start = start(y), frequency = frequency(y))
autoplot(seasonal, ts.colour = 'blue') + ggtitle(title)

title <- 'Figure 4.5. Irregular component for deterministic level and seasonal model.'

autoplot(y - yhat, ts.linetype = 'dashed') + ggtitle(title)
