import Foundation

func p_e_escapeString(_ s: String) -> String {
    let p_e_escapeChar: (Character) -> String = { c in
        if c == "\\" { return "\\\\" }
        if c == "\"" { return "\\\"" }
        if c == "\n" { return "\\n" }
        if c == "\t" { return "\\t" }
        return String(c)
    }
    return s.map { p_e_escapeChar($0) }.joined()
}

func p_e_bool() -> (Bool) -> String {
    return { b in b ? "true" : "false" }
}

func p_e_int() -> (Int) -> String {
    return { i in String(i) }
}

func p_e_double() -> (Double) -> String {
    return { d in 
        let s0 = String(format: "%.7f", d)
        let s1 = String(s0.prefix(s0.count - 1))
        return s1 == "-0.000000" ? "0.000000" : s1
    }
}

func p_e_string() -> (String) -> String {
    return { s in "\"" + p_e_escapeString(s) + "\"" }
}

func p_e_list<V>(_ f0: @escaping (V) -> String) -> ([V]) -> String {
    return { lst in "[" + lst.map(f0).joined(separator: ", ") + "]" }
}

func p_e_ulist<V>(_ f0: @escaping (V) -> String) -> ([V]) -> String {
    return { lst in "[" + lst.map(f0).sorted().joined(separator: ", ") + "]" }
}

func p_e_idict<V>(_ f0: @escaping (V) -> String) -> ([Int: V]) -> String {
    let f1: (Int, V) -> String = { k, v in p_e_int()(k) + "=>" + f0(v) }
    return { dct in "{" + dct.map(f1).sorted().joined(separator: ", ") + "}" }
}

func p_e_sdict<V>(_ f0: @escaping (V) -> String) -> ([String: V]) -> String {
    let f1: (String, V) -> String = { k, v in p_e_string()(k) + "=>" + f0(v) }
    return { dct in "{" + dct.map(f1).sorted().joined(separator: ", ") + "}" }
}

func p_e_option<V>(_ f0: @escaping (V) -> String) -> (V?) -> String {
    return { opt in opt == nil ? "null" : f0(opt!) }
}

$$code$$

let p_e_out = p_e_entry()
try p_e_out.write(toFile: "result.out", atomically: false, encoding: .utf8)