type ('a, 'b) m = ('a -> 'b) -> 'b

let (>>=) : ('a, 'c) m -> ('a -> ('b, 'c) m) -> ('b, 'c) m =
	fun c f ->
	fun k ->
		c (fun t -> f t k)

let return : 'a -> ('a, 'c) m =
	fun t ->
	fun f ->
		f t

let callcc : (('a -> ('b, 'c) m) -> ('a, 'c) m) -> ('a, 'c) m =
	fun f k ->
		f (fun t x -> k t) k

let id x = x

let add x y = return (x + y)

let mul x y = return (x * y)

let add_square x y =
	add x y >>= (fun x ->
	mul x x >>= (fun y ->
	return y))

let rec fact n =
	match n with
	|1 -> return 1
	|_ -> fact (n-1) >>= (fun y ->
			return (y * n))

let rec flatt l =
	match l with
	|[] -> return []
	|[] :: xs -> (fun _ -> [])
	|x :: xs -> flatt xs >>= (fun y ->
			return (x @ y))

let bar1 monad = return 1
let bar2 monad = monad 2
let bar3 monad = return 3
let foo monad =
	bar1 monad >>= (fun x ->
	bar2 monad >>= (fun y ->
	bar3 monad))
let test_callcc = callcc (fun k -> foo k)

let flatt_callcc l =
	callcc (fun k -> 
		let rec flatt_sub l =
			match l with
			|[] -> return []
			|[] :: xs -> k []
			|x :: xs -> flatt_sub xs  >>= (fun y -> return (x @ y))
		in flatt_sub l)
