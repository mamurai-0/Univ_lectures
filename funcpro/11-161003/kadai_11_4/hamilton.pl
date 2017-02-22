/*A is member of X. ex) A is vartex, X is path. A is edge, X is edges*/
incident(A, [A|_]).
incident(A, [_|X]) :- incident(A, X).

/*A is not member of X*/
not_incident(_, [], _).
not_incident(A, [B|X], Y) :- not_incident(A, X, Y), not_eq(A, B, Y).

not_eq(A, B, Y) :- incident([A,B], Y).

/*X is different pair of V ex) V = [1,2,3], then X = [[1,2],[1,3],[2,3]]*/
pow([], []).
pow([A|V], X) :- pow(V, Y), pair(A, V, Z), append(Z, Y, X).

pair(_, [], []).
pair(A, [B|V], [[A,B]|X]) :- pair(A, V, X).

append([], Y, Y).
append([A|X], Y, [A|Z]) :- append(X, Y, Z).

/*P is path from node A to node Z in graph G = (V, E)*/
path(A, Z, V, E, P, X) :- path_sub(A, [Z], V, E, P, X).

/*P is path from node A to the beginning of path P_sub in graph G = (V, E)*/
path_sub(A, [A|P_sub], _, _, [A|P_sub], _).
path_sub(A, [B|P_sub], V, E, P, X) :- incident([C, B], E), not_incident(C, P_sub, X), path_sub(A, [C, B|P_sub], V, E, P, X).

/*Nodes of Path P is equal to V*/
equal(P, V) :- equal_sub(P, V), equal_sub(V, P).
equal_sub([], _).
equal_sub([A|X], Y) :- incident(A, Y), equal_sub(X, Y).

/*Graph G = (V,E) has hamilton cycle*/
hamilton(V, E) :- pow(V, X), path(_, _, V, E, P, X), equal(P,V).
