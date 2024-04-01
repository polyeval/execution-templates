def p_e_escape_string(s : String) : String
    p_e_escape_char = ->(c : Char) : String {
        case c
            when '\\' then "\\\\"
            when '"' then "\\\""
            when '\n' then "\\n"
            when '\t' then "\\t"
            else c.to_s
        end
    }
    s.chars.map(&p_e_escape_char).join
end

def p_e_bool : (Bool -> String)
    ->(b : Bool) : String {
        b ? "true" : "false"
    }
end

def p_e_int : (Int32 -> String)

    ->(i : Int32) : String {
        i.to_s
    }
end

def p_e_double : (Float64 -> String)
    ->(d : Float64) : String {
        s0 = sprintf("%.7f", d)
        s1 = s0[0, s0.size - 1]
        s1 == "-0.000000" ? "0.000000"  : s1
    }
end

def p_e_string : (String -> String)
    ->(s : String) : String {
        "\"" + p_e_escape_string(s) + "\""
    }
end

def p_e_list(f0 : (V -> String)) : (Array(V) -> String) forall V
    ->(lst : Array(V)) : String {
        "[" + lst.map(&f0).join(", ") + "]"
    }
end

def p_e_ulist(f0 : (V -> String)) : (Array(V) -> String) forall V
    ->(lst : Array(V)) : String {
        "[" + lst.map(&f0).sort.join(", ") + "]"
    }
end

def p_e_idict(f0 : (V -> String)) : (Hash(Int32, V) -> String) forall V
    f1 = ->(kv : Tuple(Int32, V)) : String {
        p_e_int.call(kv[0]) + "=>" + f0.call(kv[1])
    }
    ->(dct : Hash(Int32, V)) : String {
        "{" + dct.map(&f1).sort.join(", ") + "}"
    }
end

def p_e_sdict(f0 : (V -> String)) : (Hash(String, V) -> String) forall V
    f1 = ->(kv : Tuple(String, V)) : String {
        p_e_string.call(kv[0]) + "=>" + f0.call(kv[1])
    }
    ->(dct : Hash(String, V)) : String {
        "{" + dct.map(&f1).sort.join(", ") + "}"
    }
end

def p_e_option(f0 : (V -> String)) : ((V | Nil) -> String) forall V 
    ->(opt : (V | Nil)) : String {
        opt.nil? ? "null" : f0.call(opt)
    }
end

$$code$$

p_e_out = p_e_entry()
File.write("result.out", p_e_out)