data {

  int<lower=0> N;             // number of data items
  int<lower=0> K;             // number of predictors
  matrix[N, K] x;             // predictor matrix
  vector[N] y;                // outcome vector
  int<lower = 1> nuMax;       // maximum value of nu ~ Discrete Unif(1, nuMax)

}
transformed data{

  real log_unif = -log(nuMax);

}
parameters {

  real alpha;           // intercept
  vector[K] beta;       // coefficients for predictors
  real<lower=0> sigma;  // error scale

}
transformed parameters{

  vector[nuMax] lp = rep_vector(log_unif, nuMax);

  for(s in 1:nuMax){
    lp[s] = lp[s] + student_t_lpdf(y|s, x*beta + alpha, sigma);
  }

}
model {

  alpha ~ normal(0, 10);
  beta ~ normal(0, 10);
  sigma ~ cauchy(0, 5);

  target += log_sum_exp(lp);
  // y ~ student_t(nu, x*beta + alpha, sigma);  // likelihood

}
generated quantities {

  int<lower=1,upper=nuMax> nu;
  nu = categorical_rng(softmax(lp));

}

