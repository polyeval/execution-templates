def p_e_escapeString(s) {
    def p_e_escapeChar = { c ->
        if (c == '\\') return "\\\\"
        if (c == '\"') return "\\\""
        if (c == '\n') return "\\n"
        if (c == '\t') return "\\t"
        return c.toString()
    }
    return s.collect { p_e_escapeChar(it) }.join()
}

def p_e_bool() {
    return { Boolean b -> b ? "true" : "false" }
}

def p_e_int() {
    return {Integer i -> i.toString() }
}

def p_e_double() {
    return { BigDecimal d -> 
        def s0 = String.format("%.7f", d)
        def s1 = s0.substring(0, s0.length() - 1)
        return s1 == "-0.000000" ? "0.000000" : s1
    }
}

def p_e_string() {
    return { String s -> "\"" + p_e_escapeString(s) + "\"" }
}

def p_e_list(f0) {
    return { List lst ->
        return "[" + lst.collect(f0).join(", ") + "]"
    }
}

def p_e_ulist(f0) {
    return { List lst ->
        return "[" + lst.collect(f0).sort().join(", ") + "]"
    }
}

def p_e_idict(f0) {
    def f1 = { k, v -> p_e_int()(k) + "=>" + f0(v) }
    return { Map dct ->        
        return "{" + dct.collect(f1).sort().join(", ") + "}"
    }
}

def p_e_sdict(f0) {
    def f1 = { k, v -> p_e_string()(k) + "=>" + f0(v) }
    return { Map dct ->        
        return "{" + dct.collect(f1).sort().join(", ") + "}"
    }
}

def p_e_option(f0) {
    return { opt -> opt != null ? f0(opt) : "null" }
}

$$code$$

p_e_out = p_e_entry()
new File("result.out").text = p_e_out