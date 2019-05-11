// Save this file as src/stan_files/lm.stan
data {
  int<lower=1> N; // number of data items
  int<lower=0> K; // number of predictors
  matrix[N, K] x; // predictor matrix (no column of 1's)
  vector[N] y;    // outcome vector
}
parameters {
  real alpha;
  vector[K] beta;
  real<lower=0> sigma;
}
model {
  // ... priors, etc.

  y ~ normal(alpha + x * beta, sigma);
}


