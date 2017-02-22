open Array 
open Color 
open Command 


type board = color array array 

let init_board () = 
  let board = Array.make_matrix 10 10 none in 
    for i=0 to 9 do 
      board.(i).(0) <- sentinel ;
      board.(i).(9) <- sentinel ;
      board.(0).(i) <- sentinel ;
      board.(9).(i) <- sentinel ;
    done;
    board.(4).(4) <- white;
    board.(5).(5) <- white;
    board.(4).(5) <- black;
    board.(5).(4) <- black;
    board 

let dirs = [ (-1,-1); (0,-1); (1,-1); (-1,0); (1,0); (-1,1); (0,1); (1,1) ]

let flippable_indices_line board color (di,dj) (i,j) =
  let ocolor = opposite_color color in
  let rec f (di,dj) (i,j) r =
    if board.(i).(j) = ocolor then 
      g (di,dj) (i+di,j+dj) ( (i,j) :: r )
    else 
      [] 
  and    g (di,dj) (i,j) r =
    if board.(i).(j) = ocolor then 
      g (di,dj) (i+di,j+dj) ( (i,j) :: r )
    else if board.(i).(j) = color then 
      r
    else 
      [] in 
    f (di,dj) (i,j) []
      
    

let flippable_indices board color (i,j) =
  let bs = List.map (fun (di,dj) -> flippable_indices_line board color (di,dj) (i+di,j+dj)) dirs in 
    List.concat bs 
    
let is_effective board color (i,j) =
  match flippable_indices board color (i,j) with 
      [] -> false
    | _  -> true 

let is_valid_move board color (i,j) =
  (board.(i).(j) = none) && is_effective board color (i,j) 


let doMove board com color =
  match com with 
      GiveUp  -> board
    | Pass    -> board
    | Mv (i,j) -> 
	let ms = flippable_indices board color (i,j) in 
	let _  = List.map (fun (ii,jj) -> board.(ii).(jj) <- color) ms in 
	let _  = board.(i).(j) <- color in 
	  board 
    | _ -> board 

let mix xs ys =
  List.concat (List.map (fun x -> List.map (fun y -> (x,y)) ys) xs)
	     

let valid_moves :  board ->  color -> (int * int) list =
  fun board color ->
  let ls = [1;2;3;4;5;6;7;8] in 
  List.filter (is_valid_move board color)
    (mix ls ls)

let count board color = 
  let s = ref 0 in 
    for i=1 to 8 do 
      for j=1 to 8 do
        if board.(i).(j) = color then s := !s + 1 
      done
    done;
    !s


let print_board board = 
  print_endline " |A B C D E F G H ";
  print_endline "-+----------------";
  for j=1 to 8 do 
    print_int j; print_string "|";
    for i=1 to 8 do 
      print_color (board.(i).(j)); print_string " " 
    done;
    print_endline ""
  done;
  print_endline "  (X: Black,  O: White)"
      

let report_result board = 
  let _ = print_endline "========== Final Result ==========" in 
  let bc = count board black in 
  let wc = count board white in 
    if bc > wc then 
      print_endline "*Black wins!*" 
    else if bc < wc then 
      print_endline "*White wins!*" 
    else
      print_endline "*Even*";
    print_string "Black: "; print_endline (string_of_int bc);
    print_string "White: "; print_endline (string_of_int wc);
    print_board board 


let ctt = ref 0

let early_to_middle board =
  let c = ref false in 
    for i=3 to 6 do 
        if board.(1).(i) <> none then c := true 
    done;
    for i=3 to 6 do 
        if board.(8).(i) <> none then c := true 
    done;
    for i=3 to 6 do 
        if board.(i).(1) <> none then c := true 
    done;
    for i=3 to 6 do 
        if board.(i).(8) <> none then c := true 
    done;
    !c

let middle_to_final1 board =
        let c = ref false in
        let number_of_corner board =
                let num = ref 0 in
                if board.(1).(1) <> none then num := !num + 1;
                if board.(1).(8) <> none then num := !num + 1;
                if board.(8).(1) <> none then num := !num + 1;
                if board.(8).(8) <> none then num := !num + 1;
                !num
        in
        if ((!ctt >= 30) && (number_of_corner board >= 2)) then c := true;
        !c

let middle_final1_to_final2 board =
        if (!ctt >= 44) then
                true
        else
                false

