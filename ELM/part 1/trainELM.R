library('corpcor')

treinaELM <- function(xin, yin, p, par){
  n <- dim(xin)[2]
  
  if(par == 1) {
    xin <- cbind(1, xin)
    Z <- replicate(p, runif((n+1), -0.5, 0.5))
  }
  else Z <- replicate(p, runif(n, -0.5, 0.5))
  
  H <- tanh(xin %*% Z)
  
  W <- pseudoinverse(H) %*% yin
  
  return(list(W,H,Z))
}


YELM <- function(xin, Z, W, par) {
  n <- dim(xin)[2]
  
  if(par == 1) {
    xin <- cbind(1, xin)
  }
  
  H <- tanh(xin %*% Z)
  
  Yhat <- sign(H %*% W)
  
  return(Yhat)
}

plotContourAndDots <- function(xin, classes, nNeuronios) {
  cores <- rainbow(2)
  
  plot(xin[,1], xin[,2], col = cores[classes + 1], xlim = c(-2, 2), ylim = c(-2, 2))
  
  retlist <- treinaELM(xin, classes, nNeuronios, 1)
  
  W <- retlist[[1]]
  H <- retlist[[2]]
  Z <- retlist[[3]]
  
  Yhat_train <- YELM(xin, Z, W, 1)
  print((classes - Yhat_train)^2)
  
  e_train <- sum((classes - Yhat_train)^2)
  print(e_train)
  
  seqx1x2 <- seq(-2, 2, 0.1)
  lseq <- length(seqx1x2)
  MZ <- matrix(0, nrow = lseq, ncol = lseq)
  cr <- 0
  
  for (i in 1:lseq) {
    for(j in 1:lseq) {
      cr <- cr + 1
      x1 <- seqx1x2[i]
      x2 <- seqx1x2[j]
      x1x2 <- matrix((cbind(x1, x2)), nrow = 1)
      MZ[i, j] <- YELM(x1x2, Z, W, 1)
    }
  }
  
  par(new = TRUE)
  contour(seqx1x2, seqx1x2, MZ, nlevels = 1, xlim = c(-2, 2), ylim = c(-2, 2))
}
