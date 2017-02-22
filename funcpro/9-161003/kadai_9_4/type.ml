open Syntax
open Eval

type tyvar = int

type ty = TyInt | TyBool | TyFun of ty * ty | TyVar of tyvar | TyPair of ty * ty | TyList of ty

type subst = (tyvar * ty) list

exception TypeErr of string

let rec search : subst -> tyvar -> ty option =
	fun s a ->
	match s with
	|[] -> None
	|(ai, ti) :: ss ->
		(if ai = a then Some(ti) else (search ss a))

let rec ty_subst : subst -> ty -> ty =
	fun s t ->
	match t with
	|TyInt -> TyInt
	|TyBool -> TyBool
	|TyFun (t1,t2) -> TyFun ((ty_subst s t1), (ty_subst s t2))
	|TyVar (alpha) ->
	(let ti = search s alpha in
	 match ti with
	 |None -> TyVar(alpha)
	 |Some (tii) -> tii)
	|TyPair(t1,t2) -> TyPair((ty_subst s t1), (ty_subst s t2))
	|TyList(t1) -> TyList((ty_subst s t1))

let rec compose : subst -> subst -> subst =
	fun s1 s2 ->
	match s1 with
	| [] -> s2
	| (ai, ti) :: ss ->
		(match (search s2 ai) with
		| None -> compose ss ((ai, (ty_subst s2 ti)) :: s2)
		| Some(tii) -> compose ss s2)

let rec subst_us : (ty * ty) list -> tyvar -> ty -> (ty * ty) list =
	fun us a t ->
	(match us with
	| [] -> []
	| (t1, t2) :: uss -> ((ty_subst [(a,t)] t1), (ty_subst [(a,t)] t2)) :: (subst_us uss a t))

let rec t_not_have_a : ty -> tyvar -> bool =
	fun t a ->
	match t with
	| TyInt -> true
	| TyBool -> true
	| TyFun(t1,t2) -> (t_not_have_a t1 a) && (t_not_have_a t2 a)
	| TyVar(b) -> if a = b then false else true
	| TyPair(t1,t2) -> (t_not_have_a t1 a) && (t_not_have_a t2 a)
	| TyList(t1) -> t_not_have_a t1 a

let ty_unify_sub : (ty * ty) list -> (ty * ty) * ((ty * ty) list) =
	let rec ty_unify_sub_sub : (ty * ty) list -> (ty * ty) list -> (ty * ty) * ((ty * ty) list) =
		fun u accum ->
		(match u with
		| [] -> raise (TypeErr "unification error")
		| (s,t) :: us ->
			(if s = t then ((s,t), accum @ us) else
			 (match (s,t) with
			 | (TyFun(s1,t1), TyFun(s2,t2)) -> ((s,t), accum @ us)
			 | (TyVar(a),t1) -> 
			 	if (t_not_have_a t1 a) then 
						((s,t), accum @ us)
				else
						ty_unify_sub_sub us (accum @ [(s,t)])
			 | (t1,TyVar(a)) ->
				if (t_not_have_a t1 a) then 
						((t,s), accum @ us)
				else
						ty_unify_sub_sub us (accum @ [(s,t)])
			 | (TyPair(s1,t1), TyPair(s2,t2)) -> ty_unify_sub_sub us (accum @ [(s1,s2); (t1,t2)])
			 | (TyList(t1), TyList(t2)) -> ty_unify_sub_sub ((t1,t2) :: us) accum
			 | _ -> ty_unify_sub_sub us (accum @ [(s,t)]))))
	in 
	fun u -> ty_unify_sub_sub u []

let rec ty_unify : (ty * ty) list -> subst =
	fun u ->
	match u with
	| [] -> []
	| _ -> 
		(let ((s,t), us) = ty_unify_sub u in
		 if s = t then (ty_unify us) else
		 (match (s,t) with
		 | (TyFun(s1,t1), TyFun(s2,t2)) -> ty_unify ([(s1,s2); (t1,t2)] @ us)
		 | (TyVar(a),t1) -> compose (ty_unify (subst_us us a t1)) [(a, t1)]))

(*ここから第８回で追加した*)
type constraints = (ty * ty) list
type type_schema = ScTy of ty | ScAll of tyvar * type_schema
type tyenv = (name * type_schema) list

let empty_tenv = []
let numvar = ref 0
let new_tyvar : unit -> tyvar =
	fun () -> 
	let v = !numvar in
	numvar := !numvar + 1; v

