let rec fold_right f l e =
        match l with
		| [] -> e
		| y :: ys -> f y (fold_right f ys e)

let fold_left f e l =
        let rec fold_left_accum f accum l = (* 関数を呼ぶごとにaccumの値を更新していく *)
		        match l with
				| [] -> accum (* lが空なら、これ以上更新できないのでaccumを返す *)
				| y :: ys -> (fold_left_accum f (f accum y) ys) (* accumを更新して、再帰呼び出しをする *)
		in fold_left_accum f e l
