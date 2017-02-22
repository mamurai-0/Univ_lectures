import numpy as np
import matplotlib.pyplot as plt
import random
import sys


def mean(xs):
    n = len(xs)
    return np.sum(xs) / n


def var(xs):
    e = mean(xs)
    xs_ = np.array([(x - e) ** 2 for x in xs])
    n = len(xs)
    return np.sum(xs_) / n


def uniform_m_v(n):
    us = np.array([random.uniform(0, 1) for i in range(n)])
    e = mean(us)
    v = var(us)
    return e, v


n = int(sys.argv[1])
e, v = uniform_m_v(n)
print("mean = ", e)
print("variance = ", v)

pop_mean = 0.5
pop_var = 1 / 12
xs = []
ms = []
vs = []
for i in range(int(sys.argv[2])):
    e, v = uniform_m_v(2 ** i)
    xs = np.append(xs, 2 ** i)
    ms = np.append(ms, e - pop_mean)
    vs = np.append(vs, v - pop_var)

plt.scatter(xs, ms, color='red')
plt.scatter(xs, vs, color='blue')
plt.xscale('log')
plt.yscale('log')
plt.ylim(10**(-int(sys.argv[2]) / 2), 1)
plt.show()
print("means = ", ms)
print("variances = ", vs)

