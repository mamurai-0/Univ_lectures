let zero = fun f x -> x (*チャーチ数0を返す*)
let unchurch n = (*チャーチ数を受け取りそれを通常の整数にして返す*)
        let inc n = n+1
		in n inc 0 

let succ = fun n f x -> f (n f x) (*後者関数*)
let add = fun m n f x -> n f (m f x)
let mul = fun m n f -> n (m f)

let rec repeat f n x =if n <= 1 then f x else f (repeat f (n-1) x) (*繰り返し関数*)
let tru = fun t f -> t (*bool値true*)
let fls = fun t f -> f (*bool値false*)
let pair = fun f s b -> b f s (*ペアを返す*)
let fst = fun p -> p tru (*ペアの先頭を返す*)
let snd = fun p -> p fls (*ペアの後ろを返す*)
let zz = pair zero zero (* (0,0)なるペアを返す*)
let ss = fun p -> pair (snd p) (add (succ zero) (snd p)) (* ペアの両方の値にsuccを作用させる*)
let pred = fun m -> fst (repeat ss (unchurch m) zz) (* 前者関数 *)
let sub = fun m n -> repeat pred (unchurch n) m 

let c1 = succ zero
let c2 = succ c1
let c3 = succ c2
let c4 = succ c3
let c5 = succ c4

