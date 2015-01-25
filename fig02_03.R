library(rstan)

original <- read.table('UKdriversKSI.txt', skip = 1)
data <- original[[1]]
data <- log(data)

standata <-
  within(list(), {
    y <- as.vector(data)
    n <- length(y)
  })

fit <- stan(file = 'fig02_03.stan', data = standata)
mu <- get_posterior_mean(fit, par = 'mu')[, 'mean-all chains']

plot(data, type = 'l')
lines(mu, col = 'blue')
