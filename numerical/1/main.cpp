#include <iostream>
#include <math.h>

using namespace std;

int main() {
    float  fx1,fx2,fy1,fy2,fr1,fr2,fvx1,fvx2,fvy1,fvy2,fX,fY,fVx,fVy,fR;
    double dx1,dx2,dy1,dy2,dr1,dr2,dvx1,dvx2,dvy1,dvy2,dX,dY,dVx,dVy,dR;

    printf("C1: (x1 y1 vx1 vy1 r1) = ");
    scanf("%lf %lf %lf %lf %lf", &dx1, &dy1, &dvx1, &dvy1, &dr1);
    printf("C2: (x2 y2 vx2 vy2 r2) = ");
    scanf("%lf %lf %lf %lf %lf", &dx2, &dy2, &dvx2, &dvy2, &dr2);

    printf("##########float##########\n");
    fx1 = (float)dx1;
    fx2 = (float)dx2;
    fy1 = (float)dy1;
    fy2 = (float)dy2;
    fr1 = (float)dr1;
    fr2 = (float)dr2;
    fvx1 = (float)dvx1;
    fvx2 = (float)dvx2;
    fvy1 = (float)dvy1;
    fvy2 = (float)dvy2;
    fX  = fx1 - fx2;
    fY  = fy1 - fy2;
    fVx = fvx1 - fvx2;
    fVy = fvy1 - fvy2;
    fR  = fr1 + fr2;
    float D = (fR * fR * (fVx * fVx + fVy * fVy)) - ((fX * fVy + fY * fVx) * (fX * fVy + fY * fVx));
    float a = fVx * fVx + fVy * fVy;
    float b = (fX * fVx + fY * fVy);
    float c = fX * fX + fY * fY - fR * fR;
    float fans1,fans2;
    int flag=0;
    if (D < 0){
        flag = 1;
    }else if (a == 0){
        flag = 2;
        fans1 = - c / b;
    }else if(b >= 0){
        fans1 = (b + sqrt(D)) / a;
        fans2 = c / (a * fans1);
    }else{
        fans1 = (b - sqrt(D)) / a;
        fans2 = c / (a * fans1);
    }
    if(flag == 0) {
        printf("ans1 = %lf, ans2 = %lf\n", fans1, fans2);
    }else if (flag == 1){
        printf("No collision\n");
    }else if (flag == 2){
        printf("ans = %lf\n", fans1);
    }

    printf("##########double##########\n");
    dX  = dx1 - dx2;
    dY  = dy1 - dy2;
    dVx = dvx1 - dvx2;
    dVy = dvy1 - dvy2;
    dR  = dr1 + dr2;
    double dD = (dR * dR * (dVx * dVx + dVy * dVy)) - ((dX * dVy + dY * dVx) * (dX * dVy + dY * dVx));
    double da = dVx * dVx + dVy * dVy;
    double db = (dX * dVx + dY * dVy);
    double dc = dX * dX + dY * dY - dR * dR;
    double dans1,dans2;
    int dflag=0;
    if (dD < 0){
        dflag = 1;
    }else if (da == 0){
        dflag = 2;
        dans1 = - dc / db;
    }else if(db >= 0){
        dans1 = (db + sqrt(dD)) / da;
        dans2 = dc / (da * dans1);
    }else{
        dans1 = (db - sqrt(dD)) / da;
        dans2 = dc / (da * dans1);
    }
    if(dflag == 0) {
        printf("ans1 = %lf, ans2 = %lf\n", dans1, dans2);
    }else if (dflag == 1){
        printf("No collision\n");
    }else if (dflag == 2){
        printf("ans = %lf\n", dans1);
    }

    printf("##########analysis##########\n");

    return 0;
}