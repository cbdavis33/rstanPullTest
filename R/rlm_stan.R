# Save this file as `R/rlm_stan.R`

#' Bayesian robust linear regression with Stan
#'
#' @export
#' @param x Numeric matrix of input values. This matrix should not contain
#' a column of 1's.
#' @param y Numeric vector of output values.
#' @param family Character. Right now, only "Student's t is supported.
#' @param nuDist Character, either "fixed" for a fixed value of nu, "continuous", in which case
#' the prior distribution for nu is a gamma distribution, "uniform", in which case the prior
#' distribution for nu is a discrete uniform, or "poisson", in which case the prior distribution
#' for nu is a Poisson distribution truncated at 1 (no 0 values for nu).
#' @param ... Arguments passed to `rstan::sampling` (e.g. iter, chains).
#' @return An object of class `stanfit` returned by `rstan::sampling`
#' @examples
#' \dontrun{
#' x <- runif(30, 0, 10)
#' y <- 1 + 2*x + rt(30, 4)
#' rlmFitFixed <- rlm_stan(x, y, family = "Student's t", nuDist = "fixed", fixedNu = 4)
#' rlmFitCont <- rlm_stan(x, y, family = "Student's t", nuDist = "gamma", shape = 2, rate = .5)
#' rlmFitDisc <- rlm_stan(x, y, family = "Student's t", nuDist = "uniform", nuMax = 30)
#' rlmFitDiscP <- rlm_stan(x, y, family = "Student's t", nuDist = "poisson", lambda = 4)
#' }
rlm_stan <- function(x, y, family = "Student's t", nuDist = c("fixed", "gamma", "uniform", "poisson"), ...,
                     fixedNu, shape, rate, scale, nuMax, lambda) {
  if(family != "Student's t") stop("The only error distribution for 'rlm_stan' is Student's t-distribution.\n",
                                   "Please enter 'Student's t' for the family argument.\n",
                                   "If you want a Cauchy distribution, enter 'fixed' for the nuDist argument,
                                   and set the fixed value of nu ('fixedNu') to be 1.")
  if(is.vector(x)) x <- matrix(x)

  data <- list(x = x, y = y)

  nuDist <- match.arg(nuDist)
  standata <- list(x = x, y = y, K = ncol(x), N = length(y))

  if(nuDist == "fixed") {
    if(!missing(fixedNu)){
      stopifnot(length(fixedNu) == 1, is.numeric(fixedNu), (fixedNu > 0))
      standata$nu <- fixedNu
    }else{
      stop("You have chosen to fix the error degrees of freedom.\n",
           "You must enter a value for the argument 'fixedNu'.")
    }

    out <- rstan::sampling(stanmodels$rlmNuFixed, data = standata, ...)
    nuInfo <- list(distribution = "fixed",
                   fixedNu = fixedNu)
    toReturn <- new("rlmfit",
                    data = data,
                    family = "Student's-t",
                    nuInfo = nuInfo,
                    samples = out@sim$samples)
  }else if(nuDist == "gamma"){
    if(!missing(shape)){
      standata$shape <- shape
    }else{
      stop("You have chosen the gamma distribution for the error degrees of freedom.\n",
           "You must enter a value for the argument 'shape'.")
    }

    if(!missing(rate) && !missing(scale)) stop("Please specify 'rate' or 'scale' but not both.")
    else if(!missing(rate) && missing(scale)) standata$rate <- rate
    else if(missing(rate) && !missing(scale)) standata$rate <- 1/scale
    else stop("Please specify 'rate' or 'scale' but not both.")

    out <- rstan::sampling(stanmodels$rlmNuEstCont, data = standata, ...)
    nuInfo <- list(distribution = "gamma",
                   shape = shape,
                   rate = standata$rate)
    toReturn <- new("rlmfit",
                    data = data,
                    family = "Student's-t",
                    nuInfo = nuInfo,
                    samples = out@sim$samples)
  }else if(nuDist == "uniform"){
    if(!missing(nuMax)){
      standata$nuMax <- nuMax
    }else{
      stop("You have chosen the discrete uniform distribution for the error degrees of freedom.\n",
           "You must enter a value for the argument 'nuMax'.")
    }

    out <- rstan::sampling(stanmodels$rlmNuEstDisc, data = standata, ...)
    nuInfo <- list(distribution = "uniform",
                   nuMax = standata$nuMax)
    toReturn <- new("rlmfit",
                    data = data,
                    family = "Student's-t",
                    nuInfo = nuInfo,
                    samples = out@sim$samples)
  }else{
    if(!missing(lambda)){
      standata$lambda <- lambda
    }else{
      stop("You have chosen the Poisson distribution (truncated below at 1) for the error degrees of freedom.\n",
           "You must enter a value for the argument 'lambda', which is the mean of the Poisson distribution.")
    }

    out <- rstan::sampling(stanmodels$rlmNuEstDiscP, data = standata, ...)
    nuInfo <- list(distribution = "truncated Poisson",
                   lambda = standata$lambda)
    toReturn <- new("rlmfit",
                    data = data,
                    family = "Student's-t",
                    nuInfo = nuInfo,
                    samples = out@sim$samples)
  }
  return(toReturn)
}
