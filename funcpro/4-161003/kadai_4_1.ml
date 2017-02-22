type 'a m = Ok of 'a | Err of string

let (>>=) x f =
	match x with
	| Ok(v) -> f v
	| Err msg -> Err msg

let return x = Ok x

let myDiv x y =
	if y = 0 then
			Err "Division by Zero"
	else
			return (x / y)

let rec eLookup key t =
	match t with
	|[] -> Err "Nothing"
	|(a, b) :: ts -> if key = a then return b
						        else eLookup key ts

let lookupDiv kx ky t =
	(eLookup kx t) >>= (fun x ->
	(eLookup ky t) >>= (fun y ->
	myDiv x y))


