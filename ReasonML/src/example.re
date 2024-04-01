let p_e_escapeString = (s : string) : string => {
    let p_e_escapeChar = (c : char) : string => {
        switch (c) {
        | '\\' => "\\\\"
        | '\"' => "\\\""
        | '\n' => "\\n"
        | '\t' => "\\t"
        | _ => String.make(1, c)
        }
    };
    s |> String.to_seq |> List.of_seq |> List.map(p_e_escapeChar) |> String.concat("")
}

let p_e_bool = () => (b : bool) : string => {
    if (b) { "true" } else { "false" }
}

let p_e_int = () => (i : int) : string => {
    string_of_int(i)
}

let p_e_double = () => (d : float) : string => {
    let s0 = Printf.sprintf("%.7f", d);
    let s1 = String.sub(s0, 0, (String.length(s0) - 1));
    if (s1 == "-0.000000") { "0.000000" } else { s1 }
}

let p_e_string = () => (s : string) : string => {
    "\"" ++ p_e_escapeString(s) ++ "\""
}

let p_e_list = (f0 : 'a => string) => (lst : list('a)) : string => {
    "[" ++ String.concat(", ", (lst |> List.map(f0))) ++ "]"
}

let p_e_ulist = (f0 : 'a => string) => (lst : list('a)) : string => {
    "[" ++ String.concat(", ", (lst |> List.map(f0) |> List.sort(compare))) ++ "]"
}

let p_e_idict = (f0 : 'a => string) => (dct : Hashtbl.t(int, 'a)) : string => {
    let f1 ((k, v)) = p_e_int()(k) ++ "=>" ++ f0(v);
    "{" ++ String.concat(", ", dct |> Hashtbl.to_seq |> List.of_seq |> List.map(f1) |> List.sort(compare)) ++ "}"
}

let p_e_sdict = (f0 : 'a => string) => (dct : Hashtbl.t(string, 'a)) : string => {
    let f1 ((k, v)) = p_e_string()(k) ++ "=>" ++ f0(v);
    "{" ++ String.concat(", ", dct |> Hashtbl.to_seq |> List.of_seq |> List.map(f1) |> List.sort(compare)) ++ "}"
}

let p_e_option = (f0 : 'a => string) => (opt : option('a)) : string => {
    switch (opt) {
    | Some(x) => f0(x)
    | None => "null"
    }
}

$$code$$

let p_e_out = p_e_entry();
let oc = open_out("result.out");
Printf.fprintf(oc, "%s", p_e_out);
close_out(oc);