let eval_move_value move =
        match move with
        | (1,1) -> 30
        | (1,2) -> -12
        | (1,3) -> 0
        | (1,4) -> -1
        | (2,1) -> -12
        | (2,2) -> -15
        | (2,3) -> -3
        | (2,4) -> -3
        | (3,1) -> 0
        | (3,2) -> -3
        | (3,3) -> 0
        | (3,4) -> -1
        | (4,1) -> -1
        | (4,2) -> -3
        | (4,3) -> -1
        | (1,8) -> 30
        | (1,7) -> -12
        | (1,6) -> 0
        | (1,5) -> -1
        | (2,8) -> -12
        | (2,7) -> -15
        | (2,6) -> -3
        | (2,5) -> -3
        | (3,8) -> 0
        | (3,7) -> -3
        | (3,6) -> 0
        | (3,5) -> -1
        | (4,8) -> -1
        | (4,7) -> -3
        | (4,6) -> -1
        | (8,1) -> 30
        | (8,2) -> -12
        | (8,3) -> 0
        | (8,4) -> -1
        | (7,1) -> -12
        | (7,2) -> -15
        | (7,3) -> -3
        | (7,4) -> -3
        | (6,1) -> 0
        | (6,2) -> -3
        | (6,3) -> 0
        | (6,4) -> -1
        | (5,1) -> -1
        | (5,2) -> -3
        | (5,3) -> -1
        | (8,8) -> 30
        | (8,7) -> -12
        | (8,6) -> 0
        | (8,5) -> -1
        | (7,8) -> -12
        | (7,7) -> -15
        | (7,6) -> -3
        | (7,5) -> -3
        | (6,8) -> 0
        | (6,7) -> -3
        | (6,6) -> 0
        | (6,5) -> -1
        | (5,8) -> -1
        | (5,7) -> -3
        | (5,6) -> -1
        | _ -> -1000

let list_max values ms =
        let rec sub values ms accum ans =
                match values, ms with
                | [], [] -> ans
                | (v :: vs), (m :: mss) ->
                       (if v >= accum then
                                sub vs mss v m
                        else
                                sub vs mss accum ans)
        in sub values ms (-200) (0,0)

let rec max_alpha alpha beta f ms =
        match ms with
        | [] -> alpha
        | m :: mss ->
                (let alpha' = max alpha (f alpha beta m) in
                 if alpha' >= beta then
                         (
                         beta)
                 else
                         max_alpha alpha' beta f mss)

and min_beta alpha beta f ms =
        match ms with
        | [] -> beta
        | m :: mss ->
                (let beta' = min beta (f alpha beta m) in
                 if alpha >= beta' then
                         (
                         alpha)
                 else
                         min_beta alpha beta' f mss)

and tryMove board m color =
      let new_board = Array.make_matrix 10 10 none in 
      for i=0 to 9 do
            for j=0 to 9 do
                    new_board.(i).(j) <- board.(i).(j);
            done
      done;
      let (i,j) = m in
	  let ms = flippable_indices new_board color (i,j) in
      let _  = List.map (fun (ii,jj) -> new_board.(ii).(jj) <- color) ms in 
	  let _  = new_board.(i).(j) <- color in 
	  new_board 
    
 
and alphabeta board color mycolor depth alpha beta m =
        let ocolor = opposite_color color in
        let new_board = tryMove board m color in
        let ms = valid_moves new_board ocolor in
        match ms with
        | []  -> let v = eval_move_value m in v
        | _ ->
                (if depth = 0 then
                  let v = eval_move_value m in v
                 else if color <> mycolor  then
                        ((eval_move_value m) + (max_alpha alpha beta (alphabeta new_board ocolor mycolor (depth-1)) ms)) / 2
                 else
                        ((eval_move_value m) + (min_beta  alpha beta (alphabeta new_board ocolor mycolor (depth-1)) ms)) / 2)

let eval_num board color m =
        let new_board = tryMove board m color in
        let after = count new_board color in
        let before = count board color in
        after - before

let search_move_middle ms board color depth =
        let alpha = -200 in
        let beta  = 200 in
        let values = List.map (alphabeta board color color depth alpha beta) ms in
        list_max values ms
let search_move_early ms board color depth = search_move_middle ms board color depth
let search_move_final1 ms board color =
        let values = List.map (eval_num board color) ms in
        list_max values ms
let search_move_final2 ms board color =
        let values = List.map (eval_num board color) ms in
        list_max values ms
let search_move ms board color =
        ctt := !ctt + 2;
        if middle_final1_to_final2 board then
                search_move_final2 ms board color
        else if middle_to_final1 board then
                search_move_final1 ms board color
        else if early_to_middle board then
                search_move_middle ms board color 2
        else
                search_move_early ms board color 0

let print_mv i j =
        print_string "-------------Mv (";
        print_int i;
        print_string ", ";
        print_int j;
        print_string ")-----------------\n";
        Mv (i,j)

let play board color = 
  let ms = valid_moves board color in 
    if ms = [] then 
      Pass 
    else
      let (i,j) = search_move ms board color in
      Mv(i,j)
