data {
  int<lower=1> n;
  vector[n] y;
  vector[n] x;
  vector[n] w;
}
parameters {
  # 確率的レベル
  vector<lower=mean(y)-3*sd(y), upper=mean(y)+3*sd(y)>[n] mu;
  # 確率的季節項
  vector[n] seasonal;
  # 確定的回帰係数
  real beta;
  # 確定的係数
  real lambda;

  # 季節性撹乱項 < レベル撹乱項 < 観測撹乱項
  positive_ordered[3] sigma;
}
transformed parameters {
  vector[n] yhat;
  yhat = mu + beta * x + lambda * w;
}
model {
  # 式 7.1

  # frequency = 12
  for(t in 12:n)
    seasonal[t] ~ normal(- sum(seasonal[t-11:t-1]), sigma[1]);

  for(t in 2:n)
    mu[t] ~ normal(mu[t-1], sigma[2]);

  y ~ normal(yhat + seasonal, sigma[3]);

  # beta ~ normal(0, 2);
  # lambda ~ normal(mean(y) / mean(x), 2);
  sigma ~ student_t(4, 0, 1);
}
