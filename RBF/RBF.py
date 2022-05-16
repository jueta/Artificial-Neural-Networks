import numpy as np
from sklearn.cluster import KMeans

def trainRBF(xin, yin, p):

    # Função Radial Gaussiana
    def pdfnvar(x, m, K, n):
        if(n == 1):
            r = np.sqrt(int(K))
            px = (1/(np.sqrt(2*pi*r*r)))*np.exp(-0.5 * ((x-m)/(r))**2)
        else:
            px = ((1/np.sqrt((2*np.pi)^n*(np.det(K)))))*np.exp(-0.5*(np.transpose(x-m) @ (solve(K) @ (x-m))))
        return px

    nSamples = xin.shape[0]     # Numero de amostras.
    nDimension = xin.shape[1]     # Dimensao de entrada.  

    xin = np.matrix(xin)
    yin = np.matrix(yin)
    xclust = KMeans(n_clusters=p).fit(xin)