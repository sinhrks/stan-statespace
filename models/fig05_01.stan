data {
  int<lower=1> n;
  vector[n] y;
  vector[n] x;
}
parameters {
  # 確定的レベル
  real mu;
  # 確定的回帰係数
  real beta;
  # 観測撹乱項
  real<lower=0> sigma_irreg;
}
transformed parameters {
  vector[n] yhat;
  yhat = mu + beta * x;
}
model {
  # 式 5.3
  y ~ normal(yhat, sigma_irreg);
}