let rec tschem_subst : subst -> type_schema -> type_schema =
	fun s schem ->
	match schem with
	| ScTy(t) -> ScTy(ty_subst s t)
	| ScAll(x,schem') -> ScAll(x,(tschem_subst s schem'))
let rec tenv_subst : subst -> tyenv -> tyenv =
	fun s tenv ->
	match tenv with
	| [] -> []
	| (x,schem) :: tenv' -> (x,(tschem_subst s schem)) :: (tenv_subst s tenv')
let rec get_type_vars : ty -> tyvar list =
	fun t ->
	match t with
	| TyInt -> []
	| TyBool -> []
	| TyFun(t1,t2) -> (get_type_vars t1) @ (get_type_vars t2)
	| TyVar(x) -> [x]
	| TyPair(t1,t2) -> (get_type_vars t1) @ (get_type_vars t2)
	| TyList(t1) -> get_type_vars t1
let rec get_tenv_vars : tyenv -> tyvar list =
	fun tenv ->
	match tenv with
	| [] -> []
	| (x,tschema) :: tenv' ->
		(match tschema with
		| ScTy(t) -> (get_type_vars t) @ (get_tenv_vars tenv')
		| ScAll(_,tschema') -> get_tenv_vars ((x,tschema') :: tenv'))
let rec diff a b =
	match b with
	| [] -> a
	| x :: xs -> let (_,l2) = List.partition (fun p -> (x = p)) a in l2
let rec generalize_sub : tyvar list -> ty -> type_schema =
	fun ftv t ->
	match ftv with
	| [] -> ScTy(t)
	| x :: ftv' -> ScAll(x,(generalize_sub ftv' t))
let generalize : tyenv -> ty -> type_schema =
	fun tenv t ->
	let ftv_t = get_type_vars t in
	let ftv_env = get_tenv_vars tenv in
	let ftv = diff ftv_t ftv_env in
	generalize_sub ftv t
let rec make_generalize : (name * name * expr) list -> tyenv -> ty list -> tyenv =
	fun closures tenv ts ->
	match (closures,ts) with
	| ([],[]) -> tenv
	| (((f,_,_) :: closures'), (t :: ts')) -> (f, (generalize tenv t)) :: (make_generalize closures' tenv ts')
let instantiate_sub_1 : type_schema -> ty * (tyvar list) =
	let rec instantiate_sub_1_sub schem accum =
		match schem with
		| ScTy(t) -> (t,accum)
		| ScAll(a,schem') -> instantiate_sub_1_sub schem' (a :: accum)
	in fun schem -> instantiate_sub_1_sub schem []
let rec instantiate_sub_2 : tyvar list -> subst =
	fun vars ->
	match vars with
	| [] -> []
	| a :: vars' -> let b = new_tyvar () in (a,TyVar(b)) :: (instantiate_sub_2 vars')
let instantiate : type_schema -> ty =
	fun schem ->
	let (t,vars) = instantiate_sub_1 schem in
	ty_subst  (instantiate_sub_2 vars) t

let make_typeenv_1 : (name * name * expr) list -> tyenv -> tyenv * (ty list) =
	let rec make_typeenv_1_sub closures accum1 accum2 accum3 =
		match closures with
		| [] -> (accum1,accum2,accum3)
		| (f,x,e1) :: closures' -> 
			let a = new_tyvar () in
			let b = new_tyvar () in
			make_typeenv_1_sub closures' (accum1 @ [(f,ScTy(TyFun(TyVar(a),TyVar(b))))]) ((x,ScTy(TyVar(a))) :: accum2) (accum3 @ [TyVar(b)])
	in fun closures tenv ->
	let (fs,xs,bs) = make_typeenv_1_sub closures [] [] [] in
	((xs @ fs @ tenv), bs)
let rec make_typeenv_2 : tyenv -> tyenv =
	fun tenv' ->
	match tenv' with
	| (_, ScTy(TyVar(_))) :: tenv'' -> make_typeenv_2 tenv''
	| _ -> tenv'
let make_typeenv_3 : tyenv -> ty list =
	let rec make_typeenv_3_sub tenv accum =
		match tenv with
		| (_,ScTy(TyFun(t1,t2))) :: tenv' -> make_typeenv_3_sub tenv' (accum @ [TyFun(t1,t2)])
		| (_,ScTy(TyVar(_))) :: tenv' -> make_typeenv_3_sub tenv' accum
		| _ -> accum
	in fun tenv ->
	make_typeenv_3_sub tenv []
