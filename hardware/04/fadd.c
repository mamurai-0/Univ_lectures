#include <stdint.h>
#include <stdio.h>

uint32_t bit_n(uint32_t a, int n)
{
		if(n>=0){
				return (a >> n) & 1;
		}else{
				return 0;
		}
}

uint32_t sign(uint32_t a)
{
		return (a >> 31) & 1;
}

uint32_t exponent(uint32_t a)
{
		uint32_t exp = (a << 1) >> 24;
		return exp;
}

uint32_t mantissa(uint32_t a)
{
		uint32_t man = (a << 9) >> 9;
		return man;
}
int ZLC(uint32_t a, int s, int t)
{
		int ans=0;
		while((bit_n(a, s)==0) && (s>=t)){
				ans=ans+1;
				s--;
		}
		return ans;
}

uint32_t fadd(uint32_t a, uint32_t b)
{
		uint32_t winer,loser,answer_sign,answer_exp,answer_man,loser_man,winer_man,ulp,G,R,S,i,exp_dif;
		if((exponent(a)==255 && mantissa(a)!=0) || (exponent(b)==255 && mantissa(b)!=0)){
				return 0xffffffff;
		}else if(exponent(a)==255 && mantissa(a)==0){
				if(exponent(b)==255 && mantissa(b)==0){
						if(sign(a)==sign(b)){
								return a;
						}else{
								return 0xffffffff;
						}
				}else{
						return a;
				}
		}else if(exponent(b)==255 && mantissa(b)==0){
				return b;
		}else if(exponent(a)==0 && mantissa(a)==0){
				if(exponent(b)==0 && mantissa(b)==0){
						return ((sign(a) & sign(b)) << 31);
				}else{
						return b;
				}
		}else if(exponent(b)==0 && mantissa(b)==0){
				return a;
		}else if(exponent(a)==0 && mantissa(a)!=0){
				if(exponent(b)==0 && mantissa(b)!=0){
						if(sign(a)==sign(b)){
								answer_man=mantissa(a)+mantissa(b);
								if(bit_n(answer_man,23)==1){
										answer_exp=1;
										return (answer_man & 0x007fffff) | (answer_exp << 23) | (sign(a) << 31);
								}
								return answer_man | (sign(a) << 31);
						}else{
								if(mantissa(a)>mantissa(b)){
										winer=a;
										loser=b;
								}else if(mantissa(a)<mantissa(b)){
										winer=b;
										loser=a;
								}else{
										return 0;
								}
								answer_man=mantissa(winer)-mantissa(loser);
								return answer_man | (sign(winer) << 31);
						}
				}else{
						winer = b;
						loser = a;
						exp_dif = exponent(winer) - 1;
						if(exp_dif >= 27){
								exp_dif = 27;
						}
						answer_sign = sign(winer);
						answer_exp  = exponent(winer);
						winer_man = mantissa(winer);
						winer_man = winer_man | 0x00800000;
						winer_man = winer_man << 3;
						loser_man = mantissa(loser);
						ulp = bit_n(loser_man,exp_dif);
						G   = bit_n(loser_man,exp_dif-1);
						R   = bit_n(loser_man,exp_dif-2);
						S   = 0;
						if(exp_dif >=3){
								for(i=0;i<exp_dif-3;i++){
										S = S | bit_n(loser_man,i);
								}
						}
						loser_man = loser_man << 3;
						loser_man = loser_man >> exp_dif;
						loser_man = loser_man | (G << 2) | (R << 1) | S;
						if(sign(winer)==sign(loser)){
								answer_man = winer_man + loser_man;
								if(bit_n(answer_man,27) == 1){
										answer_exp = answer_exp + 1;
										S = bit_n(answer_man,0);
										answer_man = answer_man >> 1;
										answer_man = answer_man | S;
										ulp = bit_n(answer_man,3);
										G   = bit_n(answer_man,2);
										R   = bit_n(answer_man,1);
										S   = bit_n(answer_man,0);
										answer_man = answer_man >> 3;
										answer_man = answer_man + (G & (ulp | R | S));
										answer_man = answer_man & 0x007fffff;
										return (answer_sign << 31) | (answer_exp << 23) | answer_man;
								}else{
										ulp = bit_n(answer_man,3);
										G   = bit_n(answer_man,2);
										R   = bit_n(answer_man,1);
										S   = bit_n(answer_man,0);
										answer_man = answer_man >> 3;
										answer_man = answer_man + (G & (ulp | R | S));
										if(bit_n(answer_man,24) == 1){
												answer_exp = answer_exp + 1;
												ulp = bit_n(answer_man,1);
												G   = bit_n(answer_man,0);
												answer_man = answer_man >> 1;
												answer_man = answer_man + (G & ulp);
												answer_man = answer_man & 0x007fffff;
												return (answer_sign << 31) | (answer_exp << 23) | answer_man;
										}else{
												answer_man = answer_man & 0x007fffff;
												return (answer_sign << 31) | (answer_exp << 23) | answer_man;
										}
								}
				}else{
						loser_man = ~ loser_man;
						answer_man = winer_man + loser_man + 1;
						i=ZLC(answer_man,26,0);
						if(answer_exp > i){
								answer_exp = answer_exp - i;
								answer_man = answer_man << i;
								answer_man = answer_man & 0x03ffffff;
								ulp = bit_n(answer_man,3);
								G   = bit_n(answer_man,2);
								R   = bit_n(answer_man,1);
								S   = bit_n(answer_man,0);
								answer_man = answer_man >> 3;
								answer_man = answer_man + (G & (ulp | R | S));
								return (answer_sign << 31) | (answer_exp << 23) | answer_man;
						}else{
								answer_man = answer_man << (answer_exp - 1);
								answer_man = answer_man >> 3;
								answer_exp = 0;
								return (answer_sign << 31) | (answer_exp << 23) | answer_man;
						}
	
				}

				}
		}else if(exponent(b)==0 && mantissa(b)!=0){
				winer = a;
				loser = b;
				exp_dif = exponent(winer) - 1;
				if(exp_dif >= 27){
						exp_dif = 27;
				}
				answer_sign = sign(winer);
				answer_exp  = exponent(winer);
				winer_man = mantissa(winer);
				winer_man = winer_man | 0x00800000;
				winer_man = winer_man << 3;
				loser_man = mantissa(loser);
				ulp = bit_n(loser_man,exp_dif);
				G   = bit_n(loser_man,exp_dif-1);
				R   = bit_n(loser_man,exp_dif-2);
				S   = 0;
				if(exp_dif >=3){
						for(i=0;i<exp_dif-3;i++){
								S = S | bit_n(loser_man,i);
						}
				}
				loser_man = loser_man << 3;
				loser_man = loser_man >> exp_dif;
				loser_man = loser_man | (G << 2) | (R << 1) | S;
				if(sign(winer)==sign(loser)){
						answer_man = winer_man + loser_man;
						if(bit_n(answer_man,27) == 1){
								answer_exp = answer_exp + 1;
								S = bit_n(answer_man,0);
								answer_man = answer_man >> 1;
								answer_man = answer_man | S;
								ulp = bit_n(answer_man,3);
								G   = bit_n(answer_man,2);
								R   = bit_n(answer_man,1);
								S   = bit_n(answer_man,0);
								answer_man = answer_man >> 3;
								answer_man = answer_man + (G & (ulp | R | S));
								answer_man = answer_man & 0x007fffff;
								return (answer_sign << 31) | (answer_exp << 23) | answer_man;
						}else{
							    ulp = bit_n(answer_man,3);
								G   = bit_n(answer_man,2);
								R   = bit_n(answer_man,1);
								S   = bit_n(answer_man,0);
								answer_man = answer_man >> 3;
								answer_man = answer_man + (G & (ulp | R | S));
								if(bit_n(answer_man,24) == 1){
										answer_exp = answer_exp + 1;
										ulp = bit_n(answer_man,1);
										G   = bit_n(answer_man,0);
										answer_man = answer_man >> 1;
										answer_man = answer_man + (G & ulp);
										answer_man = answer_man & 0x007fffff;
										return (answer_sign << 31) | (answer_exp << 23) | answer_man;
								}else{
										answer_man = answer_man & 0x007fffff;
										return (answer_sign << 31) | (answer_exp << 23) | answer_man;
								}
						}
				}else{
						loser_man = ~ loser_man;
						answer_man = winer_man + loser_man + 1;
						i=ZLC(answer_man,26,0);
						if(answer_exp > i){
								answer_exp = answer_exp - i;
								answer_man = answer_man << i;
								answer_man = answer_man & 0x03ffffff;
								ulp = bit_n(answer_man,3);
								G   = bit_n(answer_man,2);
								R   = bit_n(answer_man,1);
								S   = bit_n(answer_man,0);
								answer_man = answer_man >> 3;
								answer_man = answer_man + (G & (ulp | R | S));
								return (answer_sign << 31) | (answer_exp << 23) | answer_man;
						}else{
								answer_man = answer_man << (answer_exp - 1);
								answer_man = answer_man >> 3;
								answer_exp = 0;
								return (answer_sign << 31) | (answer_exp << 23) | answer_man;
						}
	
				}
		}else if(sign(a)!=sign(b) && (a<<1)==(b<<1)){
				return 0;
		}else{
				if(exponent(a) > exponent(b)){
						winer = a;
						loser = b;
				}else if(exponent(a) < exponent(b)){
						winer = b;
						loser = a;
				}else{
						if(mantissa(a) >= mantissa(b)){
								winer = a;
								loser = b;
						}else{
								winer = b;
								loser = a;
						}
				}

				exp_dif = exponent(winer) - exponent(loser);
				if(exp_dif >= 27){
						exp_dif = 27;
				}
				answer_sign = sign(winer);
				answer_exp  = exponent(winer);

				if(sign(winer)==sign(loser)){
						winer_man = mantissa(winer);
						winer_man = winer_man | 0x00800000;
						winer_man = winer_man << 3;
						loser_man = mantissa(loser);
						loser_man = loser_man | 0x00800000;
						ulp = bit_n(loser_man,exp_dif);
						G   = bit_n(loser_man,exp_dif-1);
						R   = bit_n(loser_man,exp_dif-2);
						S   = 0;
						if(exp_dif>=3){
								for(i=0;i<=exp_dif-3;i++){
										S = S | bit_n(loser_man,i);
								}
						}
						loser_man = loser_man << 3;
						loser_man = loser_man >> exp_dif;
						loser_man = loser_man | (G << 2) | (R << 1) | S;
						answer_man = winer_man + loser_man;
						if(bit_n(answer_man,27) == 1){
								answer_exp = answer_exp + 1;
								S = bit_n(answer_man,0);
								answer_man = answer_man >> 1;
								answer_man = answer_man | S;
								if(answer_exp == 255){
										return (answer_sign << 31) | 0x7f800000;
								}else{
									    ulp = bit_n(answer_man,3);
										G   = bit_n(answer_man,2);
										R   = bit_n(answer_man,1);
										S   = bit_n(answer_man,0);
										answer_man = answer_man >> 3;
										answer_man = answer_man + (G & (ulp | R | S));
										if(bit_n(answer_man,24) == 1){
												answer_exp = answer_exp + 1;
												ulp = bit_n(answer_man,1);
												G   = bit_n(answer_man,0);
												answer_man = answer_man >> 1; 
												answer_man = answer_man + (G & ulp);
												if(answer_exp == 255){
														return (answer_sign << 31) | 0x7f800000;
												}else{
														return (answer_sign << 31) | (answer_exp << 23) | answer_man;
												}
										}else{
												answer_man = answer_man & 0x007fffff;
												return (answer_sign << 31) | (answer_exp << 23) | answer_man;
										}
								}
						}else{
								ulp = bit_n(answer_man,3);
								G   = bit_n(answer_man,2);
								R   = bit_n(answer_man,1);
								S   = bit_n(answer_man,0);
								answer_man = answer_man >> 3;
								answer_man = answer_man + (G & (ulp | R | S));
								if(bit_n(answer_man,24) == 1){
										answer_exp = answer_exp + 1;
										ulp = bit_n(answer_man,1);
										G   = bit_n(answer_man,0);
										answer_man = answer_man >> 1;
										answer_man = answer_man + (G & ulp);
										if(answer_exp == 255){
												return (answer_sign << 31) | 0x7f800000;
										}else{
												return (answer_sign << 31) | (answer_exp << 23) | answer_man;
										}
								}else{
										answer_man = answer_man & 0x007fffff;
										return (answer_sign << 31) | (answer_exp << 23) | answer_man;
								}
						}
				}else{
						winer_man = mantissa(winer);
						loser_man = mantissa(loser);
						ulp = bit_n(loser_man,exp_dif);
						G   = bit_n(loser_man,exp_dif-1);
						R   = bit_n(loser_man,exp_dif-2);
						S   = 0;
						if(exp_dif>=3){
								for(i=0;i<exp_dif-3;i++){
										S = S | bit_n(loser_man,i);
								}
						}
						loser_man = loser_man | 0x00800000;
						loser_man = loser_man << 3;
						loser_man = loser_man >> exp_dif;
						loser_man = loser_man | (G << 2) | (R << 1) | S;
						loser_man = (~ loser_man);
						winer_man = winer_man | 0x00800000;
						winer_man = winer_man << 3;
						answer_man = winer_man + loser_man + 1;
						
						ulp = bit_n(answer_man,3);
    					G   = bit_n(answer_man,2);
						R   = bit_n(answer_man,1);
						S   = bit_n(answer_man,0);

						i = ZLC(answer_man, 26, 0);
						if(answer_exp > i){
								answer_exp = answer_exp - i;
								answer_man = answer_man << i;
								answer_man = answer_man & 0x03ffffff;
								ulp = bit_n(answer_man,3);
								G   = bit_n(answer_man,2);
								R   = bit_n(answer_man,1);
								S   = bit_n(answer_man,0);
								answer_man = answer_man >> 3;
								answer_man = answer_man + (G & (ulp | R | S));
								return (answer_sign << 31) | (answer_exp << 23) | answer_man;
						}else{
								answer_man = answer_man << (answer_exp - 1);
								answer_man = answer_man >> 3;
								answer_exp = 0;
								return (answer_sign << 31) | (answer_exp << 23) | answer_man;
						}
				}
		}
}

