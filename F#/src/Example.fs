let p_e_escapeString (s : string) : string =
    let p_e_escapeChar (c : char) : string =
        match c with
        | '\\' -> "\\\\"
        | '\"' -> "\\\""
        | '\n' -> "\\n"
        | '\t' -> "\\t"
        | _ -> string c
    s |> Seq.map p_e_escapeChar |> Seq.fold (+) ""

let p_e_bool (b : bool) : string =
    if b then "true" else "false"

let p_e_int (i : int) : string =
    string i

let p_e_double (d : float) : string =
    let s0 = sprintf "%.7f" d
    let s1 = s0.Substring(0, s0.Length - 1)
    if s1 = "-0.000000" then "0.000000" else s1

let p_e_string (s : string) : string =
    "\"" + p_e_escapeString s + "\""

let p_e_list (f0 : 'a -> string) (lst : 'a list) : string =
    "[" + String.concat ", " (List.map f0 lst) + "]"

let p_e_ulist (f0 : 'a -> string) (lst : 'a list) : string =
    "[" + String.concat ", " (List.map f0 lst |> List.sort) + "]"

let p_e_idict (f0 : 'a -> string) (dct : Map<int, 'a>) : string =
    let f1 (k, v) = string k + "=>" + f0 v
    "{" + String.concat ", " (dct |> Map.toList |> List.map f1 |> List.sort ) + "}"

let p_e_sdict (f0 : 'a -> string) (dct : Map<string, 'a>) : string =
    let f1 (k, v) = p_e_string k + "=>" + f0 v
    "{" + String.concat ", " (dct |> Map.toList |> List.map f1 |> List.sort ) + "}"

let p_e_option (f0 : 'a -> string) (opt : 'a option) : string =
    match opt with
    | Some x -> f0 x
    | None -> "null"

$$code$$

let p_e_out = p_e_entry ()
System.IO.File.WriteAllText("result.out", p_e_out)