import numpy as np
import random


def f(n):
    num = 0
    for i in range(n):
        x = random.uniform(-1, 1)
        y = random.uniform(-1, 1)
        if x ** 2 + y ** 2 <= 1:
            num += 1
    return 4 * num / n


print(f(100))
print(f(10000))
print(f(1000000))
print(f(100000000))
