data {
  int<lower=1> n;
  vector[n] y;
  vector[n] x;
}
parameters {
  # 確率的レベル
  vector<lower=mean(y)-3*sd(y), upper=mean(y)+3*sd(y)>[n] mu;

  # 確定的回帰係数
  real<lower=-0.5, upper=0.5> beta;

  # 観測撹乱項 < レベル撹乱項
  positive_ordered[2] sigma;
}
transformed parameters {
  vector[n] yhat;
  yhat = mu + beta * x;
}
model {
  # 式 5.2
  mu[1] ~ normal(y[1], sigma[2]);
  for (t in 2:n)
    mu[t] ~ normal(mu[t-1], sigma[2]);

  y ~ normal(yhat, sigma[1]);

  sigma ~ student_t(4, 0, 1);
  beta ~ normal(0, 2);
}
