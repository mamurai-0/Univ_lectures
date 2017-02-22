module type STACK_TYPE =
	sig
		type typ
	end

module type STACK =
	functor(T : STACK_TYPE) ->
		sig
			type t
			val pop   : t -> (T.typ * t)
			val push  : T.typ -> t -> t
			val empty : t
			val size  : t -> int
		end

module Stack : STACK =
	functor(T : STACK_TYPE) -> struct
		type t = T.typ list
		exception No_element
		let pop xs =
			match xs with
			|[] -> raise No_element
			|y :: ys -> (y, ys)
		let push a xs = a :: xs
		let empty = []
		let rec size_sub xs accum =
			match xs with
			|[] -> accum
			|y :: ys -> size_sub ys (accum + 1)
		let size xs = size_sub xs 0
	end

module IntType =
struct
	type typ = int
end

module StackInt = Stack(IntType)
