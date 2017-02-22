type false_t = { t : 'a. 'a }
type 'a not_t = 'a -> false_t
type ('a, 'b) and_t = 'a * 'b
type ('a, 'b) or_t  = L of 'a | R of 'b

let q1 f g a  = g (f a)

let q2 x =
        let lemma_for_q2_1 p =
                match p with
		        |(a, b) -> (R(a), R(b))
        in let lemma_for_q2_2 a = (L(a), L(a))
		in match x with
		|L(a) -> lemma_for_q2_2 a
		|R(p) -> lemma_for_q2_1 p
		
let q3 x =
        let lemma_for_q3_1 x c =
                match x with
		        |(p, q) -> 
		                match p with
		                |L(a) -> L(a)
				        |R(b) -> R((b, c))
        in match x with
		|(p, q) ->
		        match q with
				|L(a) -> L(a)
				|R(c) -> lemma_for_q3_1 x c

let rec callcc
        : (('a -> false_t) -> 'a) -> 'a
		= fun f -> callcc f

let q4 p q =
        let lemma_for_q4_2 p nc a= nc (p a)
        in let lemma_for_q4_1 p q nc = q (lemma_for_q4_2 p nc)
        in callcc (lemma_for_q4_1 p q)

let q6 p =
        let rec f x = f x
        in let lemma_for_q6_2 na a = f (na a)
        in let lemma_for_q6_1 p na = f (na (p (lemma_for_q6_2 na)))
		in callcc (lemma_for_q6_1 p)





