open Syntax

exception EvalErr of string
exception Unbound

type env = (name * value) list

let empty_env = []
let extend x v env = (x, v) :: env
let rec extend_closures closures env =
	let rec sub closures origin_closures env origin_env =
		(match closures with
		| [] -> env
		| (fi,xi,ei) :: closures' ->
			let i = List.length closures in
			sub closures' origin_closures (extend fi (VRecFun(i, origin_closures, origin_env)) env) origin_env)
	in sub closures closures env env
let make_rec_fun_name_list closures =
	let rec sub closures accum =
		(match closures with
		| [] -> accum
		| (fi,_,_) :: closures'-> sub closures' (accum @ ["val "^fi]))
	in sub closures []	
let make_rec_fun_vals closures env =
	let rec sub closures origin_closures env accum =
		(match closures with
		| [] -> accum
		| (fi,xi,ei) :: closures' ->
			let i = List.length closures in
			sub closures' origin_closures env (accum @ [VRecFun(i, origin_closures, env)])) 
	in sub closures closures env []
let rec search_xi_ei i closures =
	let j = List.length closures in
	match closures with
	| [] -> raise (EvalErr ("No closures"))
	| (_,xj,ej) :: closures' ->
		if i = j then (xj,ej) else (search_xi_ei i closures')

let rec make_EFun xs e =
	match xs with
	| x :: [] -> EFun(x,e)
	| x :: xss -> EFun(x, (make_EFun xss e))

let rec lookup x env =
  try List.assoc x env with Not_found -> raise Unbound

let rec eval_expr env e =
  match e with
  | EConstInt i ->
    VInt i
  | EConstBool b ->
    VBool b
  | EVar x ->
    (try
       lookup x env
     with
     | Unbound -> raise (EvalErr ("Unbound value " ^ x)))
  | EAdd (e1,e2) ->
    let v1 = eval_expr env e1 in
    let v2 = eval_expr env e2 in
    (match v1, v2 with
     | VInt i1, VInt i2 -> VInt (i1 + i2)
     | _ -> raise (EvalErr ("Expected type is int")))
  | ESub (e1,e2) ->
    let v1 = eval_expr env e1 in
    let v2 = eval_expr env e2 in
    (match v1, v2 with
     | VInt i1, VInt i2 -> VInt (i1 - i2)
     | _ -> raise (EvalErr ("Expected type is int")))
  | EMul (e1,e2) ->
    let v1 = eval_expr env e1 in
    let v2 = eval_expr env e2 in
    (match v1, v2 with
     | VInt i1, VInt i2 -> VInt (i1 * i2)
     | _ -> raise (EvalErr ("Expected type is int")))
  | EDiv (e1,e2) ->
    let v1 = eval_expr env e1 in
    let v2 = eval_expr env e2 in
    (match v1, v2 with
     | VInt i1, VInt i2 -> VInt (i1 / i2)
     | _ -> raise (EvalErr ("Expected type is int")))
  | EAnd (e1,e2) ->
    let v1 = eval_expr env e1 in
	let v2 = eval_expr env e2 in
	(match v1, v2 with
	| VBool b1, VBool b2 -> VBool (b1 && b2)
	| _ -> raise (EvalErr ("Expected type is bool")))
  | EOr (e1,e2) ->
    let v1 = eval_expr env e1 in
	let v2 = eval_expr env e2 in
	(match v1, v2 with
	| VBool b1, VBool b2 -> VBool (b1 || b2)
	| _ -> raise (EvalErr ("Expected type is bool")))
  | ENot (e) ->
    let v = eval_expr env e in
	(match v with
	| VBool b -> VBool (not b)
	| _ -> raise (EvalErr ("Expected type is bool")))
  | EEq (e1,e2) ->
    let v1 = eval_expr env e1 in
    let v2 = eval_expr env e2 in
    (match v1, v2 with
     | VInt i1,  VInt i2  -> VBool (i1 = i2)
     | _ -> raise (EvalErr ("Expected type is int")))
  | ELt (e1,e2) ->
    let v1 = eval_expr env e1 in
    let v2 = eval_expr env e2 in
    (match v1, v2 with
     | VInt i1,  VInt i2  -> VBool (i1 < i2)
     | _ -> raise (EvalErr ("Expected type is int")))
  | EIf (e1,e2,e3) ->
    let v1 = eval_expr env e1 in
    (match v1 with
     | VBool b ->
       if b then eval_expr env e2 else eval_expr env e3
     | _ -> raise (EvalErr ("Expected type is bool")))
  | ELet (x,e1,e2) ->
  	let result = eval_expr env e1 in
	let newenv = extend x result env in
	eval_expr newenv e2
  | ELetFun (f,xs,e1,e2) -> eval_expr env (ELet (f, EFuns(xs,e1), e2))
  | EFun (x,e1) -> VFun (x, e1, env)
  | EFuns (xs,e1) -> eval_expr env (make_EFun xs e1)
  | EApp (e1,e2) ->
  	let v1 = eval_expr env e1 in
	let v2 = eval_expr env e2 in
	(match v1 with
	| VFun (x,ex,oenv) -> eval_expr (extend x v2 oenv) ex
	| VRecFun (i,closures,oenv) ->
		let (xi, ei) = search_xi_ei i closures in
		let env' = extend xi v2 (extend_closures closures oenv) in
		eval_expr env' ei
	| _ -> raise (EvalErr ("Type is not matched")))
  | ELetRec (closures, ex) ->
  	let env' = extend_closures closures env in
	eval_expr env' ex
  | EPair(e1,e2) -> VPair((eval_expr env e1), (eval_expr env e2))
  | ENil -> VNil
  | ECons(e1,e2) -> VCons((eval_expr env e1), (eval_expr env e2))
  | EMatch(e1, l) ->
  	let v = eval_expr env e1 in
	(match l with
	 | [] -> raise (EvalErr ("Pattern match is fail"))
	 | (pi,ei) :: l' ->
	 	let result = find_match pi v in
	 	(match result  with
		 | None -> eval_expr env (EMatch(e1,l'))
		 | Some(env') -> eval_expr (env' @ env) ei))
and  print_vs v =
		(match v with
		| VInt i -> print_int i
		| VBool b -> print_string (string_of_bool b)
		| VFun (x,e,env) ->
			(print_string "(";
			 print_name x;
			 print_string ",";
			 print_expr e;
			 print_string ",";
			 print_env env;
			 print_string ")")
		| VRecFun (i, closures, env) ->
			(print_string "(";
			 print_int i;
			 print_string ",";
			 print_closures closures;
			 print_string ",";
			 print_env env;
			 print_string ")"))
and print_env env =
	match env with
	| [] -> ()
	| (name, value) :: env' ->
		(print_string ("(" ^ name ^ ",");
		 print_vs value;
		 print_string ") ";
		 print_env env')

let rec eval_command env c =
  match c with
  | CExp e -> (["-"], env, [eval_expr env e])
  | CDecl (x, e) -> 
  	let result = eval_expr env e in
  	let newenv = extend x result env in
	(["val " ^ x], newenv, [result])
  | CRecDecl closures ->
  	let env' = extend_closures closures env in
	let fs   = make_rec_fun_name_list closures in
	let cs   = make_rec_fun_vals closures env in
	(fs, env',cs)
  | CFunDecl (f,xs,e) -> eval_command env (CDecl (f, EFuns(xs,e)))
