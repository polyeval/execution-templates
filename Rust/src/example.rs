use std::collections::HashMap;

fn p_e_escape_string(s: &String) -> String {
    let p_e_escape_char = |c: char| match c {
        '\\' => "\\\\".to_string(),
        '\"' => "\\\"".to_string(),
        '\n' => "\\n".to_string(),
        '\t' => "\\t".to_string(),
        _ => c.to_string()
    };
    s.chars().map(p_e_escape_char).collect::<Vec<String>>().join("")
}

fn p_e_bool() -> impl Fn(&bool) -> String {
    |b| if *b { "true".to_string() } else { "false".to_string() }
}

fn p_e_int() -> impl Fn(&i32) -> String {
    |i| (*i).to_string()
}

fn p_e_double() -> impl Fn(&f64) -> String {
    |d| {
        let s0 = format!("{:.7}", *d);
        let s1 = s0[..s0.len()-1].to_string();
        if s1 == "-0.000000" { "0.000000".to_string() } else { s1 }
    }
}

fn p_e_string() -> impl Fn(&String) -> String {
    |s| format!("\"{}\"", p_e_escape_string(s))
}

fn p_e_list<V>(f0: impl Fn(&V) -> String) -> impl Fn(&Vec<V>) -> String {
    move |lst| format!("[{}]", lst.into_iter().map(&f0).collect::<Vec<String>>().join(", "))
}

fn p_e_ulist<V>(f0: impl Fn(&V) -> String) -> impl Fn(&Vec<V>) -> String {
    move |lst| { 
        let mut vs = lst.into_iter().map(&f0).collect::<Vec<String>>(); 
        vs.sort(); 
        format!("[{}]", vs.join(", ")) 
    }
}

fn p_e_idict<V>(f0: impl Fn(&V) -> String) -> impl Fn(&HashMap<i32, V>) -> String {
    let f1 = move |(k, v): (&i32, &V)| format!("{}=>{}", p_e_int()(k), f0(v));
    move |dct| {
        let mut vs = dct.into_iter().map(&f1).collect::<Vec<String>>();
        vs.sort();
        format!("{{{}}}", vs.join(", "))
    }
}

fn p_e_sdict<V>(f0: impl Fn(&V) -> String) -> impl Fn(&HashMap<String, V>) -> String {
    let f1 = move |(k, v): (&String, &V)| format!("{}=>{}", p_e_string()(k), f0(v));
    move |dct| {
        let mut vs = dct.into_iter().map(&f1).collect::<Vec<String>>();
        vs.sort();
        format!("{{{}}}", vs.join(", "))
    }
}

fn p_e_option<V>(f0: impl Fn(&V) -> String) -> impl Fn(&Option<V>) -> String {
    move |opt| match opt {
        Some(x) => f0(x),
        None => "null".to_string()
    }
}

$$code$$

fn main() {
    let p_e_out = p_e_entry();
    std::fs::write("result.out", p_e_out).unwrap();
}