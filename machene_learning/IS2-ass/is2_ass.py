import math

def e(ls):
    return (sum(ls)) / len(ls)

def var(ls):
    ans = 0
    ex = e(ls)
    for x in ls:
        ans += (x - ex) * (x - ex)
    return ans / (len(ls) - 1)

def sigma(ls):
    return math.sqrt(var(ls))

def cov(ls1, ls2):
    ans = 0
    ex1 = e(ls1)
    ex2 = e(ls2)
    for i, x in enumerate(ls1):
        y = ls2[i]
        ans += (x - ex1) * (y - ex2)
    return ans / len(ls1)

def coeff(ls1, ls2):
    return cov(ls1, ls2) / (sigma(ls1) * sigma(ls2))

f1 = open('correlation1.txt', 'r')
f2 = open('correlation2.txt', 'r')
f3 = open('correlation3.txt', 'r')
f4 = open('correlation4.txt', 'r')

fs = [f1, f2, f3, f4]
for f in fs:
    xs = []
    ys = []
    for row in f:
        xs.append(float((row.split(',')).pop(0)))
        ys.append(float((row.split(',')).pop(1)))
    print(coeff(xs,ys))
