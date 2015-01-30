library(rstan)

source('common.R', encoding = 'utf-8')
y <- ukdrivers

standata <-
  within(list(), {
    y <- as.vector(y)
    n <- length(y)
  })

fit <- stan(file = 'fig01_01.stan', data = standata)
stopifnot(is.converged(fit))

slope <- get_posterior_mean(fit, par = 'slope')[, 'mean-all chains']
intercept <- get_posterior_mean(fit, par = 'intercept')[, 'mean-all chains']

#################################################
# Figure 1.1
#################################################

title <- paste('Figure 1.1. Scatter plot of the log of the number of UK drivers',
               'KSI against time (in months), including regression line.', sep = '\n')

# 原系列
p <- autoplot(y)

# stan
yhat <- ts(1:length(y) * slope + intercept,
           start = start(y), frequency = frequency(y))
# p <- autoplot(yhat, p = p, ts.colour = 'blue', geom = 'point')
p <- autoplot(yhat, p = p, ts.colour = 'blue')

# 線形回帰 (lm)
df <- data.frame(y = y, x = 1:length(y))
fit.lm <- lm(y ~ x, data = df)
intercept.lm <- coefficients(fit.lm)[[1]]
slope.lm <- coefficients(fit.lm)[[2]]
lm.yhat <- ts(df$x * slope.lm + intercept.lm,
              start = start(y), frequency = frequency(y))
p <- autoplot(lm.yhat, p = p, ts.colour = 'red', ts.linetype = 'dashed')
p + ggtitle(title)

#################################################
# Figure 1.2
#################################################

title <- 'Figure 1.2. Log of the number of UK drivers KSI plotted as a time series.'
autoplot(y) + ggtitle(title)

#################################################
# Figure 1.3
#################################################

title <- paste('Figure 1.3. Residuals of classical linear regression of the ',
               'log of the number of UK drivers KSI on time.', sep = '\n')
autoplot(y - yhat, ts.linetype = 'dashed') + ggtitle(title)
