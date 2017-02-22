/*partial equivalence relation*/

eq_sub(a, b, _).
eq_sub(c, b, _).
eq_sub(X, Y, F) :- equal(F,z),eq_sub(Y, X, o).
eq_sub(X, Z, _) :- eq_sub(X, Y, z), eq_sub(Y, Z, z).

eq(X,Y) :- eq_sub(X, Y, z).

equal(X,X).
