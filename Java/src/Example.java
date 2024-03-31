import java.io.*;
import java.util.*;
import java.util.function.*;
import java.util.stream.*;

public class Example {
    static String p_e_escapeString(String s) {
        Function<Character, String> p_e_escapeChar = c -> {
            if (c == '\\') return "\\\\";
            if (c == '\"') return "\\\"";
            if (c == '\n') return "\\n";
            if (c == '\t') return "\\t";
            return Character.toString(c);
        };
        return s.chars().mapToObj(c -> p_e_escapeChar.apply((char)c)).collect(Collectors.joining());
    }
    
    static Function<Boolean, String> p_e_bool() {
        return b -> b ? "true" : "false";
    }

    static Function<Integer, String> p_e_int() {
        return i -> Integer.toString(i);
    }

    static Function<Double, String> p_e_double() {
        return d -> {
            String s0 = String.format("%.7f", d);
            String s1 = s0.substring(0, s0.length() - 1);
            return s1.equals("-0.000000") ? "0.000000" : s1;
        };
    }

    static Function<String, String> p_e_string() {
        return s -> "\"" + p_e_escapeString(s) + "\"";
    }
    
    static <V> Function<List<V>, String> p_e_list(Function<V, String> f0) {
        return lst -> "[" + lst.stream().map(f0).collect(Collectors.joining(", ")) + "]";
    }

    static <V> Function<List<V>, String> p_e_ulist(Function<V, String> f0) {
        return lst -> "[" + lst.stream().map(f0).sorted().collect(Collectors.joining(", ")) + "]";
    }

    static <V> Function<Map<Integer, V>, String> p_e_idict(Function<V, String> f0) {
        Function<Map.Entry<Integer, V>, String> f1 = kv -> p_e_int().apply(kv.getKey()) + "=>" + f0.apply(kv.getValue());
        return dct -> "{" + dct.entrySet().stream().map(f1).sorted().collect(Collectors.joining(", ")) + "}";
    }

    static <V> Function<Map<String, V>, String> p_e_sdict(Function<V, String> f0) {
        Function<Map.Entry<String, V>, String> f1 = kv -> p_e_string().apply(kv.getKey()) + "=>" + f0.apply(kv.getValue());
        return dct -> "{" + dct.entrySet().stream().map(f1).sorted().collect(Collectors.joining(", ")) + "}";
    }

    static <V> Function<Optional<V>, String> p_e_option(Function<V, String> f0) {
        return opt -> opt.isPresent() ? f0.apply(opt.get()) : "null";
    }
    
    $$code$$

    public static void main(String[] args) throws IOException {
        String p_e_out = p_e_entry();
        try (PrintWriter writer = new PrintWriter("result.out")) {
            writer.print(p_e_out);
        }
    }
}
