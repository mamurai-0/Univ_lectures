import numpy as np
import matplotlib.pyplot as plt
import time

def dft(a):
    T = len(a)
    omega = np.array([[np.exp(- 2 * np.pi * 1.0j * n * t / T) for n in range(T)] for t in range(T)])
    return omega.dot(a)


def fft(a):
    T = len(a)
    if T == 1:
        return a
    omega_T = np.exp(- 2 * np.pi * 1.0j / T)
    omega = 1
    a0 = np.array([a[i] for i in range(T) if i % 2 == 0])
    a1 = np.array([a[i] for i in range(T) if i % 2 == 1])
    y0 = fft(a0)
    y1 = fft(a1)
    y = np.array([0 + 0j for i in range(T)])
    for k in range(T // 2):
        y[k] = y0[k] + omega * y1[k]
        y[k + T / 2] = y0[k] - omega * y1[k]
        omega *= omega_T
    return y


n = 9
t_dft = []
t_fft = []
for i in range(n):
    start = time.time()
    dft(np.ones(2 ** i))
    elapsed = time.time() - start
    t_dft = np.append(t_dft, elapsed)
    start = time.time()
    fft(np.ones(2 ** i))
    elapsed = time.time() - start
    t_fft = np.append(t_fft, elapsed)
plt.plot(range(n), t_dft, "blue", label="DFT")
plt.plot(range(n), t_fft, "green", label="FFT")
plt.title("DFT and FFT time graph")
plt.legend()
plt.xlabel("number of elements 2 ** i")
plt.ylabel("time")
plt.show()
