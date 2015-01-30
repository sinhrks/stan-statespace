data {
  int<lower=1> n;
  vector[n] y;
}
parameters {
  # 確率的レベル
  vector[n] mu;
  # 確率的季節項
  vector[n] seasonal;
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
    yhat[t] <- mu[t] + seasonal[t];
  }
}
model {
  # 式 4.1

  # frequency = 12
  for(t in 12:n) {
    seasonal[t] ~ normal(-seasonal[t-11] - seasonal[t-10] - seasonal[t-9] - seasonal[t-8] - seasonal[t-7] - seasonal[t-6] - seasonal[t-5] - seasonal[t-4] - seasonal[t-3] - seasonal[t-2] - seasonal[t-1], sigma_seas);
  }
  for(t in 2:n)
    mu[t] ~ normal(mu[t-1], sigma_level);
  for(t in 1:n)
    y[t] ~ normal(yhat[t], sigma_irreg);
}
