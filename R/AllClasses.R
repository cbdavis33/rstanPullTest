## Contains all classes for this dummy package
setClass(Class = "lmfit",
         slots = c(family = "character",   # This should always be "normal" for object of class lmfit
                   samples = "list"))

setClass(Class = "rlmfit",
         slots = c(nuDist = "character"), # This should be one of "fixed", "continuous", or "discrete"
         contains = "lmfit")
