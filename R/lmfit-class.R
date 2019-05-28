setMethod("show", "lmfit",
          function(object) {
            sfObject <- stanfitForMethods(object)
            rstan::show(object = sfObject)
          })

# setGeneric(name = "summary",
#            def = function(object, ...) { standardGeneric("summary")})
#
# setMethod("summary", "lmfit",
#           function(object, pars,
#                    probs = c(0.025, 0.25, 0.50, 0.75, 0.975), use_cache = FALSE, ...){
#             rstan::summary(object = stanfitForMethods(object), pars,
#                            probs, use_cache)
#           })

#' Summary method for lmfit objects
#'
#' Summaries of parameter estimates and MCMC convergence diagnostics
#' (Monte Carlo error, effective sample size, Rhat).
#'
#' @export
#' @method summary lmfit
summary.lmfit <- function(object, pars,
                          probs = c(0.025, 0.25, 0.50, 0.75, 0.975),
                          use_cache = TRUE, ...){
  rstan::summary(object = stanfitForMethods(object),
                 pars, probs, use_cache)
}

#' Print method for lmfit objects
#'
#' Print a summary of parameter estimates and MCMC convergence diagnostics
#' (Monte Carlo error, effective sample size, Rhat).
#'
#' @export
#' @method print lmfit
print.lmfit <- function(object, pars,
                        probs = c(0.025, 0.25, 0.50, 0.75, 0.975),
                        digits_summary = 2, include = TRUE, ...){
  print(x = stanfitForMethods(object), pars,
               probs, digits_summary, include, ...)
}

#' Predict method for lmfit objects
#'
#' @description Predicted values based on an lmfit object. Can also
#' return confidence intervals and prediction intervals.
#'
#' @param object Object of class \code{lmfit}
#' @param newdata Matrix of predictors
#'
#' @export
#' @method predict lmfit
predict.lmfit <- function(object, newdata = NULL,
                          interval = c("prediction", "confidence"),
                          summary = TRUE, ...,
                          probs = c(0.025, 0.25, 0.50, 0.75, 0.975)){
  ## 1) check newdata for NAs and dimension
  ## 2) put lmfit object into stanfit object
  ## 3) as.matrix(stanfit object)
  ## 4) get linear_predictor alpha + X*Beta
  ## 5) if interval = "prediction", add error
  ## 6) if summary == TRUE, create summary table (mean, probs for each prediction point)
  ##       summary == FALSE, return matrix containing all nmcmc draws for each pred point

  checkNewData(object, newdata)
  sfObject <- stanfitForMethods(object)

}

