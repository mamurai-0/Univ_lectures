/*AI¤À¤è*/

end(P, [P, P, P, _, _, _, _, _, _]).
end(P, [_, _, _, P, P, P, _, _, _]).
end(P, [_, _, _, _, _, _, P, P, P]).
end(P, [P, _, _, P, _, _, P, _, _]).
end(P, [_, P, _, _, P, _, _, P, _]).
end(P, [_, _, P, _, _, P, _, _, P]).
end(P, [P, _, _, _, P, _, _, _, P]).
end(P, [_, _, P, _, P, _, P, _, _]).

next(P, [1|B], [1|C]) :- next(P, B, C).
next(P, [0|B], [0|C]) :- next(P, B, C).
next(P, [e|B], [e|C]) :- next(P, B, C).
next(P, [e|B], [P|C]) :- next_sub(B, C).
next_sub(B, B).

change(1, 0).
change(0, 1).

member(A, [A|_]).
member(A, [_|X]) :- member(A, X).

finish(B) :- end(1, B).
finish(B) :- end(0, B).
finish(B) :- \+ member(e, B).

win(P, B) :- end(P, B).
win(P, B) :- change(P, Q), \+ end(Q, B), next(P, B, C), lose(Q, C).

lose(P, B) :- change(P, Q), end(Q, B).
lose(P, B) :- \+ finish(B), change(P,Q), \+ lose_sub(P, B, Q).
lose_sub(P, B, Q) :- next(P, B, C), \+ win(Q, C).

