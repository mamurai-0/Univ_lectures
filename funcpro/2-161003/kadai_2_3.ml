type 'a tree =
        | Leaf
		| Node of 'a * 'a tree * 'a tree

let rec merge l1 l2 = (* リストのリストl1. l2を受け取ってそれらの各要素を順にmergeしたリストのリストを返す*)
        match l1 with
		| [] -> l2
		| x1 :: x1s ->
		        match l2 with
				|[] -> l1
				|x2 :: x2s -> (x1 @ x2) :: (merge x1s x2s)

let rec smooth l =
        match l with
		| [] -> []
		| x :: xs -> x @ (smooth xs)
		 
let rec level_order_sub btree =
        match btree with
		| Leaf -> []
		| Node (a, t1, t2) -> [a] :: (merge (level_order_sub t1) (level_order_sub t2))

let level_order btree =
        smooth (level_order_sub btree)
