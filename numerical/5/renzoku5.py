import numpy as np
import matplotlib.pyplot as plt


def Legendre(n, x):
    if n <= 0:
        return 1
    elif n == 1:
        return x
    else:
        return ((2 * n - 1) * x * Legendre(n - 1, x) - (n - 1) * Legendre(n - 2, x)) / n


x = np.linspace(-1, 1, 200, endpoint=True)
for i in range(11):
    y = []
    for j in x:
        y = np.append(y, Legendre(i, j))
    plt.plot(x, y)
plt.show()
