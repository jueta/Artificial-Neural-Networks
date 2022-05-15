rm(list = ls())

## dados do tabuleiro
nc <- 30
xref <- matrix(rnorm(nc*2, mean = 0, sd = 0.2), ncol=2)

# clusters
clust1 <- xref + matrix(c(2,2),byrow=T, ncol = 2, nrow = nc)
clust2 <- xref + matrix(c(4,2),byrow=T, ncol = 2, nrow = nc)
clust3 <- xref + matrix(c(3,2),byrow=T, ncol = 2, nrow = nc)
clust4 <- xref + matrix(c(1,2),byrow=T, ncol = 2, nrow = nc)

clustall <- rbind(clust1, clust2, clust3, clust4)
plot(clustall[,1], clustall[,2])

#define k
k <- 4

# escolhe k centros
iseq <-sample(nc*4)
centros <- clustall[iseq[1:k],]

## atribui centros
for (j in 1:10)
{
  auxmax1 <- matrix(centros[1,], byrow=T, ncol = 2, nrow = 4*nc)
  auxmax2 <- matrix(centros[2,], byrow=T, ncol = 2, nrow = 4*nc)
  auxmax3 <- matrix(centros[3,], byrow=T, ncol = 2, nrow = 4*nc)
  auxmax4 <- matrix(centros[4,], byrow=T, ncol = 2, nrow = 4*nc)
  
  D1 <- rowSums((auxmax1 - clustall)^2)
  D2 <- rowSums((auxmax2 - clustall)^2)
  D3 <- rowSums((auxmax3 - clustall)^2)
  D4 <- rowSums((auxmax4 - clustall)^2)
  
  Dall <- cbind(D1, D2, D3, D4)
  
  ci <- apply(Dall, 1, which.min)
  
  centros[1,] <- mean(clustall[wich(ci == 1), ])
  centros[2,] <- mean(clustall[wich(ci == 1), ])
  centros[3,] <- mean(clustall[wich(ci == 1), ])
  centros[4,] <- mean(clustall[wich(ci == 1), ])
}


plot(centros[,1], clustall[,2], xlim = c(0,6), ylim = c(0,3))
par(new=T)
plot(clustall[wich(ci == 1), 1], clustall[which[ci == 1],2], col='blue', xlim= c(0,6), ylim = )
par(new=T)
plot(clustall[wich(ci == 1), 1], clustall[which[ci == 1],2], col='blue', xlim= c(0,6), ylim = )
par(new=T)
plot(clustall[wich(ci == 1), 1], clustall[which[ci == 1],2], col='blue', xlim= c(0,6), ylim = )

