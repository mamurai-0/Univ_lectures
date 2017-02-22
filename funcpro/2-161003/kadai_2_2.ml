type 'a tree =
        |Leaf
		|Node of 'a * 'a tree * 'a tree

let rec pre_order btree =
        match btree with
		|Leaf -> []
		|Node (a, t1, t2) -> a :: ( (pre_order t1) @ (pre_order t2))

let rec in_order btree =
        match btree with
		|Leaf -> []
		|Node (a, t1, t2) -> (in_order t1) @ (a :: (in_order t2))

let rec post_order btree =
        match btree with
		|Leaf -> []
        |Node (a, t1, t2) -> (post_order t1) @ (post_order t2) @ [a]


