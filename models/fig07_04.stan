data {
  int<lower=1> n;
  vector[n] y;
  vector[n] w;
}
parameters {
  # 確率的レベル
  vector[n] mu;
  # 確率的季節項
  vector[n] seasonal;
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
    yhat[t] <- mu[t] + lambda * w[t];
  }
}
model {
  # 式 7.1

  # frequency = 4
  for(t in 4:n) {
    seasonal[t] ~ normal(-seasonal[t-3] - seasonal[t-2] - seasonal[t-1], sigma_seas);
  }
  for(t in 2:n)
    mu[t] ~ normal(mu[t-1], sigma_level);
  for(t in 1:n)
    y[t] ~ normal(yhat[t] + seasonal[t], sigma_irreg);
}
