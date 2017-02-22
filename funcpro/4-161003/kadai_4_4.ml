type 'a m = (int * int) list -> 'a * ((int * int) list)

type 'a option = Just of int | Nothing

let (>>=) :  'a m -> ('a -> 'b m) -> 'b m =
	fun x f ->
	fun init ->
		match x init with
		|(p, s1) -> (f p) s1

let return : 'a -> 'a m = 
	fun x ->
	fun init -> (x, init)

let rec search x init =
	match init with
	|[] -> Nothing
	|(y, v) :: ys -> if y = x then Just v else search x ys

let memo : (int -> int m) -> int -> int m  =
	fun f x ->
	fun init ->
		match search x init with
		| Just v -> (v, init)
		| Nothing -> let (v, s1) = (f x) init
					in (v, ((x, v) :: s1))

let runMemo (x : 'a m) =
	match x [] with
	|(value, lis) -> value

let rec fib n =
	if n <= 1 then 
			return n
	else
			(memo fib (n-2)) >>= (fun r1 ->
			(memo fib (n-1)) >>= (fun r2 ->
				return (r1 + r2)))
;;
runMemo (fib 10)
;;
runMemo (fib 80)
