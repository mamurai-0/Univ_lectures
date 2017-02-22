let curry f x y = f (x, y)
let uncurry f (x, y) = f x y
let a = ref 0
let f x y = a := !a + 1; !a
let h f = f 1 2 
