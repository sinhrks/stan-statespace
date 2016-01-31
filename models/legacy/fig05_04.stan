data {
  int<lower=1> n;
  vector[n] y;
  vector[n] x;
}
parameters {
  # 確率的レベル
  vector<lower=mean(y)-3*sd(y), upper=mean(y)+3*sd(y)>[n] mu;

  # 確定的回帰係数
  real<lower=-0.5, upper=0.5> beta;

  # レベル撹乱項
  real<lower=0> sigma_level;
  # 観測撹乱項
  real<lower=0> sigma_irreg;
}
transformed parameters {
  vector[n] yhat;
  for(t in 1:n) {
    yhat[t] <- mu[t] + beta * x[t];
  }
}
model {
  # 式 5.2
  mu[1] ~ normal(y[1], sigma_level);
  for (t in 2:n) {
    mu[t] ~ normal(mu[t-1], sigma_level);
  }
  for (t in 1:n) {
    y[t] ~ normal(yhat[t], sigma_irreg);
  }
  sigma_level ~ inv_gamma(0.001, 0.001);
  sigma_irreg ~ inv_gamma(0.001, 0.001);
  beta ~ normal(0, 2);
}
