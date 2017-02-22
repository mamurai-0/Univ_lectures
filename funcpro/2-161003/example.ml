type complex = {re : float; im :float}

let prod {re = r1; im = i1} {re = r2; im = i2} =
        {re = r1 *. r2 -. i1 *. i2; im = r1 *. i2 +. r2 *. i1}

type str_tree =
        |Leaf
		|Node of string * str_tree * str_tree

type ib_list = Inil
             |ICons of int * bi_list
and  bi_list = BNil
             |BCons of bool * ib_list

type iexpr =
        | EConstInt of int
		| EAdd of iexpr * iexpr
		| ESub of iexpr * iexpr
		| EMul of iexpr * iexpr

let rec eval x =
        match x with
		| EConstInt(i) -> i
		| EAdd(y, z) -> (eval y) + (eval z)
		| ESub(y, z) -> (eval y) - (eval z)
		| EMul(y, z) -> (eval y) * (eval z)

let r = ref 0
let f x =
        let y = !r
		in (r := x); y
