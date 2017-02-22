#ifndef _HS_INTEGER_GMP_H_
#define _HS_INTEGER_GMP_H_

/* Whether GMP is embedded into integer-gmp */
#define GHC_GMP_INTREE     1

/* The following values denote the GMP version used during GHC build-time */
#define GHC_GMP_VERSION_MJ 5
#define GHC_GMP_VERSION_MI 0
#define GHC_GMP_VERSION_PL 4
#define GHC_GMP_VERSION \
    (5 * 10000 + 0 * 100 + 4)

#endif /* _HS_INTEGER_GMP_H_ */
