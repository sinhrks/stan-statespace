library(rstan)

original <- read.table('Norwayfinland.txt', skip = 1)
colnames(original) <- c('year', 'Norwegian_fatalities',
                        'Finnish_fatalities')
data <- original[['Finnish_fatalities']]
data <- log(data)

standata <-
  within(list(), {
    y <- as.vector(data)
    n <- length(y)
  })

# can use the same model as fig03_01
fit <- stan(file = 'fig03_01.stan', data = standata)
mu <- get_posterior_mean(fit, par = 'mu')[, 'mean-all chains']
v <- get_posterior_mean(fit, par = 'v')[, 'mean-all chains']

# fig03_05 (top)
plot(data, type = 'l')
lines(mu, col = 'blue')

# fig03_05 (bottom)
plot(v, type = 'l')
