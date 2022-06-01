treinaRBF<-function(xin, yin, p) {
####### Fun ̧ca ̃o radial Gaussiana 
	pdfnvar<-function(x,m,K,n)
	{
		if(n==1) # nolint
		{
			r<-sqrt(as.numeric(K))
			px<-(1/(sqrt(2*pi*r*r)))*exp(-0.5 * ((x-m)/(r))^2)
		}
		else px<-((1/(sqrt((2*pi)^n*(det(K)))))*exp(-0.5*(t(x-m) %*% (solve(K)) %*% (x-m))))
		return (px)
	}
	##########################
	N<-dim(xin)[1] # n u ́ m e r o d e a m o s t r a s
	n<-dim(xin)[2] # dimens ̃ao de entrada (deve ser maior que 1)
	xin<-as.matrix(xin) # garante que xin seja matriz
	yin<-as.matrix(yin) # garante que yin seja matriz
	xclust<-kmeans(xin ,p)

	# Armazena vetores de centros das fun ̧c ̃oes .
	m<-as.matrix(xclust$centers) # nolintpr
	covlist<-list()

	# Estima matrizes de covariância para todos os centros .
	for ( i in 1:p)
	{
		ici<-which(xclust$cluster == i)
		xci<-xin[ici,] 
		if (n ==1)
			covi<-var(xci)
		else covi<-cov(xci)
		covlist[[i]]<-covi
	}

	H<-matrix(nrow = N,ncol = p)	

	# Calcula matriz H
	for (j in 1:N)
	{
		for ( i in 1:p)
		{
			mi<-m[i,]
			covi<-covlist[i] 
			covi<-matrix(unlist(covlist[i]),ncol=n,byrow =T) + 0.001*diag(n)
			H[j,i]<-pdfnvar(xin[j,] ,mi, covi, n)
		} 
	}
	Haug<-cbind (1 ,H)
	W<-( solve( t(Haug) %*% Haug) %*% t (Haug) ) %*% yin
	return(list(m,covlist,W,H))
}



YRBF<-function(xin, modRBF)
{
	####### Fun ̧c ̃ao radial Gaussiana
	pdfnvar<-function(x,m,K,n)
	{
		if (n==1) {
			r<-sqrt(as.numeric(K))
			px<-(1/(sqrt(2*pi*r*r)))*exp(-0.5*((x-m)/(r))^2)
		}
		else px<-((1/(sqrt((2*pi)^n*(det(K)))))*exp(-0.5*(t(x-m) %*% (solve(K)) %*% (x-m))))
		return (px)
	}

	##########################
	N<-dim(xin)[1] # numero de amostras
	n<-dim(xin)[2] # dimens ̃ao de entrada (deve ser maior que 1)
	m<-as.matrix(modRBF[[1]])
	covlist<-modRBF[[2]]
	p<-length(covlist) # Nu ́mero de fun ̧co ̃es radiais 
	W<-modRBF[[3]]

	xin<-as.matrix(xin) # garante que xin seja matriz
	# yin<-as.matrix(yin) # garante que yin seja matriz
	
	H<-matrix(nrow = N,ncol = p)
	# Calcula matriz H
	for (j in 1:N) {
		for ( i in 1:p) {
			mi<-m[i,]
			covi<-covlist[i]
			covi<-matrix(unlist(covlist[i]),ncol=n,byrow =T) +0.001*diag(n)
			H[j,i]<-pdfnvar(xin[j,], mi, covi, n) 
		}
	}
	Haug<-cbind(1,H)
	Yhat<-Haug %*% W

	return (Yhat)
}