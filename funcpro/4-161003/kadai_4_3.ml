type 'a m = 'a * string

let (>>=) (x : 'a m) (f : 'a -> 'b m) =
	match x with
	|(p, m1) ->
		(match f p with
		|(q, m2) -> (q, m1 ^ m2))

let return (x : 'a) = (x, "")

let writer (m : string) = ((), m)

let msg n = ("Fib(" ^ (string_of_int n) ^ ")\n")

let rec fib n =
	(writer (msg n)) >>= (fun _ ->
	if n <= 1 then
			return n
	else
			(fib (n-2)) >>= (fun x ->
			(fib (n-1)) >>= (fun y ->
			return (x + y))))

let _ =
	let (_, m) = fib 4 in
	print_string m
