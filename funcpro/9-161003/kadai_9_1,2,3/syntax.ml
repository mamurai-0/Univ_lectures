type name = string 

exception NumArg

type pattern =
  | PInt  of int
  | PBool of bool
  | PVar  of name
  | PPair of pattern * pattern
  | PNil
  | PCons of pattern * pattern

type expr =
  | EConstInt  of int
  | EConstBool of bool
  | EVar       of name 
  | EAdd       of expr * expr
  | ESub       of expr * expr
  | EMul       of expr * expr
  | EDiv       of expr * expr
  | EAnd	   of expr * expr
  | EOr		   of expr * expr
  | ENot	   of expr
  | EEq        of expr * expr
  | ELt        of expr * expr		 
  | EIf        of expr * expr * expr
  | ELet       of name * expr * expr
  | ELetFun	   of name * name list * expr * expr
  | EFun	   of name * expr
  | EFuns	   of name list * expr
  | EApp	   of expr * expr
  | ELetRec	   of (name * name * expr) list * expr
  | EPair	   of expr * expr
  | ENil
  | ECons	   of expr * expr
  | EMatch	   of expr * (pattern * expr) list

type value =
  | VInt    of int
  | VBool   of bool
  | VFun    of name * expr * env
  | VRecFun of int * (name * name * expr) list * env
  | VPair   of value * value
  | VNil
  | VCons   of value * value
and env = (name * value) list

type command =
  | CExp     of expr
  | CDecl    of name * expr
  | CFunDecl of name * name list * expr
  | CRecDecl of (name * name * expr) list

let rec find_match : pattern -> value -> (name * value) list option =
	fun p v ->
	match (p,v) with
	| (PInt(i1), VInt(i2)) -> if i1 = i2 then Some([]) else None
	| (PBool(b1), VBool(b2)) -> if b1 = b2 then Some([]) else None
	| (PVar(x), _) -> Some([x,v])
	| (PPair(p1,p2), VPair(v1,v2)) ->
		let f1 = find_match p1 v1 in
		let f2 = find_match p2 v2 in
		(match (f1,f2) with
		| (Some(l1), Some(l2)) -> Some(l1 @ l2)
		| _ -> None)
	| (PNil, VNil) -> Some([])
	| (PCons(p1,p2), VCons(v1,v2)) ->
		let f1 = find_match p1 v1 in
		let f2 = find_match p2 v2 in
		(match (f1,f2) with
		| (Some(l1), Some(l2)) -> Some(l1 @ l2)
		| _ -> None)
	| _ -> None
						  
(*
 小さい式に対しては以下でも問題はないが，
 大きいサイズの式を見やすく表示したければ，Formatモジュール
   http://caml.inria.fr/pub/docs/manual-ocaml/libref/Format.html
 を活用すること
*)

let print_name = print_string
let rec print_name_list xs =
	match xs with
	|[] -> ()
	|x :: xss -> print_name x; print_string " "; print_name_list xss


let rec print_expr e =
  match e with
  | EConstInt i ->
     print_int i
  | EConstBool b ->
     print_string (string_of_bool b)
  | EVar x -> 
     print_name x
  | EAdd (e1,e2) -> 
     (print_string "EAdd (";
      print_expr e1;
      print_string ",";
      print_expr e2;
      print_string ")")
  | ESub (e1,e2) -> 
     (print_string "ESub (";
      print_expr e1;
      print_string ",";
      print_expr e2;
      print_string ")")
  | EMul (e1,e2) -> 
     (print_string "EMul (";
      print_expr e1;
      print_string ",";
      print_expr e2;
      print_string ")")
  | EDiv (e1,e2) -> 
     (print_string "EDiv (";
      print_expr e1;
      print_string ",";
      print_expr e2;
      print_string ")")
  | EAnd (e1,e2) -> 
     (print_string "EAnd (";
      print_expr e1;
      print_string ",";
      print_expr e2;
      print_string ")")
  | EOr (e1,e2) -> 
     (print_string "EOr (";
      print_expr e1;
      print_string ",";
      print_expr e2;
      print_string ")") 
  | ENot (e) ->
  	(print_string "ENot (";
	 print_expr e;
	 print_string ")";)
  | EEq (e1,e2) ->
     (print_string "EEq (";
      print_expr e1;
      print_string ",";
      print_expr e2;
      print_string ")")
  | ELt (e1, e2) ->
     (print_string "ELt (";
      print_expr e1;
      print_string ",";
      print_expr e2;
      print_string ")")
  | EIf (e1,e2,e3) ->
     (print_string "EIf (";
      print_expr   e1;
      print_string ","; 
      print_expr   e2;
      print_string ",";
      print_expr   e3;
      print_string ")")
  | ELet (x,e1,e2) ->
     (print_string "ELet (";
	  print_name x;
	  print_string ",";
      print_expr   e1;
      print_string ","; 
      print_expr   e2;
      print_string ")")
   | ELetFun (f,xs,e1,e2) ->
     (print_string "ELetFun (";
	  print_name f;
	  print_string ",";
	  print_name_list xs;
	  print_string ",";
      print_expr   e1;
      print_string ","; 
      print_expr   e2;
      print_string ")")
  | EFun (x,e1) ->
     (print_string "EFun (";
	  print_name x;
	  print_string ",";
      print_expr   e1;
      print_string ")")
  | EFuns (xs,e1) ->
     (print_string "EFuns (";
	  print_name_list xs;
	  print_string ",";
      print_expr   e1;
      print_string ")")
  | EApp (e1,e2) ->
     (print_string "EApp (";
      print_expr   e1;
      print_string ","; 
      print_expr   e2;
      print_string ")")
  | ELetRec (closures,e1) ->
     (print_string "ELetRec (";
	  print_closures closures;
	  print_string ",";
      print_expr   e1;
      print_string ")")
and print_closures closures =
	match closures with
	| [] -> print_string ")";
	| (f,x,e) :: closures' ->
		(print_string (" (" ^ f ^ "," ^ x ^ ",");
		 print_expr e;
		 print_string ") ";
		 print_closures closures')

let rec print_command p =       
  match p with
  | CExp e -> print_expr e
  | CDecl (x, e) ->
  	(print_string "CDecl (";
	 print_name x;
	 print_string ",";
	 print_expr e;
	 print_string ")")
  | CRecDecl closures ->
  	(print_string "CRecDecl (";
	 print_closures closures;
	 print_string ")")
  | CFunDecl (f,xs,e) ->
   	(print_string "CFunDecl (";
	 print_name f;
	 print_string ",";
	 print_name_list xs;
	 print_string ",";
	 print_expr e;
	 print_string ")")
  	 
