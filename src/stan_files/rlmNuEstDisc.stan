data {

  int<lower=0> N;     // number of data items
  int<lower=0> K;     // number of predictors
  matrix[N, K] x;     // predictor matrix
  vector[N] y;        // outcome vector

}
transformed data{

  int<lower = 1> maxNu = 10;    // maximum value of nu, degrees of freedom
  real log_unif = -log(maxNu);

}
parameters {

  real alpha;           // intercept
  vector[K] beta;       // coefficients for predictors
  real<lower=0> sigma;  // error scale

}
transformed parameters{

  vector[maxNu] lp =rep_vector(log_unif, maxNu);

  for(s in 1:maxNu){
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

  int<lower=1,upper=maxNu> nu;
  nu = categorical_rng(softmax(lp));

}

