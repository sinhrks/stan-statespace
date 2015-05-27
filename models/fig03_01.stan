data {
  int<lower=1> n;
  vector[n] y;
}
parameters {
  # 確率的レベル
  vector[n] mu;
  # 確率的傾き
  vector[n-1] v;
  # レベル撹乱項
  real<lower=0> sigma_level;
  # 傾き撹乱項
  real<lower=0> sigma_drift;
  # 観測撹乱項
  real<lower=0> sigma_irreg;
}
transformed parameters {
  vector[n] yhat;
  for(t in 1:n) {
    yhat[t] <- mu[t];
  }
}
model {
  # 式 3.1
  v[1] ~ normal(0, sigma_drift);
  for(t in 2:n-1)
    v[t] ~ normal(v[t-1], sigma_drift);
  mu[1] ~ normal(y[1], sigma_level);
  for(t in 2:n)
    mu[t] ~ normal(mu[t-1] + v[t-1], sigma_level);
  for(t in 1:n)
    y[t] ~ normal(yhat[t], sigma_irreg);
  sigma_level ~ inv_gamma(0.001, 0.001);
  sigma_drift ~ inv_gamma(0.001, 0.001);
  sigma_irreg ~ inv_gamma(0.001, 0.001);
}
