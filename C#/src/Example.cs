using System;
using System.Collections.Generic;
using System.Linq;

class Example {
    static string p_e_EscapeString(string s) {
        string p_e_EscapeChar(char c) {
            if (c == '\\') return "\\\\";
            if (c == '\"') return "\\\"";
            if (c == '\n') return "\\n";
            if (c == '\t') return "\\t";
            return c.ToString();
        };
        return string.Concat(s.Select(p_e_EscapeChar));
    }

    static Func<bool, string> p_e_bool() {
        return b => b ? "true" : "false";
    }

    static Func<int, string> p_e_int() {
        return i => i.ToString();
    }

    static Func<double, string> p_e_double() {
        return d => {
            string s0 = d.ToString("F7");
            string s1 = s0.Substring(0, s0.Length - 1);
            return (s1 == "-0.000000") ? "0.000000" : s1;
        };
    }

    static Func<string, string> p_e_string() {
        return s => "\"" + p_e_EscapeString(s) + "\"";
    }
    
    static Func<List<T>, string> p_e_list<T>(Func<T, string> f0) {
        return lst => "[" + string.Join(", ", lst.Select(f0)) + "]";
    }

    static Func<List<T>, string> p_e_ulist<T>(Func<T, string> f0) {
        return lst => "[" + string.Join(", ", lst.Select(f0).OrderBy(x => x)) + "]";
    }

    static Func<Dictionary<int, T>, string> p_e_idict<T>(Func<T, string> f0) {
        Func<KeyValuePair<int, T>, string> f1 = kv => p_e_int()(kv.Key) + "=>" + f0(kv.Value);
        return dct => "{" + string.Join(", ", dct.Select(f1).OrderBy(x => x)) + "}";
    }

    static Func<Dictionary<string, T>, string> p_e_sdict<T>(Func<T, string> f0) {
        Func<KeyValuePair<string, T>, string> f1 = kv => p_e_string()(kv.Key) + "=>" + f0(kv.Value);
        return dct => "{" + string.Join(", ", dct.Select(f1).OrderBy(x => x)) + "}";
    }

    static Func<Nullable<T>, string> p_e_option<T>(Func<T, string> f0) where T : struct {
        return opt => (opt.HasValue ? f0(opt.Value) : "null");
    }

    $$code$$

    static void Main() {
        var p_e_out = p_e_entry();
        System.IO.File.WriteAllText("result.out", p_e_out);
    }
}