module Fs = NodeJs.Fs
module Buffer = NodeJs.Buffer

let p_e_escapeString = (s: string): string => {
    let p_e_escapeChar = (c: string): string =>
        switch c {
        | "\\" => "\\\\"
        | "\"" => "\\\""
        | "\n" => "\\n"
        | "\t" => "\\t"
        | _ => c
        }
    s->String.split("")->Array.map(p_e_escapeChar)->Array.joinWith("")
}

let p_e_bool = () => (b: bool): string => {
    if b { "true" } else { "false" }
}

let p_e_int = () => (i: int): string => {
    Int.toString(i)
}

let p_e_double = () => (d: float): string => {
    let s0 = Float.toFixedWithPrecision(d, ~digits=7)
    let s1 = String.substring(s0, ~start=0, ~end=String.length(s0) - 1)
    if s1 == "-0.000000" { "0.000000" } else { s1 }
}

let p_e_string = () => (s: string): string => {
    "\"" ++ p_e_escapeString(s) ++ "\""
}

let p_e_list = (f0: 'a => string) => (lst: array<'a>): string => {
    "[" ++ lst->Array.map(f0)->Array.joinWith(", ") ++ "]"
}

let p_e_ulist = (f0: 'a => string) => (lst: array<'a>): string => {
    "[" ++ lst->Array.map(f0)->Array.toSorted(String.compare)->Array.joinWith(", ") ++ "]"
}

let p_e_idict = (f0: 'a => string) => (dct: Map.t<int, 'a>): string => {
    let f1 = ((k: int, v: 'a)): string => p_e_int()(k) ++ "=>" ++ f0(v)
    "{" ++ dct->Map.entries->Iterator.toArray->Array.map(f1)->Array.toSorted(String.compare)->Array.joinWith(", ") ++ "}"
}

let p_e_sdict = (f0: 'a => string) => (dct: Map.t<string, 'a>): string => {
    let f1 = ((k: string, v: 'a)): string => p_e_string()(k) ++ "=>" ++ f0(v)
    "{" ++ dct->Map.entries->Iterator.toArray->Array.map(f1)->Array.toSorted(String.compare)->Array.joinWith(", ") ++ "}"
}

let p_e_option = (f0: 'a => string) => (opt: option<'a>): string => {
    switch opt {
    | Some(v) => f0(v)
    | None => "null"
    }
}

$$code$$

let p_e_out = p_e_entry();
Fs.writeFileSync("result.out", p_e_out->Buffer.fromString)