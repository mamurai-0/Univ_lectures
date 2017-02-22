let rec fold_right f l e =
        match l with
		| [] -> e
		| y :: ys -> f y (fold_right f ys e)

let fold_left f e l =
        let rec  fold_left_accum f accum l =
		        match l with
				| [] -> accum
				| y :: ys -> (fold_left_accum f (f accum y) ys)
		in fold_left_accum f e l

let append_left a b =
        let rec add a x = (* リストaの最後尾にxを付け加える関数 *)
		        a @ [x]
		in fold_left add a b

let filter_left f l =
        let decision ans x = (* x が判定条件を満たすならansの最後尾にx付け加える関数 *)
		        if f x then
						ans @  [x]
				else
						ans
		in fold_left decision [] l

let append_right a b =
        let cons x a = x :: a
        in fold_right cons a b

let filter_right f l =
        let decision x ans =
		        if f x then
					    x :: ans
				else
						ans
		in fold_right decision l []

let time_measure f a b = (* 関数fにa,bを適用した際の実行時間を表示する *)
        (f a b; Unix.gettimeofday()) -. Unix.gettimeofday()
		
let rec make_long_list n = if n = 1 then [1] else 1 :: make_long_list (n-1) (* 長さnで要素がすべて1のリストを作る *)

