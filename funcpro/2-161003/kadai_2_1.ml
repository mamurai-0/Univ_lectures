type nat = Z | S of nat

let rec add n1 n2 =
        match n1 with
		|Z -> n2
		|S (nat) -> add nat (S (n2))

let rec sub n1 n2 =
        match n1 with
		|Z -> Z
		|S (nat1) -> 
		        match n2 with
				|Z -> n1
				|S (nat2) -> sub nat1 nat2

let rec mul n1 n2 =
        match n2 with
		|Z -> Z
		|S (nat) -> add n1 (mul n1 nat)

let rec pow n1 n2 =
        match n2 with
		|Z -> S (Z)
		|S (nat) -> mul n1 (pow n1 nat)

let rec n2i n =
        match n with
		|Z -> 0
		|S (nat) -> 1 + (n2i nat)

let rec i2n i =
        match i with
		|0 -> Z
		|_ -> S (i2n (i-1))
