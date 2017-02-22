let rec sum_to n =
        if n = 0 then
				0
		else
				n + sum_to (n - 1)

let is_prime n =
		let rec is_prime_sub  m = (* nが2以上m以下の自然数で割り切れる場合はfalseを返し、そうでない場合はtrueを返す関数 *)
		        if m = 1 then
						true
				else if n mod m = 0 then
						false
				else
						is_prime_sub  (m-1)
		in is_prime_sub (n-1)

let rec gcd m n =
        if m > n then
				if n = 0 then
						m
				else
						gcd n (m mod n)
		else
				gcd n m

