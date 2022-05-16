trainperceptron <- function(xin,yd,eta,tol,maxepocas,par){
  
  #yd: tem que ser garado para as xin (concatenado xall), metade 0 e metade 1
  #xin:Entrada Nxn de dados de matriz
  #eta: Peso de atualizacao do passo
  #tol: tolerancia do erro
  #maxepocas: numero maximo de epocas permitido
  #par: par=1 indica que -1 precisa ser acrescido a xin
  
  
  N<-dim(xin)[1] #recebe as linhas
  n<-dim(xin)[2] # recebe as colunas
  
  if (par==1){
    wt<-as.matrix(runif(n+1)-0.5) #inicializa um vetor de n+1 elementos
    xin<-cbind(1,xin)
  }
  else{
    wt<-as.matrix(runif(n)-0.5)
  }
  
  nepocas<-0
  eepoca<-tol+1
  #inicializa vetor erro evec, 
  evec<-matrix(nrow=1,ncol=maxepocas)
  while ((nepocas < maxepocas) && (eepoca>tol))#eepocas erro da epoca e tol tolerancia
  {
    ei2<-0
    #sequencia aleatoria para treinamento
    xseq<-sample(N)
    for (i in 1:N)
    {
      #padrao para sequencia aleatoria
      irand<-xseq[i]
      yhati<-as.double((xin[irand, ] %*% wt) >= 0)
      ei<-yd[irand]-yhati
      dw<-eta * ei * xin[irand,] 
      #atualizacao do peso w
      wt<-wt + dw
      #erro acumulado
      ei2<-ei2+ei*ei
    }
    #numero de epocas
    nepocas<-nepocas+1
    evec[nepocas]<-ei2/N
    #erro por epoca
    eepoca<-evec[nepocas]
  }
  retlist<-list(wt,evec[1:nepocas])
  return(retlist)
  
}