type order = LT | EQ | GT

module type ORDERED_TYPE =
sig
	type typ
	val compare : typ -> typ -> order
end

module type ASSOCIATIVE_BTREE =
	functor (T : ORDERED_TYPE) ->
	sig
		type t
		val empty : t
		val insert : T.typ -> T.typ -> t -> t
		val delete : T.typ -> t -> t
		val search : T.typ -> t -> T.typ * T.typ
	end

module Associative_btree : ASSOCIATIVE_BTREE =
	functor (T : ORDERED_TYPE) -> 
	struct
		type t =
			| Leaf
			| Node of T.typ * T.typ * t * t 
		let empty = Leaf
		let rec insert key value btree =
			match btree with
			| Leaf -> Node (key, value, empty, empty)
			| Node (a, b, left, right) ->
				match T.compare key a with
				| EQ -> Node (a, value, left, right)
				| LT -> Node (a, b, (insert key value left), right)
				| GT -> Node (a, b, left, (insert key value right))
		
		exception No_data
		let rec min_key btree =
			match btree with
			| Leaf -> raise No_data
			| Node (key, value, left, right) -> 
				match left with
				| Leaf -> key
				| _ -> min_key left
		let rec min_value btree =
			match btree with
			| Leaf -> raise No_data
			| Node (key, value, left, right) -> 
				match left with
				| Leaf -> value
				| _ -> min_key left
		let rec max_key btree =
			match btree with
			| Leaf -> raise No_data
			| Node (key, value, left, right) -> 
				match right with
				| Leaf -> key
				| _ -> max_key left
		let rec max_value btree =
			match btree with
			| Leaf -> raise No_data
			| Node (key, value, left, right) -> 
				match right with
				| Leaf -> value
				| _ -> max_value right
		let rec delete key btree =
			match btree with
			| Leaf -> btree
			| Node (a, _, left, right) ->
				(match T.compare key a with
				| EQ -> 
					(match left with
					| Leaf -> 
						(match right with
						| Leaf -> Leaf
						| _ -> Node ((min_key right), (min_value right), left, (delete (min_key right) right)))
					| Node (_, _, _, _) -> Node ((max_key left), (max_key left), (delete (max_key left) left), right))
				| LT -> delete key left
				| GT -> delete key right)
		let rec search key btree =
			match btree with
			| Leaf -> raise No_data
			| Node (a, b, left, right) ->
				match T.compare key a with
				| EQ -> (a, b)
				| LT -> search key left
				| GT -> search key right
	end

module OrderedInt =
struct
	type typ = int
	let compare x y =
		let r = Pervasives.compare x y in
			if r > 0 then GT
			else if r < 0 then LT 
			else EQ
end

module IntBtree =
	Associative_btree (OrderedInt) 
