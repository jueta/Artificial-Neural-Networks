import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

xin = np.linspace(-15,10,20)

def fgx(xin):
    return 0.5*xin**2 + 3*xin + 10

mu, sigma = 0, 2
yout = fgx(xin) + 10 * np.random.normal(mu, sigma, len(xin))

#Aproximacao de grau 2
h = pd.concat([xin, xin**2], axis=1)
print(h)

plt.scatter(xin,yout)
plt.show()

