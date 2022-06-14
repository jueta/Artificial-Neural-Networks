rm(list=ls())

#implementacao da secante hiperbolica ao quadrado
sech2<-function(u)
{
return(((2/(exp(u)+exp(-u)))*(2/(exp(u)+exp(-u)))))  
}

#inicializa dados de entrada
x<-matrix(c(0,0,0,1,1,0,1,1),byrow=T, ncol=2)
y<-matrix(c(-1,+1,+1,-1,+1,-1,-1,+1),byrow=T, ncol=2)

#inicializa as entradas
i1<-1
i4<-1
i5<-1
i8<-1

#inicializa os pesos
w61<-runif(1)-0.5
w62<-runif(1)-0.5
w63<-runif(1)-0.5

w72<-runif(1)-0.5
w73<-runif(1)-0.5
w74<-runif(1)-0.5

w95<-runif(1)-0.5
w96<-runif(1)-0.5
w97<-runif(1)-0.5

w106<-runif(1)-0.5
w107<-runif(1)-0.5
w108<-runif(1)-0.5

tol<-0.01
nepocas<-0
eepoca<-tol+1
eta<-0.01
maxepocas<-10000

evec<-matrix(nrow=1,ncol=maxepocas) # vetor onde vamos armazenar o erro

while((nepocas < maxepocas) && (eepoca > tol))
{
  ei2<-0
  iseq<-sample(4)
  
  for(i in (1:4))
  {
    i2<-x[iseq[i],1]
    i3<-x[iseq[i],2]
    
    y9<-y[iseq[i],1]
    y10<-y[iseq[i],2]
    
    u6<-i1*w61+i2*w62+i3*w63
    u7<-i2*w72+i3*w73+i4*w74
    
    i6<-tanh(u6)
    i7<-tanh(u7)
    
    u9<-i5*w95+i6*w96+i7*w97
    u10<-i6*w106+i7*w107+i8*w108
    
    i9<-tanh(u9)
    i10<-tanh(u10)
    
    e9<-y9-i9
    e10<-y10-i10
    
    d9<-e9*sech2(u9)
    d10<-e10*sech2(u10)
    
    dw95<-eta*d9*i5
    dw96<-eta*d9*i6
    dw97<-eta*d9*i7
      
    dw106<-eta*d10*i6
    dw107<-eta*d10*i7
    dw108<-eta*d10*i8
    
    d6<-(d9*w96+d10*w106)*sech2(u6)
    d7<-(d9*w97+d10*w107)*sech2(u7)
    
    dw61<-eta*d6*i1
    dw62<-eta*d6*i2
    dw63<-eta*d6*i3
    
    dw72<-eta*d7*i2
    dw73<-eta*d7*i3
    dw74<-eta*d7*i4
    
    w95<-w95+dw95
    w96<-w96+dw96
    w97<-w97+dw97
    
    w106<-w106+dw106
    w107<-w107+dw107
    w108<-w108+dw108
    
    w61<-w61+dw61
    w62<-w62+dw62
    w63<-w63+dw63
    
    w72<-w72+dw72
    w73<-w73+dw73
    w74<-w74+dw74
    
    ei<-((e9*e9)+(e10*e10))/2
    ei2<-ei2+ei
  }
  nepocas<-nepocas+1
  evec[nepocas]<-ei2/2
  eepoca<-evec[nepocas]
}

plot(evec[1,(1:nepocas)])


