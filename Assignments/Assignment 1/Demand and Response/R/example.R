# Installation of packages
install.packages('lpSolve')
#install.packages('lpSolveAPI')

# Loading of packages
library(lpSolve)
#library(lpSolveAPI)

p <- runif(4) #random function to generate price in each hour
f.obj <- c(p[1], p[2], p[3], p[4], p[1], p[2], p[3], p[4])
c1 <- c(1, 1, 1, 1, 0, 0, 0, 0)
c2 <- c(0, 0, 0, 0, 1, 1, 1, 1)
c3 <- c(1, 0, 0, 0, 0, 0, 0, 0)
c4 <- c(0, 1, 0, 0, 0, 0, 0, 0)
c5 <- c(0, 0, 1, 0, 0, 0, 0, 0)
c6 <- c(0, 0, 0, 1, 0, 0, 0, 0)
c7 <- c(0, 0, 0, 0, 1, 0, 0, 0)
c8 <- c(0, 0, 0, 0, 0, 1, 0, 0)
c9 <- c(0, 0, 0, 0, 0, 0, 1, 0)
c10 <- c(0, 0, 0, 0, 0, 0, 0, 1)
f.con <- matrix (c(c1, c2, c3, c4, c5, c6, c7, c8, c9, c10), nrow = 10, byrow=TRUE)
f.dir <- c("=", "=", "<=", "<=", "<=", "<=", "<=", "<=", "<=", "<=")
f.rhs <- c(9.9, 5.0, 3.0, 3.0, 3.0, 3.0, 1.5, 1.5, 1.5, 1.5)


lp("min", f.obj, f.con, f.dir, f.rhs)
