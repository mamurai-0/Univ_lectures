append([], Y, Y).
append([A|X], Y, [A|Z]) :- append(X, Y, Z).

reverse([], []).
reverse([A|X], Y) :- append(Z, [A], Y), reverse(X, Z).

concat([], []).
concat([A|X], Y) :- concat(X, Z), append(A, Z, Y).
