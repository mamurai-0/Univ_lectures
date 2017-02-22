import numpy as np
import matplotlib.pyplot as plt


def make_flops(N, a):
    return np.array([float(s[0:-1]) for s in a])


f = open("data_dgemm.txt", "r")
g = open("data_dmymm.txt", "r")
h = open("data_dmymm_new.txt", "r")
t_dgemm = f.readlines()
t_dmymm = g.readlines()
t_dmymm_ = h.readlines()
t_dmymm_[0] = "0.000001"
N = int(t_dgemm[0])
flops_dgemm = make_flops(N, t_dgemm[1:N+1])
flops_dmymm = make_flops(N, t_dmymm[1:N+1])
flops_dmymm_ = make_flops(N, t_dmymm_[1:N+1])
xs = [10]
xs[1:N+1] = np.array([(i+1)*100 for i in range(N-1)])
plt.plot(xs, flops_dgemm, label="dgemm")
plt.plot(xs, flops_dmymm, label="dmymm")
plt.plot(xs, flops_dmymm_, label="dmymm_block")
plt.xscale("log")
plt.yscale("log")
plt.legend(loc="upper left")
plt.xlabel("size of matrix")
plt.ylabel("execution time")
plt.savefig("3.png")

