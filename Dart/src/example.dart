import "dart:io";

String p_e_escapeString(String s) {
    String p_e_escapeChar(String c) {
        if (c == '\\') return "\\\\";
        if (c == '\"') return "\\\"";
        if (c == '\n') return "\\n";
        if (c == '\t') return "\\t";
        return c;
    }
    return s.split('').map(p_e_escapeChar).join('');
}

String Function(bool) p_e_bool() {
    return (b) => b ? "true" : "false";
}

String Function(int) p_e_int() {
    return (i) => i.toString();
}

String Function(double) p_e_double() {
    return (d) {
        String s0 = d.toStringAsFixed(7);
        String s1 = s0.substring(0, s0.length - 1);
        return s1 == "-0.000000" ? "0.000000" : s1;
    };
}

String Function(String) p_e_string() {
    return (s) => "\"" + p_e_escapeString(s) + "\"";
}

String Function(List<V>) p_e_list<V>(String Function(V) f0) {
    return (List<V> lst) {
        return "[" + lst.map(f0).join(", ") + "]";
    };
}

String Function(List<V>) p_e_ulist<V>(String Function(V) f0) {
    return (List<V> lst) {
        return "[" + (lst.map(f0).toList()..sort()).join(", ") + "]";
    };
}

String Function(Map<int, V>) p_e_idict<V>(String Function(V) f0) {
    var f1 = (MapEntry<int, V> e) => p_e_int()(e.key) + "=>" + f0(e.value);
    return (Map<int, V> dct) {        
        return "{" + (dct.entries.map(f1).toList()..sort()).join(", ") + "}";
    };
}

String Function(Map<String, V>) p_e_sdict<V>(String Function(V) f0) {
    var f1 = (MapEntry<String, V> e) => p_e_string()(e.key) + "=>" + f0(e.value);
    return (Map<String, V> dct) {
        return "{" + (dct.entries.map(f1).toList()..sort()).join(", ") + "}";
    };
}

String Function(V?) p_e_option<V>(String Function(V) f0) {
    return (V? opt) {
        return opt == null ? "null" : f0(opt);
    };
}

$$code$$

void main() {
    var p_e_out = p_e_entry();
    var file = File("result.out").writeAsStringSync(p_e_out);
}