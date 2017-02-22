let circle = fun r -> 3.14 *. r ** 2.0

let rec sigma f n  =
        if n = 0 then
			    f n
	    else
			    f n + sigma f (n-1)

let rec map f l =
        match l with
		| [] -> []
		| x :: xl -> f x :: map f xl

