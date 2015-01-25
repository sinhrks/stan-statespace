library(rstan)

original <- read.table('UKdriversKSI.txt', skip = 1)
data <- original[[1]]
data <- log(data)

standata <-
  within(list(), {
    y <- as.vector(data)
    n <- length(y)
  })

fit <- stan(file = 'fig01_01.stan', data = standata)

slope <- get_posterior_mean(fit, par = 'slope')[, 'mean-all chains']
intercept <- get_posterior_mean(fit, par = 'intercept')[, 'mean-all chains']

# 原系列
plot(data, type = 'l')

# stan
abline(a = intercept, b = slope, col = 'blue')

# 線形回帰
df <- data.frame(y = data, x = 1:length(data))
lm.fit <- lm(y ~ x, data = df)
abline(a = coefficients(lm.fit)[[1]],
       b = coefficients(lm.fit)[[2]],
       col = 'red', lty = 'dashed')
