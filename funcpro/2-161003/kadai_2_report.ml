05_161003
今村秀明

(Q1)
# #use "kadai_2_1.ml";;
type nat = Z | S of nat
val add : nat -> nat -> nat = <fun>
val sub : nat -> nat -> nat = <fun>
val mul : nat -> nat -> nat = <fun>
val pow : nat -> nat -> nat = <fun>
val n2i : nat -> int = <fun>
val i2n : int -> nat = <fun>
# n2i(Z);;
- : int = 0
# n2i(S (S (S (Z))));;
- : int = 3
# i2n(5);;
- : nat = S (S (S (S (S Z))))
# add (i2n 5) (i2n 3);;
- : nat = S (S (S (S (S (S (S (S Z)))))))
# n2i (add (i2n 5) (i2n 3));;
- : int = 8
# n2i (sub (i2n 5) (i2n 3));;
- : int = 2
# n2i (sub (i2n 1) (i2n 3));;
- : int = 0
# n2i (mul (i2n 5) (i2n 3));;
- : int = 15
# n2i (pow (i2n 5) (i2n 3));;
	   - : int = 125

(Q2)
#use "kadai_2_2.ml";;
type 'a tree = Leaf | Node of 'a * 'a tree * 'a tree
val pre_order : 'a tree -> 'a list = <fun>
val in_order : 'a tree -> 'a list = <fun>
val post_order : 'a tree -> 'a list = <fun>
# let t = Node (1, (Node (2, (Node (3, Leaf, Leaf)), (Node (4, Leaf, Leaf)))), (Node (5, (Node (6, Leaf, Leaf)), (Node (7, Leaf, Leaf)))));;
val t : int tree =
  Node (1, Node (2, Node (3, Leaf, Leaf), Node (4, Leaf, Leaf)),
     Node (5, Node (6, Leaf, Leaf), Node (7, Leaf, Leaf)))
# pre_order t;;
- : int list = [1; 2; 3; 4; 5; 6; 7]
# in_order t;;
- : int list = [3; 2; 4; 1; 6; 5; 7]
# post_order t;;
- : int list = [3; 4; 2; 6; 7; 5; 1]
考察：

(Q3)
# #use "kadai_2_3.ml";;
type 'a tree = Leaf | Node of 'a * 'a tree * 'a tree
val merge : 'a list list -> 'a list list -> 'a list list = <fun>
val smooth : 'a list list -> 'a list = <fun>
val level_order_sub : 'a tree -> 'a list list = <fun>
val level_order : 'a tree -> 'a list = <fun>
# let t = Node (1, (Node (2, (Node (3, Leaf, Leaf)), (Node (4, Leaf, Leaf)))), (Node (5, (Node (6, Leaf, Leaf)), (Node (7, Leaf, Leaf)))));;
val t : int tree =
  Node (1, Node (2, Node (3, Leaf, Leaf), Node (4, Leaf, Leaf)),
     Node (5, Node (6, Leaf, Leaf), Node (7, Leaf, Leaf)))
# level_order t;;
  - : int list = [1; 2; 5; 3; 4; 6; 7]

(Q4)
# #use "kadai_2_4.ml";;
type expr =
    EConstInt of int
	| EAdd of expr * expr
	| ESub of expr * expr
	| EMul of expr * expr
	| EDiv of expr * expr
	| EConstbool of bool
	| EEq of expr * expr
	| EInEq of expr * expr
	| EIf of expr * expr * expr
type value = VInt of int | VBool of bool

(Q5)
# #use "kadai_2_5.ml";;
exception Eval_error
val v2i : value -> int = <fun>
val v2b : value -> bool = <fun>
val eval : expr -> value = <fun>
# let e = EAdd(EConstInt(1), EConstBool(true));;
val e : expr = EAdd (EConstInt 1, EConstBool true)
# eval e;;
Exception: Eval_error.
# let e = EConstInt(5);;
val e : expr = EConstInt 5
# eval e;;
- : value = VInt 5
# let e = EAdd(EConstInt(5), EConstInt(2));;
val e : expr = EAdd (EConstInt 5, EConstInt 2)
# eval e;;
- : value = VInt 7
# let e = ESub(EConstInt(5), EConstInt(2));;
val e : expr = ESub (EConstInt 5, EConstInt 2)
# eval e;;
- : value = VInt 3
# let e = EMul(EConstInt(5), EConstInt(2));;
val e : expr = EMul (EConstInt 5, EConstInt 2)
# eval e;;
- : value = VInt 10
# let e = EDiv(EConstInt(5), EConstInt(2));;
val e : expr = EDiv (EConstInt 5, EConstInt 2)
# eval e;;
- : value = VInt 2
# let e = EConstBool(true);;
val e : expr = EConstBool true
# eval e;;
- : value = VBool true
# let e = EEq(EConstInt(5), EConstInt(2));;
val e : expr = EEq (EConstInt 5, EConstInt 2)
# eval e;;
- : value = VBool false
# let e = EInEq(EConstInt(5), EConstInt(2));;
val e : expr = EInEq (EConstInt 5, EConstInt 2)
# eval e;;
- : value = VBool false
# let e = EIf(EConstBool(true), EConstInt(5), EConstInt(2));;
val e : expr = EIf (EConstBool true, EConstInt 5, EConstInt 2)
# eval e;;
- : value = VInt 5

(Dev1)
# #use "kadai_2_dev1.ml";;
type 'a fix_type = Fix of ('a fix_type -> 'a)
val fix : (('a -> 'b) -> 'a -> 'b) -> 'a -> 'b = <fun>
# let sum_to n =
          let sum_fix sum x =
		            if x = 0 then 0 else x + sum(x-1)
		  in (fix sum_fix) n;;
val sum_to : int -> int = <fun>
# sum_to 10;;
- : int = 55

(Dev2)
# #use "kadai_2_dev2.ml";;
type false_t = { t : 'a. 'a; }
type 'a not_t = 'a -> false_t
type ('a, 'b) and_t = 'a * 'b
type ('a, 'b) or_t = L of 'a | R of 'b
val q1 : ('a -> 'b) -> ('b -> 'c) -> 'a -> 'c = <fun>
val q2 : ('a, 'b * 'c) or_t -> ('a, 'b) or_t * ('a, 'c) or_t = <fun>
val q3 : ('a, 'b) or_t * ('a, 'c) or_t -> ('a, 'b * 'c) or_t = <fun>
val callcc : (('a -> false_t) -> 'a) -> 'a = <fun>
val q4 : ('a -> 'b) -> (('a -> false_t) -> 'b) -> 'b = <fun>
val q6 : (('a -> 'b) -> 'a) -> 'a = <fun>
考察：５つ目に関しては、証明可能だと仮定すると任意の命題が矛盾することになってしまうので証明可能たりえない。

(Dev3)
# #use "kadai_2_dev3.ml";;
val curry : ('a * 'b -> 'c) -> 'a -> 'b -> 'c = <fun>
val uncurry : ('a -> 'b -> 'c) -> 'a * 'b -> 'c = <fun>
val a : int ref = {contents = 0}
val f : 'a -> 'b -> int = <fun>
val h : (int -> int -> 'a) -> 'a = <fun>
# h (curry (uncurry f)) <> h f;;
- : bool = true

