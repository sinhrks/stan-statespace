data {
  int<lower=1> n;
  real y[n];
}
parameters {
  # 係数
  real slope;
  # 切片
  real intercept;
  # 撹乱項
  real<lower=0> sigma;
}
model {
  for (t in 1:n){
    y[t] ~ normal(intercept + slope * t, sigma);
  }
}
