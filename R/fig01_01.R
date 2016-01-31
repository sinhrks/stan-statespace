source('common.R', encoding = 'utf-8')

## @knitr init_stan

y <- ukdrivers

standata <- within(list(), {
  y <- as.vector(y)
  n <- length(y)
})

## @knitr show_model

model_file <- '../models/fig01_01.stan'
cat(paste(readLines(model_file)), sep = '\n')

## @knitr fit_stan

fit <- stan(model_file, data = standata,
            iter = 2000, chains = 4)
stopifnot(is.converged(fit))

slope <- get_posterior_mean(fit, par = 'slope')[, 'mean-all chains']
intercept <- get_posterior_mean(fit, par = 'intercept')[, 'mean-all chains']

## @knitr output_figures

title <- paste('Figure 1.1. Scatter plot of the log of the number of UK drivers',
               'KSI against time (in months), including regression line.', sep = '\n')
title <- paste('図 1.1 (月次)時間に対する英国ドライバーの',
               '死傷者数の対数に回帰線を含めた散布図', sep = '\n')

# 原系列
p <- autoplot(y, ts.geom = 'point')

# stan
yhat <- ts(1:length(y) * slope + intercept,
           start = start(y), frequency = frequency(y))
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

title <- 'Figure 1.2. Log of the number of UK drivers KSI plotted as a time series.'
title <- '図 1.2 英国ドライバーの死傷者数の対数の時系列'
autoplot(y) + ggtitle(title)

title <- paste('Figure 1.3. Residuals of classical linear regression of the ',
               'log of the number of UK drivers KSI on time.', sep = '\n')
title <- paste('図 1.3 時間に対する英国ドライバーの',
               '死傷者数の対数の古典的線形型回帰の残差', sep = '\n')
autoplot(y - yhat, ts.linetype = 'dashed') + ggtitle(title)
