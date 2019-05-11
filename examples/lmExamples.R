rm(list = ls())
cat("\014")

x <- runif(30, 0, 10)
y <- 1 + 2*x + rnorm(30)

lmFit <- lm_stan(x, y, iter = 1000)
print(lmFit)
