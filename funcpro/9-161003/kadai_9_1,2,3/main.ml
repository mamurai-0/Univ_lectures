open Syntax
open Eval
open Type

exception Error of string

let rec read_eval_print env tenv =
  print_string "# ";
  flush stdout;
  let cmd = (try Parser.toplevel Lexer.main (Lexing.from_channel stdin) with
	|Parsing.Parse_error -> print_string "Fatal error: exception Parsing.Parse_error\n"; read_eval_print env tenv
  	|Failure(msg) -> print_string (msg ^ "\n"); read_eval_print env tenv
    |_ -> print_string "Some Error in lex or parse\n"; read_eval_print env tenv) in
 (* print_command cmd;
  print_newline ();
  print_env env;
  print_newline ();
  *)
  try (
	let (tys, tenv') = infer_cmd tenv cmd in
	let (ids, newenv, vs) = eval_command env cmd in
  (print_value ids vs tys;
   read_eval_print newenv tenv')) with
  	| Eval.EvalErr msg -> print_string (msg ^ "\n"); read_eval_print env tenv
	| Type.TypeErr msg -> print_string (msg ^ "\n"); read_eval_print env tenv
	| Type.PrintErr -> print_string "Print Error\n"; read_eval_print env tenv
	| _ -> print_string "Some Error in infer or eval\n"; read_eval_print env tenv

let initial_env = empty_env
let initial_tenv = empty_tenv

let _ = read_eval_print initial_env initial_tenv
