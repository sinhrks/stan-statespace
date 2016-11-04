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
  for(t in 1:11) {
    seasonal[t] <- seas[t];
  }
  for(t in 12:n) {
    seasonal[t] <- - seasonal[t-11] - seasonal[t-10] - seasonal[t-9] - seasonal[t-8] - seasonal[t-7] - seasonal[t-6] - seasonal[t-5] - seasonal[t-4] - seasonal[t-3] - seasonal[t-2] - seasonal[t-1];
  }
  for(t in 1:n) {
    yhat[t] <- mu + seasonal[t];
  }
}
model {
  # 式 4.1
  for(t in 1:n)
    y[t] ~ normal(yhat[t], sigma_irreg);
}
