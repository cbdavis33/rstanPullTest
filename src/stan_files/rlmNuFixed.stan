// Save this file as src/stan_files/lm.stan
data {
  int<lower=1> N;    // number of data items
  int<lower=0> K;    // number of predictors
  matrix[N, K] x;    // predictor matrix (no column of 1's)
  vector[N] y;       // outcome vector
  real<lower=1> nu;  // degrees of freedom for errors ~ student's t(nu)
}
parameters {
  real alpha;
  vector[K] beta;
  real<lower=0> sigma;
}
model {
  // ... priors, etc.

  y ~ student_t(nu, alpha + x * beta, sigma);
}


