import numpy as np
import matplotlib.pyplot as plt


def f(t):
    return 0.5 * np.pi * np.cosh(t) * np.exp(- 0.25 * np.pi * np.sinh(t)) / np.cosh(0.5 * np.pi * np.sinh(t))


def n(h, prec):
    i = 1
    while np.abs(f(i * h)) + np.abs(f((i + 1) * h)) >= prec:
        i += 1
    return i


def m(h, prec):
    i = 1
    while np.abs(f(- i * h)) + np.abs(f(- (i + 1) * h)) >= prec:
        i += 1
    return i


def I(h, prec):
    n_ = n(h, prec)
    m_ = m(h, prec)
    summ = 0
    print("h = ", h)
    print(n_)
    print(m_)
    for k in range(- m_, n_ + 1):
        summ += f(k * h)
    return h * summ


prec = 1.0e-16
N = 5
hs = np.array([10 ** (- i) for i in range(N)])
js = np.array([np.abs(I(hs[i], prec) - I(hs[i]/2, prec)) for i in range(N)])
plt.xscale('log')
plt.yscale('log')
plt.xlim(xmin=10 ** -5)
plt.xlim(xmax=10 ** 1)
plt.plot(hs, js)
print(hs)
print(js)
plt.show()