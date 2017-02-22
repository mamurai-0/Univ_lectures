import math
import random
import sys
from numpy import *


def f(x):
    return 3 * x[0] ** 2 + 2 * x[1] ** 2


def h(x):
    return 1 - x[0] - x[1]


def barrier_method(x, ck):
    return f(x) - ck * math.log(-h(x))


def penalty_method(x, ck):
    return f(x) + ck * max(0, h(x)) ** 2


def each_method(x, ck, flag):
    if flag == 0:
        return barrier_method(x, ck)
    else:
        return penalty_method(x, ck)


def nabla_b(x, ck):
    return array([6.0 * x[0] + (ck / (1.0 - x[0] - x[1])), 4.0 * x[1] + (ck / (1.0 - x[0] - x[1]))])


def nabla_p(x, ck):
    if h(x) > 0:
        return array([6 * x[0] - 2 * ck * h(x), 4 * x[1] - 2 * ck * h(x)])
    else:
        return array([6 * x[0], 4 * x[1]])


def each_nabla(x, ck, flag):
    if flag == 0:
        return nabla_b(x, ck)
    else:
        return nabla_p(x, ck)


def nabla_f(x):
    return array([6 * x[0], 4 * x[1]])


def norm_vec2(x):
    return x[0] * x[0] + x[1] * x[1]


def norm_vec(x):
    return math.sqrt(norm_vec2(x))


def x_new(ck, flag):
    if flag == 0:
        return array([(3 + math.sqrt(9 + 15 * ck)) / 15, (3 + math.sqrt(9 + 15 * ck)) / 10])
    else:
        return array([2 * ck / (6 + 5 * ck), 3 * ck / (6 + 5 * ck)])


def c(k, flag):
    if flag == 0:
        return 1 / (k + 1) ** 1
    else:
        return k ** 1


def solve(num, flag):
    k = 1
    ck = c(k, flag)
    x = x_new(ck, flag)
    for i in range (0, num):
        k += 1
        ck = c(k, flag)
        x = x_new(ck, flag)
    print(x)
    print(f(x))


def main(num):
    print("barrier method")
    solve(num, 0)
    print("\npenalty method")
    solve(num, 1)

main(int(sys.argv[1]))
