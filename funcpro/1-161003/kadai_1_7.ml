let rec length a = (* リストaの長さを返す関数 *)
        match a with			
		|[] -> 0
		|y :: ys -> 1 + (length ys)
let add_position a n x = (* リストaのn番目に要素xを挿入する関数 *)
        let rec add_position_rec a n x accum =
		        match a with
				|[] -> accum @ [x]
				|y :: ys ->
				        if (length accum) = (n-1) then
								accum @ (x :: a)
						else
								add_position_rec ys n x (accum @ [y]) 
        in add_position_rec a n x []
let add_loop a x = (* リストaの何番目かにxを挿入したすべての場合を考え、それらのリストを返す関数。詳細な動作はレポート本文参照 *)
        let rec add_loop_rec a x accum accum_length =
		        if accum_length = ((length a) + 1) then
						accum
				else
						add_loop_rec a x ((add_position a (accum_length + 1) x) :: accum) (accum_length + 1)
        in add_loop_rec a x [] 0
let accum_improve a x = (* aの要素（リスト）に要素xを挿入してできるリスト全体のリストを返す関数。返り値用の変数accumの更新関数である。この動作もレポート本文参照 *)
        let rec accum_improve_rec a x accum =
		        match a with
				|[] -> accum
				|y :: ys -> accum_improve_rec ys x (accum @ (add_loop y x))
		in accum_improve_rec a x []
let perm l =
		let rec perm_rec l accum =
		        match l with
				|[] -> accum
				|y :: ys ->
				        match accum with
                        |[] -> perm_rec ys [[y]]
						|z :: zs -> perm_rec ys (accum_improve accum y)
        in perm_rec l []
