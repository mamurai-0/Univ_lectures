%{
  open Syntax
  (* ここに書いたものは，ExampleParser.mliに入らないので注意 *)
%}

%token <int>    INT
%token <bool>   BOOL 
%token <string> ID
%token LET IN 		  
%token PLUS TIMES MINUS DIV
%token LAND LOR LNOT
%token EQ LT
%token IF THEN ELSE
%token LPAR RPAR 
%token FUN ARROW
%token REC AND
%token LBRACKET RBRACKET CONS COMMA
%token MATCH WITH BAR
%token SEMISEMI

%start toplevel 
%type <Syntax.command> toplevel
%% 

toplevel:
  | expr SEMISEMI                     { CExp $1 }
  | LET var EQ expr SEMISEMI          { CDecl ($2, $4) }
  | LET var var_list EQ expr SEMISEMI { CFunDecl ($2, $3, $5) }
  | LET REC let_and_decls SEMISEMI    { CRecDecl ($3) }
;

let_and_decls:
  | var var EQ expr AND let_and_decls { ($1,$2,$4) :: $6 }
  | var var EQ expr                   { [($1,$2,$4)] }
;
  
expr:
  | LET var EQ expr IN expr       	 { ELet($2,$4,$6) }
  | LET var var_list EQ expr IN expr { ELetFun($2,$3,$5,$7)  }
  | LET REC let_and_decls IN expr 	 { ELetRec($3,$5) }
  | IF expr THEN expr ELSE expr   	 { EIf($2,$4,$6) }
  | FUN var_list ARROW expr       	 { EFuns($2,$4) }
  | arith_expr EQ arith_expr      	 { EEq($1,$3) }
  | arith_expr LT arith_expr      	 { ELt($1,$3) }
  | MATCH expr WITH cases			 { EMatch($2, $4) }
  | MATCH expr WITH BAR cases		 { EMatch($2, $5) }
  | list_expr                    	 { $1 } 
;

cases:
  | pattern ARROW expr			 { [($1, $3)] }
  | pattern ARROW expr BAR cases { ($1, $3) :: $5 }
;

pattern:
  | atomic_pattern CONS pattern { PCons($1, $3) }
  | atomic_pattern				{ $1 }
;

atomic_pattern:
  | INT								{ PInt($1) }
  | BOOL						    { PBool($1) }
  | var								{ PVar($1) }					
  | LPAR pattern COMMA pattern RPAR { PPair($2, $4) }
  | LBRACKET RBRACKET				{ PNil }
  | LPAR pattern RPAR				{ $2 }

list_expr:
  | arith_expr CONS list_expr { ECons($1, $3) }
  | arith_expr				  { $1 }
;

arith_expr:
  | arith_expr PLUS factor_expr  { EAdd($1,$3) }
  | arith_expr MINUS factor_expr { ESub($1,$3) }
  | arith_expr LAND factor_expr  { EAnd($1,$3) }
  | arith_expr LOR  factor_expr  { EOr($1,$3) }
  | factor_expr                  { $1 }
;

factor_expr:
  | factor_expr TIMES app_expr { EMul($1,$3) }
  | factor_expr DIV app_expr   { EDiv($1,$3) }
  | LNOT app_expr			   { ENot($2) }
  | app_expr                   { $1 }
;

app_expr:
  | app_expr atomic_expr { EApp($1, $2) }
  | atomic_expr          { $1 }

atomic_expr:
  | INT            { EConstInt($1) }
  | BOOL           { EConstBool($1) }
  | ID             { EVar($1) }
  | LPAR expr RPAR { $2 }
  | LPAR expr COMMA expr RPAR { EPair($2, $4) }
  | LBRACKET RBRACKET { ENil }
;

var_list:
  | var var_list { $1 :: $2 }
  | var			 { [$1] }
;

var:
  | ID { $1 }
;
