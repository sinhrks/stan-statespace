data {
  int<lower=1> n;
  vector[n] y;
}
parameters {
  # 確定的レベル
  real mu;
  # 確率的傾き
  vector[n-1] v;
  # 傾き撹乱項
  real<lower=0> sigma_drift;
  # 観測撹乱項
  real<lower=0> sigma_irreg;
}
transformed parameters {
  vector[n] yhat;
  yhat[1] <- mu;
  for(t in 2:n) {
    yhat[t] <- yhat[t-1] + v[t-1];
  }
}
model {
  # 式 3.1
  for(t in 2:n-1)
    v[t] ~ normal(v[t-1], sigma_drift);
  for(t in 1:n)
    y[t] ~ normal(yhat[t], sigma_irreg);
}
