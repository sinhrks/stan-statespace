library(rstan)

source('common.R', encoding = 'utf-8')
y <- ukdrivers

standata <- within(list(), {
  y <- as.vector(y)
  n <- length(y)
})

stan_fit <- stan(file = 'fig04_02.stan', chains = 0)
sflist <- pforeach(i=1:3)({
  stan(fit = stan_fit, data = standata,
       iter = 2000, chains = 1, seed = i)
})
fit <- sflist2stanfit(sflist)
stopifnot(is.converged(fit))

mu <- get_posterior_mean(fit, par = 'mu')[, 'mean-all chains']
yhat <- get_posterior_mean(fit, par = 'yhat')[, 'mean-all chains']
seasonal <- get_posterior_mean(fit, par = 'seasonal')[, 'mean-all chains']

#################################################
# Figure 4.2
#################################################

title <- 'Figure 4.2. Combined deterministic level and seasonal.'

# 原系列
p <- autoplot(y)

# stan
yhat <- ts(yhat, start = start(y), frequency = frequency(y))
p <- autoplot(yhat, p = p, ts.colour = 'blue')
p + ggtitle(title)

#################################################
# Figure 4.3
#################################################

title <- 'Figure 4.3. Deterministic level.'

p <- autoplot(y)
p <- p + geom_hline(yintercept = mu, colour = 'blue')
p + ggtitle(title)

#################################################
# Figure 4.4
#################################################

title <- 'Figure 4.4. Deterministic seasonal.'
seasonal <- ts(seasonal, start = start(y), frequency = frequency(y))
autoplot(seasonal, ts.colour = 'blue') + ggtitle(title)

#################################################
# Figure 4.5
#################################################

title <- 'Figure 4.5. Irregular component for deterministic level and seasonal model.'
autoplot(y - yhat, ts.linetype = 'dashed') + ggtitle(title)
