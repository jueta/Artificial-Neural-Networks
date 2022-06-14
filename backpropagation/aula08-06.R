rm(list=ls())

library(RSNNS)

N<-200
x<-runif(N, 0, 2*pi)
y<-sin(x)+rnorm(N, 0 ,0.1)

rede<- mlp(x,y, size=c(2, 3, 5), maxit=2000, initFunc="Randomize_weights",
  initiFuncParams=c(-0.3, 0.3), learnFunc="Std_Backpropagation",
  learnFuncParams=c(0.1,0.1), updateFunc="Topological_Order",
  updateFuncParams=c(0), hiddenActFunc="Act_Logistic",
  shufflePatterns=TRUE, linOut=TRUE)

xt<-seq(0,2*pi, 0.01)
yseno<-sin(xt)
yhat<-predict(rede, as.matrix(xt))

plot(x,y,xlim=c(0,2*pi),ylin=c(-1,1))
par(new=T)
plot(xt,yhat,xlim=c(0,2*pi),ylin=c(-1,1))