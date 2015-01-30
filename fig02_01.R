library(rstan)

source('common.R', encoding = 'utf-8')
y <- ukdrivers

standata <- within(list(), {
  y <- as.vector(y)
  n <- length(y)
})

fit <- stan(file = 'fig02_01.stan', data = standata)
stopifnot(is.converged(fit))

mu <- get_posterior_mean(fit, par = 'mu')[, 'mean-all chains']

#################################################
# Figure 2.1
#################################################

title <- 'Figure 2.1. Deterministic level.'

# 原系列
p <- autoplot(y)

# stan
p <- p + geom_hline(yintercept = mu, colour = 'blue')

# 通常の計算結果
p <- p + geom_hline(yintercept = mean(y),
                    colour = 'red', linetype = 'dashed')
p + ggtitle(title)

#################################################
# Figure 2.2
#################################################

title <- 'Figure 2.2. Irregular component for deterministic level model.'
autoplot(y - mu, ts.linetype = 'dashed') + ggtitle(title)
