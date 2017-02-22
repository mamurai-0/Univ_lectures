module type SEMIRING =
sig
	type t
	val add : t -> t -> t
	val mul : t -> t -> t
	val unit : t
	val zero : t
end

module type VECTOR_MATRIX =
	functor(R : SEMIRING) ->
		sig
			type t_v
			val unit_v    : int -> int -> t_v
			val zero_v    : int -> t_v
			val make_v    : R.t list -> t_v
			val add_v     : t_v -> t_v -> t_v
		    val con_mul_v : R.t -> t_v -> t_v	(*スカラー倍*)
			val vec_mul_v : t_v -> t_v -> R.t (*内積*)
			val print_v   : t_v -> R.t list (*t = int　に対する表示関数をデバッグのために用意しました。*)
			type t_m
			val unit_m      : int -> t_m
			val zero_m      : int -> int -> t_m
			val make_m      : R.t list list -> t_m
			val add_m       : t_m -> t_m -> t_m
			val con_mul_m   : R.t -> t_m -> t_m (*スカラー倍*)
			val trans_m     : t_m -> t_m (*転値を返す*)
			val mat_mul_m   : t_m -> t_m -> t_m (*行列の積*)
			val vec_mul_m   : t_m -> t_v -> t_v
			val print_m     : t_m -> R.t list list  (*vectorと同様です。*)
		end

module SemiringInt =
struct
	type t = int
	let add x y = x + y
	let mul x y = x * y
	let unit = 1
	let zero = 0
end

module Vector_Matrix : VECTOR_MATRIX =
	functor (R : SEMIRING) ->
	struct
		type t_v = R.t list
		exception Cannot_compute
		let rec zero_v n =
			if n = 0 then
					[]
			else
					R.zero :: (zero_v (n - 1))
		let rec unit_v n i =
			if i = 1 then
					R.unit :: (zero_v (n - i))
			else
					R.zero :: unit_v (n - 1) (i - 1)
		let make_v l = l
		let rec add_v vx vy =
			match vx with
			|[] ->
				(match vy with
				|[] -> []
				|y :: ys -> raise Cannot_compute)
			|x :: xs ->
				(match vy with
				|[] -> raise Cannot_compute
				|y :: ys -> (R.add x y) :: (add_v xs ys))
		let rec con_mul_v k vx =
			match vx with
			|[] -> []
			|x :: xs -> (R.mul k x) :: (con_mul_v k xs)
		let rec vec_mul_v vx vy =
			match vx with
			|[] ->
				(match vy with
				|[] -> R.zero
				|y :: ys -> raise Cannot_compute)
			|x :: xs ->
				(match vy with
				|[] -> raise Cannot_compute
				|y :: ys -> (R.add (R.mul x y) (vec_mul_v xs ys)))
		let rec print_v_sub vx accum =
			match vx with
			|[] -> accum
			|x :: xs -> print_v_sub xs (accum @ [x])
		let print_v vx = print_v_sub vx []
		type t_m = R.t list  list
		let rec unit_sub_m n accum =
			if accum = n then
					[unit_v n n]
			else
					(unit_v n accum) :: (unit_sub_m n (accum + 1))
		let unit_m n = unit_sub_m n 1
		let rec zero_sub_m n m accum =
			if accum = n then
					[zero_v m]
			else
					(zero_v m) :: (zero_sub_m n m (accum + 1))
		let zero_m n m = zero_sub_m n m 1
		let make_m ll = ll
		let rec add_m mx my =
			match mx with
			|[] ->
				(match my with
				|[] -> []
				|vy :: vys -> raise Cannot_compute)
			|vx :: vxs ->
				(match my with
				|[] -> raise Cannot_compute
				|vy :: vys -> (add_v vx vy) :: (add_m vxs vys))
		let rec con_mul_m k mx =
			match mx with
			|[] -> []
			|vx :: vxs -> (con_mul_v k vx) :: (con_mul_m k vxs)
		let rec append_num_sub ll x i accum =
			if accum = i then
					(match ll with
					|[] -> [[x]]
					|vx :: vxs -> (vx @ [x]) :: vxs)
			else
					(match ll with
					|[] -> raise Cannot_compute
					|vx :: vxs -> vx :: (append_num_sub vxs x i (accum + 1)))
		let append_num ll x i = append_num_sub ll x i 1
		let rec trans_sub mx accum1 accum2 =
			match mx with
			|[] -> accum1
			|vx :: vxs ->
				(match vx with
				|[] -> trans_sub vxs accum1 1
				|x :: xs -> trans_sub (xs :: vxs) (append_num accum1 x accum2) (accum2 + 1))
		let trans_m mx = trans_sub mx [] 1
		let rec mat_mul_sub vx my =
			match my with
			|[] -> []
			|vy :: vys -> (vec_mul_v vx vy) :: mat_mul_sub vx vys
		let rec mat_mul_m mx my =
			match mx with
			|[] -> []
			|vx :: vxs -> (mat_mul_sub vx (trans_m my)) :: (mat_mul_m vxs my)
		let vec_mul_m mx vy = mat_mul_sub vy mx
		let rec print_m_sub mx accum = 
			match mx with
			|[] -> accum
			|vx :: vxs -> print_m_sub vxs (accum @ [print_v vx])
		let print_m mx = print_m_sub mx []
	end

module M = Vector_Matrix (SemiringInt)

module SemiringBoolean =
struct
	type t = T | F
	let add x y =
		match x with
		|T -> T
		|F ->
			(match y with
			|T -> T
			|F -> F)
	let mul x y =
		match x with
		|T -> 
			(match y with
			|T -> T
			|F -> F)
		|F -> F
	let unit = T
	let zero = F
end

module SemiringIntInf =
struct
	type t = Int of int | INF
	let add x y =
		match x with
		|Int i ->
			(match y with
			|Int j -> Int(min i j)
			|INF -> x)
		|INF -> y
	let mul x y =
		match x with
		|Int i ->
			(match y with
			|Int j -> Int(i + j)
			|INF -> INF)
		|INF -> INF
	let unit = Int(0)
	let zero = INF
end

module M_b = Vector_Matrix (SemiringBoolean)
module M_i = Vector_Matrix (SemiringIntInf)
