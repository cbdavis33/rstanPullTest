stanfitForMethods <- function(object) {
  new("stanfit",
      model_name = object@model_name,
      model_pars = object@model_pars,
      par_dims = object@par_dims,
      mode = object@mode,
      sim = object@sim,
      inits = object@inits,
      stan_args = object@stan_args,
      # stanmodel = object@stanmodel,
      date = object@date,
      .MISC = object@.MISC)
}

checkNewData <- function(object, newdata){

  if(is.null(newdata)) return(NULL)
  if(!is.matrix(newdata)){
    stop("If 'newdata' is specified it must be a matrix.", call. = FALSE)
  }
  if (any(is.na(newdata))){
    stop("NAs are not allowed in 'newdata'.", call. = FALSE)
  }
  if(ncol(object@data$x) != ncol(newdata)){
    stop("'newdata' must have the same number of columns as the orginal data, x.",
         call. = FALSE)
  }

}


validate_newdata <- function(x) {
  if (is.null(x)) {
    return(NULL)
  }
  if (!is.data.frame(x)) {
    stop("If 'newdata' is specified it must be a data frame.", call. = FALSE)
  }
  if (any(is.na(x))) {
    stop("NAs are not allowed in 'newdata'.", call. = FALSE)
  }

  x <- as.data.frame(x)
  drop_redundant_dims(x)
}