let rec make_constraints_2 : ty list -> ty list -> constraints  =
	fun ts bs ->
	match (ts,bs) with
	| ([],[]) -> []
	| ((t :: tss),(b :: bss)) -> (t,b) :: (make_constraints_2 tss bss)
let rec search_var : tyenv -> name -> type_schema option =
	fun tenv x ->
	match tenv with
	|[] -> None
	|(xi, ti) :: tenv' ->
		(if xi = x then Some(ti) else (search_var tenv' x))

let rec infer_expr : tyenv -> expr -> ty * constraints =
	fun tenv e ->
	match e with
	| EConstInt(_) -> (TyInt, [])
	| EConstBool(_) -> (TyBool,[])
	| EVar(x) -> 
		(match search_var tenv x with
		| None -> raise (TypeErr ("Unbound value " ^ x ^ " in type"))
		| Some(schem) -> ((instantiate schem), []))
	| EAdd(e1,e2) ->
		let (t1,c1) = infer_expr tenv e1 in
		let (t2,c2) = infer_expr tenv e2 in
		(match t1, t2 with
		| TyInt, TyInt -> (TyInt, c1 @ c2)
		| TyInt, TyVar(a) -> (TyInt, (t2, TyInt) :: c1 @ c2)
		| TyVar(a), TyInt -> (TyInt, (t1, TyInt) :: c1 @ c2)
		| TyVar(a), TyVar(b) -> (TyInt, (t1, TyInt) :: ((t2, TyInt) :: c1 @ c2))
		| _ -> raise (TypeErr "type is not matched in Add"))
	| ESub(e1,e2) ->
		let (t1,c1) = infer_expr tenv e1 in
		let (t2,c2) = infer_expr tenv e2 in
		(match t1, t2 with
		| TyInt, TyInt -> (TyInt, c1 @ c2)
		| TyInt, TyVar(a) -> (TyInt, (t2, TyInt) :: c1 @ c2)
		| TyVar(a), TyInt -> (TyInt, (t1, TyInt) :: c1 @ c2)
		| TyVar(a), TyVar(b) -> (TyInt, (t1, TyInt) :: ((t2, TyInt) :: c1 @ c2))
		| _ -> raise (TypeErr "type is not matched in Sub"))
	| EMul(e1,e2) ->
		let (t1,c1) = infer_expr tenv e1 in
		let (t2,c2) = infer_expr tenv e2 in
		(match t1, t2 with
		| TyInt, TyInt -> (TyInt, c1 @ c2)
		| TyInt, TyVar(a) -> (TyInt, (t2, TyInt) :: c1 @ c2)
		| TyVar(a), TyInt -> (TyInt, (t1, TyInt) :: c1 @ c2)
		| TyVar(a), TyVar(b) -> (TyInt, (t1, TyInt) :: ((t2, TyInt) :: c1 @ c2))
		| _ -> raise (TypeErr "type is not matched in Mul"))
	| EDiv(e1,e2) ->
		let (t1,c1) = infer_expr tenv e1 in
		let (t2,c2) = infer_expr tenv e2 in
		(match t1, t2 with
		| TyInt, TyInt -> (TyInt, c1 @ c2)
		| TyInt, TyVar(a) -> (TyInt, (t2, TyInt) :: c1 @ c2)
		| TyVar(a), TyInt -> (TyInt, (t1, TyInt) :: c1 @ c2)
		| TyVar(a), TyVar(b) -> (TyInt, (t1, TyInt) :: ((t2, TyInt) :: c1 @ c2))
		| _ -> raise (TypeErr "type is not matched in Div"))
	| EAnd(e1,e2) ->
		let (t1,c1) = infer_expr tenv e1 in
		let (t2,c2) = infer_expr tenv e2 in
		(match t1, t2 with
		| TyBool, TyBool -> (TyBool, c1 @ c2)
		| TyBool, TyVar(a) -> (TyBool, (t2, TyBool) :: c1 @ c2)
		| TyVar(a), TyBool -> (TyBool, (t1, TyBool) :: c1 @ c2)
		| TyVar(a), TyVar(b) -> (TyBool, (t1, TyBool) :: ((t2, TyBool) :: c1 @ c2))
		| _ -> raise (TypeErr "type is not matched in And"))
	| EOr(e1,e2) ->
		let (t1,c1) = infer_expr tenv e1 in
		let (t2,c2) = infer_expr tenv e2 in
		(match t1, t2 with
		| TyBool, TyBool -> (TyBool, c1 @ c2)
		| TyBool, TyVar(a) -> (TyBool, (t2, TyBool) :: c1 @ c2)
		| TyVar(a), TyBool -> (TyBool, (t1, TyBool) :: c1 @ c2)
		| TyVar(a), TyVar(b) -> (TyBool, (t1, TyBool) :: ((t2, TyBool) :: c1 @ c2))
		| _ -> raise (TypeErr "type is not matched in Or"))
	| ENot(e1) ->
		let (t1,c1) = infer_expr tenv e1 in
		(match t1 with
		| TyBool -> (TyBool, c1)
		| TyVar(a) -> (TyBool, (t1, TyBool) :: c1)
		| _ -> raise (TypeErr "type is not matched in Not"))
	| EEq(e1,e2) ->
		let (t1,c1) = infer_expr tenv e1 in
		let (t2,c2) = infer_expr tenv e2 in
		(match t1, t2 with
		| TyInt, TyInt -> (TyBool, c1 @ c2)
		| TyInt, TyVar(a) -> (TyBool, (t2, TyInt) :: c1 @ c2)
		| TyVar(a), TyInt -> (TyBool, (t1, TyInt) :: c1 @ c2)
		| TyVar(a), TyVar(b) -> (TyBool, (t1, TyInt) :: ((t2, TyInt) :: c1 @ c2))
		| _ -> raise (TypeErr "type is not matched in Eq"))
	| ELt(e1,e2) ->
		let (t1,c1) = infer_expr tenv e1 in
		let (t2,c2) = infer_expr tenv e2 in
		(match t1, t2 with
		| TyInt, TyInt -> (TyBool, c1 @ c2)
		| TyInt, TyVar(a) -> (TyBool, (t2, TyInt) :: c1 @ c2)
		| TyVar(a), TyInt -> (TyBool, (t1, TyInt) :: c1 @ c2)
		| TyVar(a), TyVar(b) -> (TyBool, (t1, TyInt) :: ((t2, TyInt) :: c1 @ c2))
		| _ -> raise (TypeErr "type is not matched in Lt"))
	| EIf(e1,e2,e3) ->
		let (t1,c1) = infer_expr tenv e1 in
		let (t2,c2) = infer_expr tenv e2 in
		let (t3,c3) = infer_expr tenv e3 in
		(t2, [(t1,TyBool); (t2,t3)] @ c1 @ c2 @ c3)
	| ELet(x,e1,e2) ->
		let (t1,c1) = infer_expr tenv e1 in
		let s = ty_unify c1 in
		let s1 = ty_subst s t1 in
		let d = tenv_subst s tenv in
		let tenv' = (x,(generalize d s1)) :: tenv in
		let (t2,c2) = infer_expr tenv' e2 in
		(t2, c1 @ c2)
	| ELetFun(f,xs,e1,e2) -> infer_expr tenv (ELet (f, EFuns(xs,e1), e2))
	| EFun(x,e1) -> 
		let a = new_tyvar () in
		let tenv' = (x,ScTy(TyVar(a))) :: tenv in
		let (t1,c1) = infer_expr tenv' e1 in
		(TyFun(TyVar(a),t1), c1)
	| ERecFun(i,closures,env) ->
		let (xi,ei) = search_xi_ei i closures in
		let a = new_tyvar () in
		let tenv' = (xi,ScTy(TyVar(a))) :: tenv in
		let (t1,c1) = infer_expr tenv' ei in
		(TyFun(TyVar(a),t1), c1)
	| EFuns(xs,e1) -> infer_expr tenv (make_EFun xs e1)
	| EApp(e1,e2) ->
		(*
		print_string "EApp infer start\n";
		print_tenv tenv;
		print_string "\n";
		*)
		let (t1,c1) = infer_expr tenv e1 in
		(*
		print_string "t1 is end ";
		print_type t1;
		print_string "\n";
		*)
		let (t2,c2) = infer_expr tenv e2 in
		(*
		print_string "t2 is end ";
		print_type t2;
		print_string "\n";
		*)
		let a = new_tyvar () in
		(TyVar(a), (t1, TyFun(t2,TyVar(a))) :: c1 @ c2)
	| ELetRec(closures,e1) ->
	(*	
		print_string "ELetRec infer start\n";
		*)
		let (tenv',bs) = make_typeenv_1 closures tenv in
		(*
		print_string "tenv' = ";
		print_tenv tenv';
		print_string "\n";
		*)
		let (ts,cs) = make_constraints_1 tenv' closures in
		(*
		print_string "types = ";
		print_types ts;
		print_string "\n";
		print_string "constraints = ";
		print_constraint cs;
		print_string "\n";
		*)
		let tenv'' = make_typeenv_2 tenv' in
		(*
		print_string "tenv'' = ";
		print_tenv tenv'';
		print_string "\n";
		*)
		let tenv_sub = make_typeenv_4 tenv'' tenv in
		(*
		print_string "tenv_sub = ";
		print_tenv tenv_sub;
		print_string "\n";
		*)
		let (t1,c1) = infer_expr tenv_sub e1 in
		(*
		print_string "type after app = ";
		print_type t1;
		print_string "\n";
		*)
		(t1, (make_constraints_2 ts bs) @ cs @ c1)
	| EPair(e1,e2) ->
		let (t1,c1) = infer_expr tenv e1 in
	    let (t2,c2) = infer_expr tenv e2 in
		(TyPair(t1,t2), c1 @ c2)
	| ENil ->
		let a = new_tyvar () in
		(TyList(TyVar(a)), [])
	| ECons(e1,e2) ->
		let (t1,c1) = infer_expr tenv e1 in
	    let (t2,c2) = infer_expr tenv e2 in
		let a = new_tyvar () in
		(TyList(TyVar(a)), ((TyVar(a), t1) :: (TyList(TyVar(a)), t2) :: c1 @ c2)) 
	| EMatch(e1,l) ->
		let rec make_constraints_pattern p =
			match p with
			| PInt _ -> (TyInt, [], [])
			| PBool _ -> (TyBool, [], [])
			| PVar x -> 
				let a = new_tyvar () in
				(TyVar(a), [], [(x,ScTy(TyVar(a)))])
			| PPair (p1,p2) -> 
				let (t1,c1,tenv1) = make_constraints_pattern p1 in
				let (t2,c2,tenv2) = make_constraints_pattern p2 in
				(TyPair(t1,t2), (c1 @ c2), (tenv1 @ tenv2))
			| PNil ->
				let a = new_tyvar () in
				(TyList(TyVar(a)), [], [])
			| PCons(p1,p2) ->
				let (t1,c1,tenv1) = make_constraints_pattern p1 in
				let (t2,c2,tenv2) = make_constraints_pattern p2 in
				let a = new_tyvar () in
				(TyList(TyVar(a)), ((TyVar(a), t1) :: (TyList(TyVar(a)), t2) :: c1 @ c2), (tenv1 @ tenv2)) in
		let rec infer_expr_match_sub1 l accum1 accum2 accum3 =
			(match l with
			| [] -> (accum1, accum2, accum3)
			| (pi,_) :: l' ->
				let (ti,ci,tenvi) = make_constraints_pattern pi in
				infer_expr_match_sub1 l' (accum1 @ [ti]) (accum2 @ ci) (accum3 @ [tenvi])) in
		let rec infer_expr_match_sub2 tenv l tenvs accum1 accum2 =
			(match (l,tenvs) with
			| ([],[]) -> (accum1, accum2)
			| (((_,ei) :: l'), (tenvi :: tenvs')) ->
				let (ti,ci) = infer_expr (tenvi @ tenv) ei in
				infer_expr_match_sub2 tenv l' tenvs' (accum1 @ [ti]) (accum2 @ ci) 
			| _ -> raise (TypeErr "pattern matching is fail")) in
		let rec infer_expr_match_sub3 t ts ts' a accum =
			(match (ts,ts') with
			| ([], []) -> accum
			| ((ti :: tss), (ti' :: tss')) -> infer_expr_match_sub3 t tss tss' a (accum @ [(t, ti); (TyVar(a), ti')])
			| _ -> raise (TypeErr "pattern matching is fail")) in
		let (t,c) = infer_expr tenv e1 in
		let (ts,cs,tenvs) = infer_expr_match_sub1 l [] [] [] in
		let (ts',cs') = infer_expr_match_sub2 tenv l tenvs [] [] in
		let a = new_tyvar () in
		(TyVar(a), ((infer_expr_match_sub3 t ts ts' a []) @ c @ cs @ cs'))
and make_constraints_1 : tyenv -> (name * name * expr) list -> (ty list) * constraints  =
	fun tenv closures ->
	match closures with
	| [] -> ([],[])
	| (_,x,e) :: closures' ->
		let (t,c) = infer_expr tenv e in
		let (ts,cs) = make_constraints_1 tenv closures' in
		((t :: ts), (c @ cs)) 
and  make_typeenv_4 : tyenv -> tyenv -> tyenv =
	fun tenv' tenv ->
	match tenv' with
	| (fi,(ScTy(TyFun(TyVar(a),TyVar(b))))) :: tenv'' ->
		let t = TyFun(TyVar(a),TyVar(b)) in
		(fi,(generalize tenv t)) :: (make_typeenv_4 tenv'' tenv)
	| _ -> tenv
and infer_cmd : tyenv -> command -> (ty list) * tyenv =
	fun tenv cmd ->
	match cmd with
	| CExp(e) ->
		let (t,c) = infer_expr tenv e in
		let s = ty_unify c in
		([(ty_subst s t)], tenv)
	| CDecl(x,e) ->
		let (t1,c1) = infer_expr tenv e in
		let s = ty_unify c1 in
		let s1 = ty_subst s t1 in
		let d = tenv_subst s tenv in
		let tenv' = (x,(generalize d s1)) :: tenv in
		([s1], tenv')
	| CFunDecl(f,xs,e) -> infer_cmd tenv (CDecl (f, EFuns(xs,e)))
	| CRecDecl(closures) ->
		(*
		print_string "CRecDecl is start\n";
		print_closure closures;
		print_string "\n";
		*)
		let (tenv',bs) = make_typeenv_1 closures tenv in
		(*
		print_string "tenv' = ";
		print_tenv tenv';
		print_string "\n";
		*)
		let (ts,cs) = make_constraints_1 tenv' closures in	
		let cs' = (make_constraints_2 ts bs) @ cs in
		let s = ty_unify cs' in
		let types = make_typeenv_3 tenv' in
		let tenv_sub = make_typeenv_4 (make_typeenv_2 tenv') tenv in
		(*
		print_tenv tenv_sub;
		print_string "\n";
		*)
		((List.map (ty_subst s) types), tenv_sub)
and print_type t =
	match t with
	| TyInt -> print_string "int"
	| TyBool -> print_string "bool"
	| TyFun(t1,t2) -> 
		(match t1 with
		| TyFun(_,_) ->
			print_string "(";
			print_type t1;
			print_string ") -> ";
			print_type t2
		| _ ->
			print_type t1;
			print_string " -> ";
			print_type t2)
	| TyVar(x) -> print_int x
	| TyPair(t1,t2) -> 
		print_type t1;
		print_string " * ";
		print_type t2
	| TyList(t1) ->
		print_type t1;
		print_string " list"
and print_types tys =
	match tys with
	| [] -> ()
	| t :: ts -> print_type t; print_string "  "; print_types ts
and print_tenv tenv =
	match tenv with
	| [] -> ()
	| (x,schem) :: tenv' -> print_string ("(" ^ x ^ ","); print_schem schem; print_string ") ";  print_tenv tenv'
and print_constraint c =
	match c with
	| [] -> ()
	| (t1,t2) :: c' -> print_string "("; print_type t1; print_string ","; print_type t2; print_string ") "; print_constraint c'
and print_subst s =
	match s with
	| [] -> ()
	| (x,t) :: s' -> print_string "("; print_int x; print_string ","; print_type t; print_string ") "; print_subst s'
and print_schem schem =
	match schem with
	| ScTy(t) -> print_type t
	| ScAll(x,schem') -> print_string "("; print_var x; print_string ","; print_schem schem'; print_string ")"
and print_var = print_int
and print_closure closure =
	match closure with
	| [] -> ()
	| (fi,xi,ei) :: closure' ->
		(print_string "(";
		 print_name fi;
		 print_string ", ";
		 print_name xi;
		 print_string ", ";
		 print_expr ei;
		 print_string ") ";)

let rec print_v v =
	match v with
	| VInt i -> print_int i
	| VBool b -> print_string (string_of_bool b)
	| VFun _ -> print_string "<fun>"
	| VRecFun _ -> print_string "<fun>"
	| VPair (v1,v2) -> 
		(print_string "(";
		 print_v v1;
		 print_string ", ";
		 print_v v2;
		 print_string ")")
	| VNil -> print_string "[]"
	| VCons (v1,v2) -> 
		(print_v v1;
		 print_string " :: ";
		 print_v v2)

exception PrintErr

let rec print_value ids vs tys =
	match (ids,vs,tys) with
	| ((id :: idss), (v :: vss), (ty :: tyss)) ->
		(Printf.printf "%s : " id; 
		 print_type ty; 
		 print_string " = "; 
		 print_v v; 
		 print_newline (); 
		 print_value idss vss tyss)
	| (_,[],_) -> ()
	| _ -> raise PrintErr
