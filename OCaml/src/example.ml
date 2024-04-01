#require "containers";;

let p_e_escape_string (s : string) : string =
    let p_e_escape_char (c : char) : string =
        match c with
        | '\\' -> "\\\\"
        | '\"' -> "\\\""
        | '\n' -> "\\n"
        | '\t' -> "\\t"
        | _ -> String.make 1 c
    in s |> String.to_seq |> List.of_seq |> List.map p_e_escape_char |> String.concat ""

let p_e_bool (b : bool) : string =
    if b then "true" else "false"

let p_e_int (i : int) : string =
    string_of_int i

let p_e_double (d : float) : string =
    let s0 = Printf.sprintf "%.7f" d 
    in let s1 = String.sub s0 0 (String.length s0 - 1)
    in if s1 = "-0.000000" then "0.000000" else s1

let p_e_string (s : string) : string =
    "\"" ^ p_e_escape_string s ^ "\""

let p_e_list (f0 : 'a -> string) (lst : 'a list) : string =
    "[" ^ String.concat ", " (lst |> List.map f0) ^ "]"

let p_e_ulist (f0 : 'a -> string) (lst : 'a list) : string =
    "[" ^ String.concat ", " (lst |> List.map f0 |> List.sort compare) ^ "]"

let p_e_idict (f0 : 'a -> string) (dct : (int, 'a) Hashtbl.t) : string =
    let f1 (k, v) = p_e_int k ^ "=>" ^ f0 v
    in "{" ^ String.concat ", " (dct |> Hashtbl.to_seq |> List.of_seq |> List.map f1 |> List.sort compare) ^ "}"

let p_e_sdict (f0 : 'a -> string) (dct : (string, 'a) Hashtbl.t) : string =
    let f1 (k, v) = p_e_string k ^ "=>" ^ f0 v
    in "{" ^ String.concat ", " (dct |> Hashtbl.to_seq |> List.of_seq |> List.map f1 |> List.sort compare) ^ "}"

let p_e_option (f0 : 'a -> string) (opt : 'a option) : string =
    match opt with
    | Some x -> f0 x
    | None -> "null"

$$code$$

let () =
    let p_e_out = p_e_entry
    in
    let oc = open_out "result.out" in
    Printf.fprintf oc "%s" p_e_out;
    close_out oc