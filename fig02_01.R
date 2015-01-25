library(rstan)

original <- read.table('UKdriversKSI.txt', skip = 1)
data <- original[[1]]
data <- log(data)

standata <-
  within(list(), {
    y <- as.vector(data)
    n <- length(y)
  })

fit <- stan(file = 'fig02_01.stan', data = standata)
mu <- get_posterior_mean(fit, par = 'mu')[, 'mean-all chains']

plot(data, type = 'l')

# stan
abline(h = mu, col = 'blue')

# 通常の計算結果
abline(h = mean(data), col = 'red', lty = 'dashed')
