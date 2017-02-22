import numpy as np
import matplotlib.pyplot as plt
import random as rand


def k(x, y, h):
    return np.exp(- (x - y) ** 2 / (2 * h ** 2))


def k_mat(xs, h):
    n = len(xs)
    return np.matrix([[k(xs[i], xs[j], h) for j in range(0, n)] for i in range(0, n)])


def f(x, xs, theta, h):
    n = len(xs)
    return np.sum(np.array([theta[i] * k(x, xs[i], h) for i in range(n)]))


def k_mat_(xs, xs_, h):
    n1 = len(xs)
    n2 = len(xs_)
    return np.matrix([[k(xs[i], xs_[j], h) for j in range(0, n2)] for i in range(0, n1)])


def error(xs, ys, xs_, theta, h):
    z = (np.array(list(k_mat_(xs, xs_, h).dot(theta).flat)) - ys)
    return 0.5 * z.T.dot(z)


def theta_learned(xs, ys, h, l):
    n = len(xs)
    K = k_mat(xs, h)
    L = K.T.dot(K) + l * np.matrix(np.identity(n))
    return np.array(list(L.I.dot(K.T).dot(ys).flat))


def cross_varidation(xs, ys, h, l, m):
    n = len(xs)
    xs_conf = np.array([[xs[i] for i in range(0, n) if n * j / m <= i < n * (j + 1) / m] for j in range(0, m)])
    ys_conf = np.array([[ys[i] for i in range(0, n) if n * j / m <= i < n * (j + 1) / m] for j in range(0, m)])
    xs_learn = np.array([[xs[i] for i in range(0, n) if 0 <= i < n * j / m or n * (j + 1) / m <= i < n] for j in range(0, m)])
    ys_learn = np.array([[ys[i] for i in range(0, n) if 0 <= i < n * j / m or n * (j + 1) / m <= i < n] for j in range(0, m)])
    theta = np.array([theta_learned(xs_learn[i], ys_learn[i], h, l) for i in range(m)])
    return np.mean(np.array([error(xs_conf[i], ys_conf[i], xs_learn[i], theta[i], h) for i in range(m)]))


n = 50
N = 500
xs = np.linspace(-3, 3, n, endpoint=True)
ys = np.sin(np.pi * xs) / (np.pi * xs) + 0.1 * xs + [0.15 * rand.gauss(0, 1) for i in range(n)]
xss = np.linspace(-3, 3, N, endpoint=True)
yss = np.sin(np.pi * xss) / (np.pi * xss) + 0.1 * xss

hs = np.array([0.001, 0.01, 0.1, 1, 10])
ls = np.array([0.001, 0.01, 0.1, 1, 10])
h_len = len(hs)
es = np.array([cross_varidation(xs, ys, h, l, 13) for h in hs for l in ls])
e = np.argmin(es)

h_ = hs[e / h_len]
l_ = ls[e % h_len]
print(h_)
print(l_)
theta_ = theta_learned(xs, ys, h_, l_)
ys_ = np.array([f(xss[i], xs, theta_, h_) for i in range(N)])

plt.plot(xss, ys_, c='g')
plt.plot(xss, yss, c='r')
plt.scatter(xs, ys, c='b')
plt.show()