#include <stdio.h>
#include <sys/time.h>

#define X_MAX 1000
#define Y_MAX 1000
#define T_MAX 100

int main() {
    float u[2][X_MAX][Y_MAX];
    float r;
    int b;
    struct timeval t1, t2;

    scanf("%f", &r);

    for(int i=0; i<X_MAX; i++){
        u[0][i][0] = 0;
        u[0][i][Y_MAX-1] = 0;
    }
    for(int j=0; j<Y_MAX; j++) {
        u[0][0][j] = 0;
        u[0][X_MAX - 1][j] = 0;
    }
    for(int i =1; i<X_MAX-1; i++){
        for(int j=1; j<Y_MAX-1; j++){
            u[0][i][j] = 1;
        }
    }

    gettimeofday(&t1, NULL);
    for(int t=1; t<T_MAX; t++){
        for(int i=1; i<X_MAX-1; i++){
            for(int j=1; j<Y_MAX-1; j++) {
                if (t % 2 == 1) {
                    b = 1;
                } else {
                    b = 0;
                }
                u[b][i][j] = (1-4*r)*u[1-b][i][j] + r * (u[1-b][i-1][j]+u[1-b][i+1][j]+u[1-b][i][j-1]+u[1-b][i][j+1]);
                //printf("%f ", u[b][i][j]);
            }
            //printf("\n");
        }
        //printf("\n");
    }
    gettimeofday(&t2, NULL);
    printf("%f\n", ((double)(t2.tv_sec) - (double)(t1.tv_sec) + ((double)(t2.tv_usec) - (double)(t1.tv_usec)) * 0.001 * 0.001));

    return 0;
}