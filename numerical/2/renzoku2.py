import math


def f(z, r, theta, d):
    return z - r * math.cos(theta) - math.cos(d + r * math.sin(theta))


def f_dash(d, r, theta):
    return math.sin(theta) + math.cos(theta) * math.sin(d + r * math.sin(theta))


def f_2dash(d, r, theta):
    return math.cos(theta) - math.sin(theta) * math.cos(d + r * math.sin(theta)) + r * math.cos(theta) * math.cos(theta) * math.cos(d + r * math.sin(theta))


def theta_next(d, r, theta):
    return theta - f_dash(d, r, theta) / f_2dash(d, r, theta)


def newton(prec, d, r, theta):
    next_theta = theta_next(d, r, theta)
    i = 0
    while math.fabs(next_theta - theta) >= prec:
        theta = next_theta
        next_theta = theta_next(d, r, next_theta)
        i += 1
    print("iteration time = ")
    print(i)
    return next_theta


def solve(prec, r, x0, y0, z0, g):
    d0 = math.sqrt(x0*x0 + y0*y0)
    theta = 1
    theta = newton(prec, d0, r, theta)
    time = math.sqrt(2 * f(z0, r, theta, d0) / g)
    print("time = ")
    print(time)


solve(0.00000001, 0.5, 1, 1, 5, 0.98)
solve(0.00000001, 10, 1, 1, 100, 0.98)
