import strutils
import options
import algorithm
import sequtils
import tables
import typetraits
import sugar

proc p_e_escapeString(s: string): string =
    let p_e_escapeChar = proc (c: char): string =
        if c == '\\': return "\\\\"
        if c == '\"': return "\\\""
        if c == '\n': return "\\n"
        if c == '\t': return "\\t"
        return $c
    result = s.map(p_e_escapeChar).join("")

proc p_e_bool(): proc (b: bool): string =
    result = (b: bool) => (if b: "true" else: "false")

proc p_e_int(): proc (i: int): string =
    result = (i: int) => $i

proc p_e_double(): proc (d: float): string =
    result = proc (d: float): string =
        let s0 = d.formatFloat(ffDecimal, 7)
        let s1 = s0.substr(0, s0.len - 2)
        result = if s1 == "-0.000000": "0.000000" else: s1

proc p_e_string(): proc (s: string): string =
    result = (s: string) => "\"" & p_e_escapeString(s) & "\""

proc p_e_list[V](f0: proc (v: V): string): proc (lst: seq[V]): string =
    result = (lst: seq[V]) => "[" & lst.map(f0).join(", ") & "]"

proc p_e_ulist[V](f0: proc (v: V): string): proc (lst: seq[V]): string =
    result = (lst: seq[V]) => "[" & lst.map(f0).sorted().join(", ") & "]"

proc p_e_idict[V](f0: proc (v: V): string): proc (dct: Table[int, V]): string =
    let f1 = proc (kv: (int, V)): string = p_e_int()(kv[0]) & "=>" & f0(kv[1])
    result = (dct: Table[int, V]) => 
        "{" & toSeq(dct.pairs).map(f1).sorted().join(", ") & "}"

proc p_e_sdict[V](f0: proc (v: V): string): proc (dct: Table[string, V]): string =
    let f1 = proc (kv: (string, V)): string = p_e_string()(kv[0]) & "=>" & f0(kv[1])
    result = (dct: Table[string, V]) =>
        "{" & toSeq(dct.pairs).map(f1).sorted().join(", ") & "}"
    
proc p_e_option[V](f0: proc (v: V): string): proc (opt: Option[V]): string =
    result = (opt: Option[V]) => (if opt.isSome: f0(opt.get) else: "null")

$$code$$

var p_e_out = p_e_entry()
writeFile("result.out", p_e_out)