let rec fold_right f l e =
        match l with
		| [] -> e
		| y :: ys -> f y (fold_right f ys e)

let fold_left f e l =
        let rec fold_left_accum f accum l = 
		        match l with
				| [] -> accum 
				| y :: ys -> (fold_left_accum f (f accum y) ys)
		in fold_left_accum f e l

let reverse l =
        let rec reverse_sub l accum =
		        match l with
				| [] -> accum
				| y :: ys -> reverse_sub ys (y :: accum)
		in reverse_sub l []

let f_tilde f x y = f y x (* fの変数の順序を入れ替えた関数 *)

let fold_left_with_right f e l = fold_right (f_tilde f) (reverse l) e

let fold_right_with_left f l e = fold_left (f_tilde f) e (reverse l)

