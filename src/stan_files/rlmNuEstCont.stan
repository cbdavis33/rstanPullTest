data {

  int<lower=0> N;     // number of data items
  int<lower=0> K;     // number of predictors
  matrix[N, K] x;     // predictor matrix
  vector[N] y;        // outcome vector

}
parameters {

  real alpha;           // intercept
  vector[K] beta;       // coefficients for predictors
  real<lower=0> sigma;  // error scale
  real<lower = 0> nu;   // degrees of freedom for error ~ student-t

}
model {

  beta ~ normal(0, 10);
  sigma ~ cauchy(0, 5);
  nu ~ gamma(2, 0.5);
  y ~ student_t(nu, x*beta + alpha, sigma);  // likelihood

}

