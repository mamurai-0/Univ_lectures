type 'a m = 'a list

let (>>=) (x : 'a m) (f : 'a -> 'b m) =
	List.concat (List.map f x)

let return (x : 'a) = [x]

let guard (x : bool) =
	if x then return () else []

let t = [0; 1; 2; 3; 4; 5; 6; 7; 8; 9]

let find_banana =
	t >>= (fun ba ->
	t >>= (fun na ->
	t >>= (fun si ->
	t >>= (fun mo ->
	t >>= (fun n  ->
	(guard (100*ba + 10*na + na + 
			100*ba + 10*na + na
			= 1000*si + 100*na + 10*mo + n) >>= (fun _ ->
	return (ba, na, si, mo, n))))))))

let find_money =
	t >>= (fun s ->
	t >>= (fun e ->
	t >>= (fun n ->	
	t >>= (fun d ->	
	t >>= (fun m ->	
	t >>= (fun o ->	
	t >>= (fun r ->	
	t >>= (fun y ->
	(guard (1000*s + 100*e + 10*n + d
			+ 1000*m + 100*o + 10*r + e
			= 10000*m + 1000*o + 100*n + 10*e + y) >>= (fun _ ->
	return (s, e, n, d, m, o, r, y)))))))))))

let rec test_b f_banana =
	match f_banana with
	|[] -> true
	|(ba, na, si, mo, n) :: l ->
		if (100*ba + 10*na + na + 
			100*ba + 10*na + na
			= 1000*si + 100*na + 10*mo + n) then test_b l else false

let rec test_m f_money =
	match f_money with
	|[] -> true
	|(s, e, n, d, m, o, r, y) :: l ->
		if (1000*s + 100*e + 10*n + d
			+ 1000*m + 100*o + 10*r + e
			= 10000*m + 1000*o + 100*n + 10*e + y) then test_m l else false
