# Save this file as `R/rlm_stan.R`

#' Bayesian robust linear regression with Stan
#'
#' @export
#' @param x Numeric matrix of input values. This matrix should not contain
#' a column of 1's.
#' @param y Numeric vector of output values.
#' @param nu Character, either "fixed" for a fixed value of nu (I'm going to make it 4,
#' since this is a fake package), "continuous", in which case the prior distribution
#' for nu is gamma(shape = 2, rate = 0.5), for an expected value of 4, or "discrete", in
#' which case the prior distribution for nu is a discrete uniform(1, 10). In a real package,
#' I'd give more input options (fixed parameter value, shape, rate, upper bound, ...),
#' but I don't care here
#' @param ... Arguments passed to `rstan::sampling` (e.g. iter, chains).
#' @return An object of class `stanfit` returned by `rstan::sampling`
#' @examples
#' \dontrun{
#' rlmFit <- rlm_stan(x = runif(30, 0, 10), y = 1 + 2*x + rt(30, 4))
#' }
rlm_stan <- function(x, y, nu = c("fixed", "continuous", "discrete"), ...) {
  if(is.vector(x)) x <- matrix(x)
  nu <- match.arg(nu)
  standata <- list(x = x, y = y, K = ncol(x), N = length(y))
  standata$nu <- switch(nu,
                        fixed = 4,
                        continuous = 1,
                        discrete = 1)
  if(nu == "fixed") {
    out <- rstan::sampling(stanmodels$rlmNuFixed, data = standata, ...)
  }else if(nu == "continuous"){
    out <- rstan::sampling(stanmodels$rlmNuEstCont, data = standata, ...)
  }else{
    out <- rstan::sampling(stanmodels$rlmNuEstDisc, data = standata, ...)
  }
  return(out)
}
