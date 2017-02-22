import numpy as np
import matplotlib.pyplot as plt


def f(x):
    return np.exp(x ** 4) - np.pi


def df(x):
    return 4 * (x ** 3) * np.exp(x ** 4)


def x_new(x_k):
    return x_k - f(x_k) / df(x_k)


def newton(prec, x_0):
    x_l = x_new(x_0)
    x_k = x_0
    ans = np.array([x_k, x_l])
    i = 1
    while np.abs(x_l - x_k) >= prec:
        i += 1
        x_k = x_l
        x_l = x_new(x_l)
        ans = np.append(ans, x_l)
    return [ans, i]


def x_new_r(x_k, lambd, j):
    return x_k - (lambd ** (-j)) * f(x_k) / df(x_k)


def calc_j(x_k, beta, lambd):
    j = 1
    while np.abs(f(x_new_r(x_k, lambd, j))) > (1 - beta * (lambd ** (-j))) * np.abs(f(x_k)):
        j += 1
    print(j)
    return j


def reduced_newton(prec, beta, lambd, x_0):
    j = calc_j(x_0, beta, lambd)
    x_l = x_new_r(x_0, lambd, j)
    x_k = x_0
    ans = np.array([x_k, x_l])
    i = 1
    while np.abs(x_l - x_k) >= prec:
        i += 1
        j = calc_j(x_l, beta, lambd)
        x_k = x_l
        x_l = x_new_r(x_l, lambd, j)
        ans = np.append(ans, x_l)
    return [ans, i]


x0 = 5.0
prec = 0.00001
x2 = reduced_newton(prec, 0.25, 2, x0)
y2 = np.log(np.abs(f(x2[0])))
z2 = np.arange(x2[1] + 1)
print(x2[0])
print(z2)
plt.plot(z2, y2, label="PF", color="red", linewidth=2.5)
x3 = newton(prec, x0)
y3 = np.log(np.abs(f(x3[0])))
z3 = np.arange(x3[1] + 1)
print(x3[0])
print(z3)
plt.plot(z3, y3, label="PF", color="blue", linewidth=2.5)
plt.show()
