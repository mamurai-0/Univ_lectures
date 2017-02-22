from numpy import *
import sys


def p(x1, y1, x2, y2, cons):
    return cons * (x2 - x1) * ((x1 - x2) ** 2 + (y1 - y2) ** 2) ** (-3/2)


def q(x1, y1, x2, y2, cons):
    return cons * (y2 - y1) * ((x1 - x2) ** 2 + (y1 - y2) ** 2) ** (-3/2)


def f(u, cons1, cons2):
    x1  = u[0]
    x1_ = u[1]
    y1  = u[2]
    y1_ = u[3]
    x2  = u[4]
    x2_ = u[5]
    y2  = u[6]
    y2_ = u[7]
    f2 = p(x1, y1, x2, y2, cons2)
    f4 = q(x1, y1, x2, y2, cons2)
    f6 = -f2 * cons1 / cons2
    f8 = -f4 * cons1 / cons2
    return array([x1_, f2, y1_, f4, x2_, f6, y2_, f8])


def Runge_Kutta_2(u_n, h, cons1, cons2):
    k1 = h * f(u_n, cons1, cons2)
    k2 = h * f(u_n + k1, cons1, cons2)
    return u_n + 0.5 * (k1 + k2)


def Runge_Kutta_4(u_n, h, cons1, cons2):
    k1 = h * f(u_n, cons1, cons2)
    k2 = h * f(u_n + 0.5 * k1, cons1, cons2)
    k3 = h * f(u_n + 0.5 * k2, cons1, cons2)
    k4 = h * f(u_n + k3, cons1, cons2)
    return u_n + (k1 + 2 * k2 + 2 * k3 + k4) / 6


def solve_runge2(u_0, h, cons1, cons2):
    print(u_0[0], ",", u_0[2], ",", u_0[4], ",", u_0[6])
    u_n = u_0
    for i in range(0, 100000):
        u_n = Runge_Kutta_2(u_n, h, cons1, cons2)
        print(u_n[0], ",", u_n[2], ",", u_n[4], ",", u_n[6])


def solve_runge4(u_0, h, cons1, cons2):
    print(u_0[0], ",", u_0[2], ",", u_0[4], ",", u_0[6])
    u_n = u_0
    for i in range(0, 100000):
        u_n = Runge_Kutta_4(u_n, h, cons1, cons2)
        print(u_n[0], ",", u_n[2], ",", u_n[4], ",", u_n[6])


h = float(sys.argv[1])
cons1 = float(sys.argv[2])
cons2 = float(sys.argv[3])
u_0 = array([-2.0, 1.0, -2.0, 0.5, float(sys.argv[4]), float(sys.argv[5]), float(sys.argv[6]), float(sys.argv[7])])

if int(sys.argv[8]) == 2:
    solve_runge2(u_0, h, cons1, cons2)
else:
    solve_runge4(u_0, h, cons1, cons2)






