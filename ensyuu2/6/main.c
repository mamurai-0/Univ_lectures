#include <stdio.h>

#define N 5

int main() {
    double A[N][N];
    double A_[N][N];

    for (int i = 0; i < N; i++){
        for (int j = 0; j < N; j++){
            A[i][j] = 1 / (i + j + 1);
            A_[i][j] = A[i][j];
        }
    }

//    LU(A);

    for (int i = 0; i < N; i++){
        for (int j = 0; j < N; j++){
            printf("%f ", A[i][j]);
        }
        printf("\n");
    }
    printf("\n");
    for (int i = 0; i < N; i++){
        for (int j = 0; j < N; j++){
            printf("%f ", A_[i][j]);
        }
        printf("\n");
    }
    printf("\n");
    return 0;
}