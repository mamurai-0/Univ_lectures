from pylab import *
import numpy as np
import random as rand
import matplotlib.pyplot as plt

def k(x, y, h):
    return np.exp(- (x - y).T.dot(x - y) / (2 * h ** 2))


def k_mat(xs, h):
    n = len(xs)
    return np.matrix([[k(xs[i], xs[j], h) for j in range(0, n)] for i in range(0, n)])


def f(x, xs, theta, h):
    n = len(xs)
    ans = np.array([theta[i] * k(x, xs[i], h) for i in range(n)])
    ans_ = np.sum(ans)
    return ans_

def sub_der(x, xs, y, t, h):
    n = len(xs)
    if 1 - f(x, xs, t, h) * y > 0:
        return np.array([- y * k(x, xs[i], h) for i in range(n)])
    else:
        return np.zeros(n)

def t_new(x, y, t, C, K, h):
    n = len(x)
    e = 0.01
    ans = np.zeros(n)
    for i in range(n):
        ans += sub_der(x[i], x, y[i], t, h)
    return np.array(list((t - e * (C * ans + 2 * K.dot(t))).flat))


def svm(x, y, C, h, prec):
    n = len(x)
    K = k_mat(x, h)
    t_ = np.ones(n)
    t = t_new(x, y, t_, C, K, h)
    while np.abs(t.dot(t.T) - t_.dot(t_.T)) > prec:
        t_ = t
        t = t_new(x, y, t_, C, K, h)
    return t


C = 1
h = 1

n = 200
a = np.linspace(0, 4 * np.pi, n // 2)
u1 = a * np.cos(a) + np.array([rand.random() for i in range(n // 2)])
u2 = (a + np.pi) * np.cos(a) + np.array([rand.random() for i in range(n // 2)])
v1 = a * np.sin(a) + np.array([rand.random() for i in range(n // 2)])
v2 = (a + np.pi) * np.sin(a) + np.array([rand.random() for i in range(n // 2)])
u = np.concatenate((u1, u2))
v = np.concatenate((v1, v2))
x_ = np.concatenate((u, v))
x = np.array([np.array([x_[i], x_[i + n]]) for i in range(n)])
y = np.concatenate((np.ones(n / 2), - np.ones(n / 2)))

prec = 0.001
t = svm(x, y, C, h, prec)

m = n // 2
xx = np.linspace(-15, 17, m)
X, Y = np.meshgrid(xx, xx)
XX = np.array([[np.array([X[i][j], Y[i][j]]) for j in range(m)] for i in range(m)])
Z = np.array([[np.sign(f(XX[i][j], x, t, h)) for j in range(m)] for i in range(m)])
plt.contourf(X, Y, Z)
plt.plot(u1, v1, 'bo')
plt.plot(u2, v2, 'rx')
plt.show()