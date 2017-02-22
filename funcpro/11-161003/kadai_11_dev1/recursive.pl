/*Natural Number*/
nat(z).
nat(s(X)) :- nat(X).

/*Base case*/
zero(z).

succ(z,s(z)).
succ(s(X),s(s(X))) :- succ(X,s(X)).

proj([X, XL], J, X) :- length([X, XL], J).

/*Step case*/
func(F, X, Y) :- 関数Fに引数Xを与えた結果がYという述語

/*composition*/
comp(G, G1, .. , Gn, XL, Y) :- func(G1, XL, Y1), .. ,func(Gn, XL, Yn), func(G, [Y1,..,Yn], Y).

/*primitive recursion*/
rec(F, XL, G, H, 0, Z) :- func(G, XL, Z).
rec(F, XL, G, H, s(Y), Z) :- rec(F, XL, G, H, Y, W), func(H, [Y, W, XL], Z).

/*minimization*/
min(F, G, XL, 0, Y) :- func(G, [0, XL], Y), eq_zero(Y).
min(F, G, XL, s(Z), Y) :- func(G, [s(Z), XL], W), not_eq_zero(W), func(G, [Z, XL], Y), eq_zero(Y).
