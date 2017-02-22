let twice f x = f (f x) (* fにxを適用した結果をさらにfに適用している *)

let rec repeat f n x =
        if n = 1 then
				f x
		else
				f (repeat f (n-1) x)

