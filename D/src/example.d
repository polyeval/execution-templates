import std.stdio;
import std.string;
import std.conv;
import std.algorithm;
import std.typecons;
import std.array;
import std.functional;

string p_e_escapeString(string s) {
    string p_e_escapeChar(dchar c) {
        if (c == '\\') return "\\\\";
        if (c == '\"') return "\\\"";
        if (c == '\n') return "\\n";
        if (c == '\t') return "\\t";
        return to!string(c);
    }
    return s.map!(p_e_escapeChar).join("");
}

string delegate(bool) p_e_bool() {
    return b => b ? "true" : "false";
}

string delegate(int) p_e_int() {
    return i => to!string(i);
}

string delegate(double) p_e_double() {
    return (d) {
        string s0 = format("%.7f", d);
        string s1 = s0[0 .. $ - 1];
        return s1 == "-0.000000" ? "0.000000": s1;
    };
}

string delegate(string) p_e_string() {
    return s => "\"" ~ p_e_escapeString(s) ~ "\"";
}

string delegate(V[]) p_e_list(V)(string delegate(V) f0) {
    return (V[] lst) {
        return "[" ~ lst.map!(f0).join(", ") ~ "]";
    };
}

string delegate(V[]) p_e_ulist(V)(string delegate(V) f0) {
    return (V[] lst) {
        return "[" ~ lst.map!(f0).array.sort().join(", ") ~ "]";
    };
}

string delegate(V[int]) p_e_idict(V)(string delegate(V) f0) {
    string delegate(Tuple!(int, V)) f1 = kv => p_e_int()(kv[0]) ~ "=>" ~ f0(kv[1]);
    return (V[int] dct) {        
        return "{" ~ dct.byPair.map!(f1).array.sort().join(", ") ~ "}";
    };
}

string delegate(V[string]) p_e_sdict(V)(string delegate(V) f0) {
    string delegate(Tuple!(string, V)) f1 = kv => p_e_string()(kv[0]) ~ "=>" ~ f0(kv[1]);
    return (V[string] dct) {        
        return "{" ~ dct.byPair.map!(f1).array.sort().join(", ") ~ "}";
    };
}

string delegate(Nullable!V) p_e_option(V)(string delegate(V) f0) {
    return (Nullable!V opt) {
        return opt.isNull ? "null" : f0(opt.get);
    };
}

$$code$$

void main() {
    string p_e_out = p_e_entry();
    File("result.out", "w").write(p_e_out);
}