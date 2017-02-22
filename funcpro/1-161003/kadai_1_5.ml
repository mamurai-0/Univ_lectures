let append a b =
        let rec reverse l m = (* リストlを逆順にリストmに付け加えて、mを返す関数 *)
	           match l with
			   | [] -> m
			   | y :: ys -> reverse ys (y :: m)
        in reverse (reverse a []) b

let filter f l =
        let rec filter_rec f l accum = (* accumは呼び出すたびに更新される返り値用の変数 *)
		        match l with
				| [] -> accum (* lが空ならば、これ以上更新の必要がないのでaccumを返す *)
				| y :: ys ->  (* yが判定条件を満たすなら、accumに付け加えて再帰呼び出しをする *)
				        if f y then
								filter_rec f ys (y :: accum)
						else
								filter_rec f ys accum
		in filter_rec f l []
       

