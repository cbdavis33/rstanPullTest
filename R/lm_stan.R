# Save this file as `R/lm_stan.R`

#' Bayesian linear regression with Stan
#'
#' @export
#' @param x Numeric matrix of input values. This matrix should not contain
#' a column of 1's.
#' @param y Numeric vector of output values.
#' @param ... Arguments passed to `rstan::sampling` (e.g. iter, chains).
#' @return An object of class `stanfit` returned by `rstan::sampling`
#' @examples
#' \dontrun{
#' x <- runif(30, 0, 10)
#' y <- 1 + 2*x + rnorm(30)
#' lmFit <- lm_stan(x, y)
#' }
#'
lm_stan <- function(x, y, ...) {
  if(is.vector(x)) x <- matrix(x)
  standata <- list(x = x, y = y, K = ncol(x), N = length(y))
  out <- rstan::sampling(stanmodels$lm, data = standata, ...)
  toReturn <- new("lmfit",
                  data = list(x = x, y = y),
                  family = "normal",
                  samples = out@sim$samples)
  return(toReturn)
}
