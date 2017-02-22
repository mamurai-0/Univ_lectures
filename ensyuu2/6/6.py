import numpy as np
import sys


def mat_to_mlu(A):
    n = len(A)
    b11 = A[0][0]
    b_c = np.array([A[0][i] for i in range(1,n)])
    b_l = np.array([A[i][0] for i in range(1,n)])
    b_2 = np.array([np.array([A[i][j] for j in range(1,n)]) for i in range(1,n)])
    return [b11, b_c, b_l, b_2]


def mlu_to_mat(A):
    n = len(A[3]) + 1
    B = np.zeros((n, n))
    B[0][0] = A[0]
    for i in range(1,n):
        B[0][i] = A[1][i - 1]
        B[i][0] = A[2][i - 1]
        for j in range(1,n):
            B[i][j] = A[3][i - 1][j - 1]
    return B


def argmax(A):
    i = 0
    for j in range(len(A)):
        if np.abs(A[i]) < np.abs(A[j]):
            i = j
    return i


def partial_pivot(A):
    n = len(A)
    m = argmax(np.array([A[i][0] for i in range(n)]))
    A = change_row(A, 0, m)
    return A, [m, 0]


def change_row(A, i, j):
    for k in range(len(A)):
        tmp = A[i][k]
        A[i][k] = A[j][k]
        A[j][k] = tmp
    return A


def change_l(a, ms):
    for i in range(len(ms) // 2):
        x = ms[2 * i]
        y = ms[2 * i + 1]
        tmp = a[x]
        a[x] = a[y]
        a[y] = tmp
    return a


def LUdecomp(A):
    n = len(A)
    if n == 0:
        return np.array([], dtype=float)
    B = mat_to_mlu(A)
    B[2] = B[2] / B[0]
    C = np.array([np.array([B[2][i] * B[1][j] for j in range(n - 1)]) for i in range(n - 1)])
    B[3] = LUdecomp(B[3] - C)
    return mlu_to_mat(B)


def LUdecomp_partial_pivot(A):
    n = len(A)
    if n == 0:
        return np.array([], dtype=float), np.array([], dtype=int)
    A, m = partial_pivot(A)
    B = mat_to_mlu(A)
    B[2] = B[2] / B[0]
    C = np.array([np.array([B[2][i] * B[1][j] for j in range(n - 1)]) for i in range(n - 1)])
    B[3], ms = LUdecomp_partial_pivot(B[3] - C)
    B[2] = change_l(B[2], ms)
    return mlu_to_mat(B), np.append(ms + 1, m)


n = int(sys.argv[1])
A = np.identity(n)
for i in range(n):
    for j in range(n):
        A[i][j] = 1 / (i + j + 1)
print("A = \n", A)

B = LUdecomp(A)
L = np.identity(n)
U = np.identity(n)
for i in range(1, n):
    for j in range(0, i):
        L[i][j] = B[i][j]
for i in range(n):
    for j in range(i, n):
        U[i][j] = B[i][j]
print("LU - A = \n", L.dot(U) - A)

B, ms = LUdecomp_partial_pivot(A)
L = np.identity(n)
U = np.identity(n)
P = np.identity(n)
for i in range(1, n):
    for j in range(0, i):
        L[i][j] = B[i][j]
for i in range(n):
    for j in range(i, n):
        U[i][j] = B[i][j]
for i in range(len(ms) // 2):
    P = change_row(P, ms[2 * i], ms[2 * i + 1])
print("LU - PA = \n", L.dot(U) - P.dot(A))
