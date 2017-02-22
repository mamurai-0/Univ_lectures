let rec fix f x = f (fix f) x

(* 動作は問い1と共通だが、それぞれにおいて functionname_fixという関数を定義している。これは、fixに適用することで再起処理を実現する *)
let sum_to n =
        let sum_to_fix sum x =
		        if x = 0 then
						0
				else
						x + sum (x-1)
		in (fix sum_to_fix) n

let is_prime n =
        let is_prime_fix prime n m =
		        if m=1 then
						true
				else if n mod m = 0 then
						false
				else
						prime n (m-1)
		in (fix is_prime_fix) n (n-1)

let gcd m n =
        let gcd_fix gcd_sub m n =
		        if m > n then
						if n=0 then
								m
						else
								gcd_sub n (m mod n)
				else
						gcd_sub n m
		in (fix gcd_fix) m n


