rm(list = ls())
cat("\014")

x <- runif(30, 0, 10)
y <- 1 + 2*x + rt(30, 4)

rlmFitF <- rlm_stan(x, y, nu = "fixed", iter = 1000)
print(rlmFitF)

rlmFitC <- rlm_stan(x, y, nu = "continuous", iter = 1000)
print(rlmFitC)

rlmFitD <- rlm_stan(x, y, nu = "discrete", iter = 1000)
print(rlmFitD)
