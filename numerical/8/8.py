import numpy as np


def mat_mul(A, B):
    m = len(A)
    na = len(A[0])
    nb = len(B)
    l = len(B[0])
    if na != nb:
        return "size error"
    C = np.zeros((m, l))
    for i in range(m):
        for j in range(l):
            for k in range(na):
                C[i][j] += A[i][k] * B[k][j]
    return C


A = np.array([[1,2], [3,4]])
B = np.array([[0,1], [1,0]])
print(mat_mul(A,B))

A = np.identity(100)
B = np.zeros((100,100))
B[0][0]=10
print(mat_mul(A,B))

A = np.array([[1,2,3], [4,5,6]])
B = np.array([[1,2], [4,5]])
print(mat_mul(A,B))
