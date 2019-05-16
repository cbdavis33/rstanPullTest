functions{

 real truncPoisson(int x, real lambda, int lowerBound, int upperBound, real normalizer){

   // vector[upperBound - lowerBound + 1] density;
   real density;

   // for(i in lowerBound:upperBound){
     //   density[i - lowerBound + 1] = poisson_lpmf(i | lambda) - normalizer;
     // }
     density = poisson_lpmf(x | lambda) - normalizer;

     return density;
 }

 int getNuLimit(real lambda, int lowerBound){
   // This function isn't technically correct, but it's close enough. All it's
   // trying to do is get some value, v, for nu that's large enough such that
   // P(nu > v) and P(nu > v|data) ~= 0, so we can marginalize out nu. The smallest
   // this value can be is 50, which is larger than necessary for any value of lambda
   // that would make sense to use. As lambda gets larger, nu gets larger, and at
   // some point, you'd just do regular OLS. If you do set a large value of lambde,
   // then this maximum value will be larger than 50.

   real logProb = 1.0;
   int nuLimit;
   int i = lowerBound;
   real normalizer = poisson_lccdf(lowerBound -  1 | lambda);
   while(logProb > -35){
     logProb = truncPoisson(i, lambda, lowerBound, 50, normalizer);
     i = i + 1;
   }
   nuLimit = max(i, 50);

   return nuLimit;

 }
}
data {

  int<lower=0> N;         // number of data items
  int<lower=0> K;         // number of predictors
  matrix[N, K] x;         // predictor matrix
  vector[N] y;            // outcome vector
  real<lower = 0> lambda; // mean for Poisson in nu ~ Poisson(lambda)

}
transformed data{

  // real logProb = 1.0;
  // int nuLimit = 0;        // first value where log probability < -30. It'll be incremented below
  // while(logProb > -35){
  //   logProb = poisson_lpmf(nuLimit | lambda);
  //   nuLimit += 1;
  // }
  // print("The value of nuLimit for lambda = ", lambda, " is ", nuLimit);
  // nuLimit = nuLimit;
  int lowerBound = 1;
  real normalizer = poisson_lccdf(lowerBound -  1 | lambda);
  int nuLim = getNuLimit(lambda, lowerBound);
  int nuLimit = max(nuLim, 50);

  vector[nuLimit - lowerBound + 1] log_Poisson;
  for(s in lowerBound:nuLimit){
    log_Poisson[s - lowerBound + 1] = truncPoisson(s, lambda, lowerBound, nuLimit, normalizer);
  }

}
parameters {

  real alpha;           // intercept
  vector[K] beta;       // coefficients for predictors
  real<lower=0> sigma;  // error scale

}
transformed parameters{

  vector[nuLimit - lowerBound + 1] lp = log_Poisson;

  for(s in lowerBound:nuLimit){
    lp[s - lowerBound + 1] = lp[s - lowerBound + 1] + student_t_lpdf(y|s, x*beta + alpha, sigma);
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

  int<lower=1,upper=nuLimit> nu;
  nu = categorical_rng(softmax(lp));

}

