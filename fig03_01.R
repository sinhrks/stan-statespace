library(rstan)

source('common.R', encoding = 'utf-8')
y <- ukdrivers

standata <- within(list(), {
  y <- as.vector(y)
  n <- length(y)
})

# initial values
mus <- matrix(rnorm(length(y) * 4, mean = mean(y), sd = 0.1), ncol = 4)
vs <- matrix(rnorm((length(y) - 1) * 4, mean = 0, sd = 0.001), ncol = 4)
irregs <- abs(rnorm(4, sd = 0.001))
levels <- abs(rnorm(4, sd = 0.001))
drifts <- abs(rnorm(4, sd = 0.0001))
inits <- list(list(mu = mus[, 1], v = vs[, 1], sigma_irreg = irregs[1],
                   sigma_level = levels[1], sigma_drift = drifts[1]),
              list(mu = mus[, 2], v = vs[, 2], sigma_irreg = irregs[2],
                   sigma_level = levels[2], sigma_drift = drifts[2]),
              list(mu = mus[, 3], v = vs[, 3], sigma_irreg = irregs[3],
                   sigma_level = levels[3], sigma_drift = drifts[3]),
              list(mu = mus[, 4], v = vs[, 4], sigma_irreg = irregs[4],
                   sigma_level = levels[4], sigma_drift = drifts[4]))

fit <- stan(file = 'fig03_01.stan', data = standata, iter = 8000, init = inits)
stopifnot(is.converged(fit))

mu <- get_posterior_mean(fit, par = 'mu')[, 'mean-all chains']
v <- get_posterior_mean(fit, par = 'v')[, 'mean-all chains']
sigma_irreg <- get_posterior_mean(fit, par = 'sigma_irreg')[, 'mean-all chains']
sigma_level <- get_posterior_mean(fit, par = 'sigma_level')[, 'mean-all chains']
sigma_drift <- get_posterior_mean(fit, par = 'sigma_drift')[, 'mean-all chains']
stopifnot(is.almost.fitted(mu[[1]], 7.4157))
stopifnot(is.almost.fitted(v[[1]], 0.00028896))
stopifnot(is.almost.fitted(sigma_irreg^2, 0.0021181))
stopifnot(is.almost.fitted(sigma_level^2, 0.012128))
stopifnot(is.almost.fitted(sigma_drift^2, 1.5e-11))

#################################################
# Figure 3.1
#################################################

title <- 'Figure 3.1. Trend of stochastic linear trend model.'

# 原系列
p <- autoplot(y)

# stan
yhat <- ts(mu, start = start(y), frequency = frequency(y))
p <- autoplot(yhat, p = p, ts.colour = 'blue')
p + ggtitle(title)

#################################################
# Figure 3.2
#################################################

fmt <- function(){
  function(x) format(x, nsmall = 5, scientific = FALSE)
}

title <- 'Figure 3.2. Slope of stochastic linear trend model.'
slope <- ts(v, start = start(y), frequency = frequency(y))
autoplot(slope) + scale_y_continuous(labels = fmt()) + ggtitle(title)

#################################################
# Figure 3.3
#################################################

title <- 'Figure 3.3. Irregular component of stochastic linear trend model.'
autoplot(y - yhat, ts.linetype = 'dashed') + ggtitle(title)
