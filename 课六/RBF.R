rm(list=ls())
library('plot3D')
packageurl <- "https://cran.r-project.org/doc/manuals/r-patched/R-admin.html#Installing-packages"
install.packages(packageurl, contriburl=NULL, type="source")

pdfnvar<-function(x,m,K,n) ((1/(sqrt((2*pi)^n*(det(K)))))*exp(-0.5*(t(x-m) %*% (solve(K)) %*% (x-m))))

s1<-1
s2<-1
ro<-0.8

m1<-matrix(c(3,3),byrow = T, ncol=1)
K1<-matrix(c(s1^2,ro*s1*s2,ro*s2*s1,s2^2),byrow = T, ncol=2)

n<-2

seqi<-seq(0,6,0.1)
seqj<-seq(0,6,0.1)
M1<-matrix(1,nrow=length(seqi),ncol=length(seqj))

ci<-0
for (i in seqi)
{
  ci<-ci+1
  cj<-0
  for (j in seqj)
  {
    cj<-cj+1
    x<-matrix(c(i,j),byrow = T, ncol=1)
    M1[ci,cj]<-pdfnvar(x,m1,K1,n)
  }
}

contour(seqi,seqj,M1)
persp3D(seqi,seqj,M1)