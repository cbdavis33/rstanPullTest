rm(list = ls())
cat("\014")

x <- runif(30, 0, 10)
y <- 1 + 2*x + rt(30, 4)

plot(x, y)


## print/show/summary methods need written
rlmFitFixed <- rlm_stan(x, y, family = "Student's t", nuDist = "fixed", fixedNu = -4,
                        iter = 1500, chains = 4, cores = 4)
print(rlmFitFixed)

rlmFitCont <- rlm_stan(x, y, family = "Student's t", nuDist = "gamma", shape = 2, rate = .5,
                       iter = 1500, chains = 4, cores = 4)
print(rlmFitCont)

rlmFitDisc <- rlm_stan(x, y, family = "Student's t", nuDist = "uniform", nuMax = 30,
                       iter = 1500, chains = 4, cores = 4)
print(rlmFitDisc)

rlmFitDiscP <- rlm_stan(x, y, family = "Student's t", nuDist = "poisson", lambda = 4,
                        iter = 1500, chains = 4, cores = 4)
print(rlmFitDiscP)


rlmFitFixed <- rlm_stan(x, y, family = "Student's t", nuDist = "poisson", lambda = 4,
                        iter = 1500, chains = 4, cores = 4)
print(rlmFitFixed)
