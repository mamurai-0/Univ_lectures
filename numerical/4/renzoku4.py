import numpy as np


def poly(x, n, a):
    ans = a[n]
    for i in range(n-1, 0, -1):
        ans = ans * x + a[i]
    return ans


def make_array_poly(n, x, y, d):
    a = []
    b = np.ones(n + 1)
    z = np.arange(x, y + d, d)
    for i in range(0, z.size):
        a.append(poly(z[i], n, b))
    return a


def make_array_exp(x, y, d):
    a = []
    z = np.arange(x, y + d, d)
    for i in range(0, z.size):
        a.append(np.exp(z[i]))
    return a


def make_array_log(x, y, d):
    a = []
    z = np.arange(x, y + d, d)
    for i in range(0, z.size):
        a.append(np.log(z[i]))
    return a


def neville_interpolation(x, v, x_):
    n = x.size
    T = [[0 for i in range(n)] for k in range(n)]
    for i in range(0, n):
        T[i][0] = v[i]
    for i in range(0, n, 1):
        for k in range(1, i + 1, 1):
            T[i][k] = T[i][k - 1] + (T[i][k - 1] - T[i - 1][k - 1]) / ((x_ - x[i - k]) / (x_ - x[i]) - 1)
    return T[n - 1][n - 1]


def interpolation(x_, start, end, step, mode, n):
    x = np.arange(start, end + step, step)
    if mode == "poly":
        v = make_array_poly(n, start, end, step)
        a = np.ones(n + 1)
        ans = poly(x_, n, a)
    elif mode == "exp":
        v = make_array_exp(start, end, step)
        ans = np.exp(x_)
    elif mode == "log":
        v = make_array_log(start, end, step)
        ans = np.log(x_)
    v_inp = neville_interpolation(x, v, x_)
    err = v_inp - ans
    print(n, " mpde = ", mode, "\ninp = ", v_inp, "\nans = ", ans, "\nerr = ", err)


x_ = 0.75
start = 0.5
end = 1.0
step = 0.1
for n in range(2, 8, 1):
    interpolation(x_, start, end, step, "poly", n)
interpolation(x_, start, end, step, "exp", 1)
interpolation(x_, start, end, step, "log", 1)

