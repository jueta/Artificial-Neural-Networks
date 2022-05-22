import numpy as np
from sklearn.cluster import KMeans

def trainRBF(xin, yin, p):

    # Função Radial Gaussiana
    def pdfnvar(x, m, K, n):
        if(n == 1):
            r = np.sqrt(int(K))
            px = (1/(np.sqrt(2*np.pi*r*r)))*np.exp(-0.5 * ((x-m)/(r))**2)
        else:
            px = ((1/np.sqrt((2*np.pi)^n*(np.det(K)))))*np.exp(-0.5*(np.transpose(x-m) @ (np.linalg.inv(K) @ (x-m))))
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
    for i in p:
        xci = xin[xclust[i]]
        if nDimension == 1:
            covi = np.var(xci)
        else:
            covi = np.cov(xci)

        covlist[[i]] = covi
    
    H = np.matrix([nSamples, p])

    #calcula matriz H
    for j in nSamples:
        for i in p:
            mi = m[i,]
            covi = covlist[i]
            covi = covlist.T + 0.001*np.diag(nDimension)
            H[j,i] = pdfnvar(xin[j,], mi, covi, n)


    Haug = np.concatenate((np.ones(H.shape[0], dtype=float), H), axis=1)
    W = ( np.linalg.pinv(Haug) @ yin)    #W<−pseudoinverse(Haug) %*% yin 

    return [m, covlist, W, H]


# Calcula a saída da rede RBF
def YRBF(xin, modRBF):

    # Função Radial Gaussiana
    def pdfnvar(x, m, K, n):
        if(n == 1):
            r = np.sqrt(int(K))
            px = (1/(np.sqrt(2*np.pi*r*r)))*np.exp(-0.5 * ((x-m)/(r))**2)
        else:
            px = ((1/np.sqrt((2*np.pi)^n*(np.det(K)))))*np.exp(-0.5*(np.transpose(x-m) @ (np.linalg.inv(K) @ (x-m))))
        return px

    nSamples = xin.shape[0]     # Numero de amostras.
    nDimension = xin.shape[1]     # Dimensao de entrada.  

    m = modRBF[0]
    covlist = modRBF[1]
    p = len(covlist) # Numero de funções radiais
    W = modRBF[2]

    H = np.matrix([nSamples, p])

    # Calcula matriz H
    for j in nDimension:
        for i in p:
            mi = m[i,]
            covi = covlist[i]
            covi = covlist.T + 0.001*np.diag(nDimension)
            H[j,i] = pdfnvar(xin[j,], mi, covi, n)
    
    Haug = np.concatenate((np.ones(H.shape[0], dtype=float), H), axis=1)
    Yhat = Haug @ W

    return Yhat