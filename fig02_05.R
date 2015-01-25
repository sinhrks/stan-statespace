library(rstan)

original <- read.table('Norwayfinland.txt', skip = 1)
colnames(original) <- c('year', 'Norwegian_fatalities',
                        'Finnish_fatalities')
data <- original[['Norwegian_fatalities']]
data <- log(data)

standata <-
  within(list(), {
    y <- as.vector(data)
    n <- length(y)
  })

# can use the same model as fig02_03
fitted <- stan(file = 'fig02_03.stan', data = standata)

mu <- get_posterior_mean(fitted, par = 'mu')[, 'mean-all chains']

plot(data, type = 'l')
lines(mu, col = 'blue')

