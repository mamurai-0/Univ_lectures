import random
import math


def f(x):
    return 10 * x[0] * x[0] + x[1] * x[1]


def nabla_f(x):
    return [20 * x[0], 2 * x[1]]


def x_new(xk, epk):
    nabla = nabla_f(xk)
    return [xk[0] - epk * nabla[0], xk[1] - epk * nabla[1]]


def norm_vec2(x):
    return x[0] * x[0] + x[1] * x[1]


def norm_vec(x):
    return math.sqrt(norm_vec2(x))


def armijo_rule(xk, epk, alpha):
    if f(x_new(xk, epk)) - f(xk) <= -alpha * epk * norm_vec2(nabla_f(xk)):
        return True
    else:
        return False


def backtracking(xk, alpha, beta):
    epk = 1
    while not armijo_rule(xk, epk, alpha):
        epk = epk * beta
    return epk


def optimam(x, prec):
    if math.fabs(norm_vec(nabla_f(x))) < prec:
        return True
    else:
        return False


def solve(prec):
    x0 = random.random()
    y0 = random.random()
    x = [x0, y0]
    alpha = 0.5
    beta = 0.8
    print("(x,y) = ")
    print(x)
    while not optimam(x, prec):
        ep = backtracking(x, alpha, beta)
        x = x_new(x, ep)
        print(f(x))

    print(f(x))

solve(0.1)
