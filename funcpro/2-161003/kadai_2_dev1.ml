type 'a fix_type = Fix of ('a fix_type -> 'a)
let fix f = 
        let p (Fix g) x =
		        f (g (Fix g)) x
		in p (Fix p)
