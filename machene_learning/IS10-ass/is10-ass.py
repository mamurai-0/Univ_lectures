import numpy as np
import matplotlib.pyplot as plt

def generate_3Ddata(N):
    mean_a = np.array([0, 0, 0])
    mean_b = np.array([0, 5, 5])
    mean_c = np.array([5, 0, 5])
    cov = np.identity(3)
    a = np.random.multivariate_normal(mean_a, cov, N)
    b = np.random.multivariate_normal(mean_b, cov, N)
    c = np.random.multivariate_normal(mean_c, cov, N)

    fig = plt.figure()
    axx = fig.add_subplot(111, projection='3d')
    ax = np.array([a[i][0] for i in range(N)])
    ay = np.array([a[i][1] for i in range(N)])
    az = np.array([a[i][2] for i in range(N)])
    axx.scatter(ax, ay, az)
    bx = np.array([b[i][0] for i in range(N)])
    by = np.array([b[i][1] for i in range(N)])
    bz = np.array([b[i][2] for i in range(N)])
    axx.scatter(bx, by, bz)
    cx = np.array([c[i][0] for i in range(N)])
    cy = np.array([c[i][1] for i in range(N)])
    cz = np.array([c[i][2] for i in range(N)])
    axx.scatter(cx, cy, cz)
    return np.concatenate((a, b, c))


def norm3(x):
    return np.sqrt(x[0] * x[0] + x[1] * x[1] + x[2] * x[2])


def norm2(x):
    return np.sqrt(x[0] * x[0] + x[1] * x[1])


def pca(x, C):
    la, v = np.linalg.eig(C)
    v_ = np.array([v[i] / norm3(v[i]) for i in range(len(v))])
    t = np.array([v_[0], v_[1]])
    x_ = np.array([t.T.dot(t).dot(x[i]) for i in range(len(x))])
    x__ = np.array([[x_[i].dot(t[0]), x_[i].dot(t[1])] for i in range(len(x_))])
    x__x = np.array([x__[i][0] for i in range(len(x__))])
    x__y = np.array([x__[i][1] for i in range(len(x__))])
    fig = plt.figure()
    ax = fig.add_subplot(1,1,1)
    ax.scatter(x__x, x__y)
    return x__


def argmin(x, u):
    ans = 0
    val = norm2(x - u[0]) ** 2
    for i in range(len(u)):
        val_ = norm2(x - u[i]) ** 2
        if val > val_:
            ans = i
            val = val_
    return ans


def sum_vec(x):
    ans = x[0] - x[0]
    for i in range(len(x)):
        ans += x[i]
    return ans


def scat(x, c, ax):
    xx = np.array([x[i][0] for i in range(len(x))])
    xy = np.array([x[i][1] for i in range(len(x))])
    ax.scatter(xx, xy, c=c)


def k_means(x):
    xx = np.array([x[i][0] for i in range(len(x))])
    xy = np.array([x[i][1] for i in range(len(x))])
    xx_max = max(xx)
    xy_max = max(xy)
    xy_min = min(xx)
    xx_min = min(xy)
    u = np.array([[np.random.uniform(xx_min, xx_max), np.random.uniform(xy_min, xy_max)] for i in range(3)])
    for j in range(10):
        y = np.array([argmin(x[i], u) for i in range(len(x))])
        n0 = np.sum(np.array([1 for i in range(len(y)) if y[i] == 0]))
        n1 = np.sum(np.array([1 for i in range(len(y)) if y[i] == 1]))
        n2 = np.sum(np.array([1 for i in range(len(y)) if y[i] == 2]))
        u[0] = sum_vec(np.array([x[i] for i in range(len(x)) if y[i] == 0])) / n0
        u[1] = sum_vec(np.array([x[i] for i in range(len(x)) if y[i] == 1])) / n1
        u[2] = sum_vec(np.array([x[i] for i in range(len(x)) if y[i] == 2])) / n2
    x0 = np.array([x[i] for i in range(len(x)) if y[i] == 0])
    x1 = np.array([x[i] for i in range(len(x)) if y[i] == 1])
    x2 = np.array([x[i] for i in range(len(x)) if y[i] == 2])
    fig = plt.figure()
    ax = fig.add_subplot(1,1,1)
    scat(x0, 'red', ax)
    scat(x1, 'blue', ax)
    scat(x2, 'green', ax)

n = 3000
x = generate_3Ddata(n // 3)
C_ = np.array([np.array([[x[i][j] * x[i][k] for j in range(3)] for k in range(3)]) for i in range(n)])
C = np.zeros((3,3))
for i in range(n):
    C += C_[i]
x_ = pca(x, C)
k_means(x_)
plt.show()