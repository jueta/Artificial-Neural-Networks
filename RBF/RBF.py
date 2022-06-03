import numpy as np
from sklearn.cluster import KMeans
import pandas as pd

def trainRBF(xin, yin, p):

    # Função Radial Gaussiana
    def pdfnvar(x, m, K, n):
        if(n == 1):
            r = np.sqrt(int(K))
            px = (1/(np.sqrt(2*np.pi*r*r)))*np.exp(-0.5 * ((x-m)/(r))**2)
        else:
            px = ((1/np.sqrt((2*np.pi)**n * (np.linalg.det(K))))) * np.exp(-0.5*((x-m) @ (np.linalg.inv(K) @ np.transpose(x-m))))
        return px

    nSamples = xin.shape[0]     # Numero de amostras.
    nDimension = xin.shape[1]     # Dimensao de entrada.  

    xin = np.matrix(xin)  # garante que xin seja matriz
    yin = np.matrix(yin)  # garante que yin seja matriz

    #clusteriza os dados de entrada por meio do algorítmo K-médias
    xclust = KMeans(n_clusters=p).fit(xin)

    # Armazena vetores de centros das funções
    m = np.matrix(xclust.cluster_centers_)
    covlist = []
    
    # Estima matrizes de covarância para todos os centros
    for i in range(p):
        ici = np.where(xclust.labels_ == i)
        xci = xin[ici,]
        if nDimension == 1:
            covi = np.var(xci)
        else:
            covi = np.cov(xci[0], rowvar=False)
        covlist.append(covi)

    H =  np.zeros((nSamples, p))

    #calcula matriz H
    for j in range(nSamples):
        for i in range(p):
            mi = m[i,]
            covi = np.transpose(covlist[i]) + 0.001*np.identity(nDimension)
            aux = pdfnvar(xin[j,], mi, covi, nSamples)
            aux = np.asarray(aux)
            H[j][i] = aux[0]

    Haug = pd.DataFrame(H)
    Haug.insert(H.shape[1], H.shape[1], 1)
    Haug.to_numpy()

    W = (np.linalg.inv(Haug.T @ Haug) @ Haug.T) @ yin.T    # W<-( solve( t(Haug) %*% Haug) %*% t (Haug) ) %*% yin

    return [m, covlist, W, H]



# Calcula a saída da rede RBF
def YRBF(xin, modRBF):

    # Função Radial Gaussiana
    def pdfnvar(x, m, K, n):
        if(n == 1):
            r = np.sqrt(int(K))
            px = (1/(np.sqrt(2*np.pi*r*r)))*np.exp(-0.5 * ((x-m)/(r))**2)
        else:
            px = ((1/np.sqrt((2*np.pi)**n * (np.linalg.det(K))))) * np.exp(-0.5*((x-m) @ (np.linalg.inv(K) @ np.transpose(x-m))))
        return px

    nSamples = xin.shape[0]     # Numero de amostras.
    nDimension = xin.shape[1]     # Dimensao de entrada.  

    m = modRBF[0]
    covlist = modRBF[1]
    p = len(covlist) # Numero de funções radiais
    W = modRBF[2]

    H = np.zeros((nSamples, p))

    #calcula matriz H
    for j in range(nSamples):
        for i in range(p):
            mi = m[i,]
            covi = np.transpose(covlist[i]) + 0.001*np.identity(nDimension)
            aux = pdfnvar(xin[j,], mi, covi, nSamples)
            aux = np.asarray(aux)
            H[j][i] = aux[0]
    
    Haug = pd.DataFrame(H)
    Haug.insert(H.shape[1], H.shape[1], 1)
    Haug.to_numpy()

    Yhat = Haug @ W

    return Yhat