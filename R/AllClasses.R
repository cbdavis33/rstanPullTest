## Contains all classes for this dummy package
setClass(Class = "lmfit",
         slots = c(data = "list",
                   model_name = "character",   # This should always be "normal" for object of class lmfit
                   model_pars = "character",
                   par_dims = "list",
                   mode = "integer",
                   sim = "list",
                   inits = "list",
                   stan_args = "list",
                   date = "character",
                   .MISC = "environment"))

setClass(Class = "rlmfit",
         slots = c(nuInfo = "list"), # The list contains elements that describe the distribution for the error df
         contains = "lmfit")

