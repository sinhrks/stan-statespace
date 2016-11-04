data {
  int<lower=1> n;
  vector[n] y;
}
parameters {
  # 確率的レベル
  vector[n] mu;
  # 確率的傾き
  vector[n-1] v;

  # 傾き撹乱項 < 観測撹乱項 < レベル撹乱項
  # sigma_drift < irreg < level
  positive_ordered[3] sigma;
}
transformed parameters {
  vector[n] yhat;
  yhat = mu;
}
model {
  # 式 3.1
  v[1] ~ normal(0, sigma[1]);
  for(t in 2:n-1)
    v[t] ~ normal(v[t-1], sigma[1]);

  mu[1] ~ normal(y[1], sigma[3]);
  for(t in 2:n)
    mu[t] ~ normal(mu[t-1] + v[t-1], sigma[3]);

  y ~ normal(yhat, sigma[2]);

  sigma ~ student_t(4, 0, 1);
}
