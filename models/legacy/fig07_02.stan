data {
  int<lower=1> n;
  vector[n] y;
  vector[n] x;
  vector[n] w;
}
parameters {
  # 確率的レベル
  vector<lower=mean(y)-3*sd(y), upper=mean(y)+3*sd(y)>[n] mu;
  # 確率的季節項
  vector[n] seasonal;
  # 確定的回帰係数
  real beta;
  # 確定的係数
  real lambda;
  # レベル撹乱項
  real<lower=0> sigma_level;
  # 季節性撹乱項
  real<lower=0> sigma_seas;
  # 観測撹乱項
  real<lower=0> sigma_irreg;
}
transformed parameters {
  vector[n] yhat;
  for(t in 1:n) {
    yhat[t] <- mu[t] + beta * x[t] + lambda * w[t];
  }
}
model {
  # 式 7.1

  # frequency = 12
  for(t in 12:n) {
    seasonal[t] ~ normal(-seasonal[t-11] - seasonal[t-10] - seasonal[t-9] - seasonal[t-8] - seasonal[t-7] - seasonal[t-6] - seasonal[t-5] - seasonal[t-4] - seasonal[t-3] - seasonal[t-2] - seasonal[t-1], sigma_seas);
  }
  for(t in 2:n)
    mu[t] ~ normal(mu[t-1], sigma_level);
  for(t in 1:n)
    y[t] ~ normal(yhat[t] + seasonal[t], sigma_irreg);

  # beta ~ normal(0, 2);
  # lambda ~ normal(mean(y) / mean(x), 2);
  sigma_level ~ inv_gamma(0.001, 0.001);
  sigma_seas ~ inv_gamma(0.001, 0.001);
  sigma_irreg ~ inv_gamma(0.001, 0.001);
}
