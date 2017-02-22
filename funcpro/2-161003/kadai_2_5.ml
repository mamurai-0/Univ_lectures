exception Eval_error

let v2i x =(* VInt型のxを受け取って、int型にしたものを返す *)
        match x with
		| VInt(i)  -> i
		| VBool(b) -> raise Eval_error

let v2b x = (* VBool型のxを受け取って、bool型にしたものを返す *)
        match x with
		| VBool(b) -> b
		| VInt(i)  -> raise Eval_error

let rec eval x =    
        match x with
        | EConstInt(i)  -> VInt(i)
		| EAdd(y, z)    -> VInt((v2i (eval y)) + (v2i (eval z)))
        | ESub(y, z)    -> VInt((v2i (eval y)) - (v2i (eval z)))
        | EMul(y, z)    -> VInt((v2i (eval y)) * (v2i (eval z)))
        | EDiv(y, z)    -> VInt((v2i (eval y)) / (v2i (eval z)))
		| EConstBool(b) -> VBool(b)
		| EEq(y, z)     -> VBool((v2i (eval y)) = (v2i (eval z)))
		| EInEq(y, z)   -> VBool((v2i (eval y)) < (v2i (eval z)))
		| EIf(u, v, w)  -> if (v2b (eval u)) then (eval v) else (eval w)


