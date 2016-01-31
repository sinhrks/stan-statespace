data {
  int<lower=1> n;
  vector[n] y;
}
parameters {
  # 確定的レベル
  real mu;
  # 確定的季節項
  vector[11] seas;
  # 観測撹乱項
  real<lower=0> sigma_irreg;
}
transformed parameters {
  vector[n] seasonal;
  vector[n] yhat;
  for(t in 1:11)
    seasonal[t] = seas[t];

  for(t in 12:n)
    seasonal[t] = - sum(seasonal[t-11:t-1]);

  yhat = mu + seasonal;
}
model {
  # 式 4.1
  y ~ normal(yhat, sigma_irreg);
}
