let reverse l =
        let rec reverse_sub l accum =
		        match l with
				| [] -> accum
				| y :: ys -> reverse_sub ys (y :: accum)
		in reverse_sub l []

let rec fold_right f l e =
        match l with
		| [] -> e
		| y :: ys -> f y (fold_right f ys e)

