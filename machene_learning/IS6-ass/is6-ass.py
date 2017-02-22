import numpy as np
import matplotlib.pyplot as plt


def chi2_sample(n):
    x1 = np.random.normal(0, 1, n)
    x2 = np.random.normal(0, 1, n)
    return x1 ** 2 + x2 ** 2


def student_t_sample(n):
    x1 = np.random.normal(0, 1, n)
    x2 = chi2_sample(n)
    vec = np.vectorize(np.sqrt)
    return x1 / vec(x2/ 2)


def law_of_large_numbers(n, mode):
    if mode == "chi2":
        x = chi2_sample(n)
        m = 2
    elif mode == "student":
        x = student_t_sample(n)
        m = 0
    summ = 0
    iter = np.arange(0, n, 1)
    ms = []
    for i in iter:
        summ += x[i]
        x[i] = summ / (i + 1)
        ms.append(m)
    plt.plot(iter, x)
    plt.plot(iter, ms)
    plt.show()


def central_limit_theorem(n, m, mode):
    means = []
    for i in range(m):
        if mode == "chi2":
            x = chi2_sample(n)
        elif mode == "student":
            x = student_t_sample(n)
        means.append(np.mean(x))
    plt.hist(means, bins=50, normed = True)
    plt.show()


law_of_large_numbers(7000, "chi2")
law_of_large_numbers(10000, "student")
central_limit_theorem(10000, 10000, "chi2")
central_limit_theorem(10000, 5000, "student")