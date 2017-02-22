//
// Created by 今村秀明 on 2017/01/25.
//
//サンプルプログラムを一部流用しました
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>
#include <sys/time.h>

// ----- matrix access ----- //
// mat[i,j]
// rowsize: n
// row    : i
// column : j
#define IDX(mat,n, i,j) (mat)[(i)+(j)*(n)]
//-------------------------//

void print_matrix(double *a, int m, int n){
  for(int i=0; i<m; i++){
    for(int j=0; j<n; j++){
      printf("%.2f ", IDX(a,m, i,j));
    }
    printf("\n");
  }
}

double uniform(){
  static int init_flg = 0;
  if(!init_flg){
    init_flg = 1;
    srand((unsigned)time(NULL));
  }
  return ((double)rand()+1.0)/((double)RAND_MAX+2.0);
}

double get_dtime(){
  struct timeval tv;
  gettimeofday(&tv, NULL);
  return (double)tv.tv_sec + (double)(tv.tv_usec)*0.001*0.001;
}

void mymm(int *m, int *n, int *k, double *a, double *b, double *c){
  // c[1:*m][1:*n] = a[1:*m][1:*k] * b[1:*k][1:*n]
  for(int ii=0; ii<*m; ii+=100){
    for(int jj=0; jj<*n; jj+=100){
      for(int kk=0; kk<*k; kk+=100){
        for(int i=ii; i<ii+100; i++){
          for(int j=jj; j<jj+100; j++){
            IDX(c, *m, i, j) = 0;
            for(int l=kk; l<kk+100; l++){
              IDX(c, *m, i, j) += IDX(a, *m, i, l) * IDX(b, *k, l, j);
        }
      }
    }
  }
}

double run_dmymm_new(int M, int N, int K){
  double t1,t2;

  // c[1:M][1:N] = a[1:M][1:K] * b[1:K][1:N]
  double *a,*b,*c;
  int m=M, n=N, k=K;
  a = (double*)malloc(sizeof(double)*M*K);
  b = (double*)malloc(sizeof(double)*K*N);
  c = (double*)malloc(sizeof(double)*M*N);

  for(int i=0; i<m; i++){
    for(int j=0; j<k; j++){
      IDX(a, m, i, j) = uniform();
    }
  }
  for(int i=0; i<k; i++){
    for(int j=0; j<n; j++){
      IDX(b, k, i, j) = uniform();
    }
  }

//  printf("matrix A:\n");
//  print_matrix(a, m, k);
//  printf("matrix B:\n");
//  print_matrix(b, k, n);

  t1 = get_dtime();
  mymm(&m,&n,&k, a, b, c);
  t2 = get_dtime();

//  printf("matrix C:\n");
//  print_matrix(c, m, n);

  printf("myMM-elapsed: %.10e\n", t2-t1);

  free(c);
  free(b);
  free(a);

  return t2-t1;
}

void make_data(){
  int num=51;
  double *ts_dmymm;
  ts_dmymm = (double*)malloc(sizeof(double)*num);

  ts_dmymm[0] = run_dmymm_new(10, 10, 10);
  for(int i=1; i<(num+1); i++){
    int N = i*100;
    ts_dmymm[i] = run_dmymm_new(N, N, N);
  }
  //結果をファイルに出力する。
  //形式は1行目にデータ数。以降にデータが並ぶ。
  FILE* fp;
  fp = fopen("data_dmymm_new.txt", "w");
  fprintf(fp, "%d\n", num);
  for(int i=0; i<(num+1); i++){
    fprintf(fp, "%f\n", ts_dmymm[i]);
  }
  fclose(fp);
}

int main() {
  make_data();

  return 0;
}