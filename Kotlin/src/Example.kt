fun p_e_escapeString(s: String): String {
    val p_e_escapeChar = { c: Char ->
        when (c) {
            '\\' -> "\\\\"
            '\"' -> "\\\""
            '\n' -> "\\n"
            '\t' -> "\\t"
            else -> c.toString()
        }
    }
    return s.map(p_e_escapeChar).joinToString("")
}

fun p_e_bool(): (Boolean) -> String {
    return { b -> if (b) "true" else "false" }
}

fun p_e_int(): (Int) -> String {
    return { i -> i.toString() }
}

fun p_e_double(): (Double) -> String {
    return { d -> 
        val s0 = String.format("%.7f", d)
        val s1 = s0.substring(0, s0.length - 1)
        if (s1 == "-0.000000") "0.000000" else s1
    }
}

fun p_e_string(): (String) -> String {
    return { s -> "\"" + p_e_escapeString(s) + "\"" }
}

fun <V> p_e_list(f0: (V) -> String): (List<V>) -> String {
    return { lst -> "[" + lst.map(f0).joinToString(", ") + "]" }
}

fun <V> p_e_ulist(f0: (V) -> String): (List<V>) -> String {
    return { lst -> "[" + lst.map(f0).sorted().joinToString(", ") + "]" }
}

fun <V> p_e_idict(f0: (V) -> String): (Map<Int, V>) -> String {
    val f1 = { kv: Map.Entry<Int, V> -> p_e_int()(kv.key) + "=>" + f0(kv.value) }
    return { dct -> "{" + dct.entries.map(f1).sorted().joinToString(", ") + "}" }
}

fun <V> p_e_sdict(f0: (V) -> String): (Map<String, V>) -> String {
    val f1 = { kv: Map.Entry<String, V> -> p_e_string()(kv.key) + "=>" + f0(kv.value) }
    return { dct -> "{" + dct.entries.map(f1).sorted().joinToString(", ") + "}" }
}

fun <V> p_e_option(f0: (V) -> String): (V?) -> String {
    return { opt -> if (opt == null) "null" else f0(opt!!) }
}

$$code$$

fun main() {
    val p_e_out = p_e_entry()
    val f = java.io.File("result.out")
    f.writeText(p_e_out)
}