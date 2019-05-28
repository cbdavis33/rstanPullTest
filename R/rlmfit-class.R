setMethod("show", "rlmfit",
          function(object) {
            sfObject <- stanfitForMethods(object)
            rstan::show(object = sfObject)
          })

# setMethod("summary", "rlmfit",
#           function(object, pars,
#                    probs = c(0.025, 0.25, 0.50, 0.75, 0.975), use_cache = TRUE, ...){
#             rstan::summary.stanfit(object = stanfitForMethods(object), pars,
#                            probs, use_cache)
#           })

#' Summary method for rlmfit objects
#'
#' Summaries of parameter estimates and MCMC convergence diagnostics
#' (Monte Carlo error, effective sample size, Rhat).
#'
#' @export
#' @method summary rlmfit
summary.rlmfit <- function(object, pars,
                           probs = c(0.025, 0.25, 0.50, 0.75, 0.975),
                           use_cache = TRUE, ...){
  rstan::summary(object = stanfitForMethods(object),
                 pars, probs, use_cache)
}


#' Print method for rlmfit objects
#'
#' Print a summary of parameter estimates and MCMC convergence diagnostics
#' (Monte Carlo error, effective sample size, Rhat).
#'
#' @export
#' @method print rlmfit
print.rlmfit <- function(object, pars,
                         probs = c(0.025, 0.25, 0.50, 0.75, 0.975),
                         digits_summary = 2, include = TRUE, ...){
  print(x = stanfitForMethods(object), pars,
        probs, digits_summary, include, ...)
}
