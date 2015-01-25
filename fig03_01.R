library(rstan)

original <- read.table('UKdriversKSI.txt', skip = 1)
data <- original[[1]]
data <- log(data)

standata <-
  within(list(), {
    y <- as.vector(data)
    n <- length(y)
  })

fit <- stan(file = 'fig03_01.stan', data = standata)
mu <- get_posterior_mean(fit, par = 'mu')[, 'mean-all chains']
v <- get_posterior_mean(fit, par = 'v')[, 'mean-all chains']

# fig03_01
plot(data, type = 'l')
lines(mu, col = 'blue')

# fig03_02
plot(v, type = 'l')
