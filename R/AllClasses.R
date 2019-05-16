## Contains all classes for this dummy package
setClass(Class = "lmfit",
         slots = c(data = "list",
                   family = "character",   # This should always be "normal" for object of class lmfit
                   samples = "list"))

setClass(Class = "rlmfit",
         slots = c(nuInfo = "list"), # The list contains elements that describe the distribution for the error df
         contains = "lmfit")
