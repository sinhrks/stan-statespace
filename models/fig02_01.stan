data {
  int<lower=1> n;
  vector[n] y;
}
parameters {
  # 確定的レベル
  real mu;
  # 撹乱項
  real<lower=0> sigma;
}
model {
  y ~ normal(mu, sigma);
}
