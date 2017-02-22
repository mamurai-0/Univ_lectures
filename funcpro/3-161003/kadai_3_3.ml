type order = LT | EQ | GT

module type ORDERED_TYPE = 
sig 
  type t
  val compare : t -> t -> order 
end

module type MULTISET2 = 
  functor (T : ORDERED_TYPE) -> 
    sig 
      type t 
      val empty : t 
      val add    : T.t -> t -> t 
      val remove : T.t -> t -> t 
      val count  : T.t -> t -> int 
    end 

module OrderedInt =
struct
	type t = int
	let compare x y =
	  let r = Pervasives.compare x y in
		if r > 0 then GT
		else if r < 0 then LT
		else EQ
end

module MyMultiset : MULTISET2 =
	functor(T : ORDERED_TYPE) -> struct
		type t = (T.t * int) list
		let empty = []
		let rec add a xs =
			match xs with
			|[] -> [(a, 1)]
			|(y, ny) :: ys -> 
				match T.compare a y with
				|EQ -> (y, (ny + 1)) :: ys
				|_  -> (y, ny) :: (add a ys)
		let rec remove a xs =
			match xs with
			|[] -> xs
			|(y, ny) :: ys ->
				match T.compare a y with
				|EQ -> if ny = 1 then ys
					   else (y, (ny - 1)) :: ys
				|_  -> (y, ny) :: (remove a ys)
		let rec count a xs =
			match xs with
			|[] -> 0
			|(y, ny) :: ys ->
				match T.compare a y with
				|EQ -> ny
				|_  -> count a ys
	end

module IntMultiset =
	MyMultiset(OrderedInt)


