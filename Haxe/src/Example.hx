using Lambda;

class Example {

    // Code from https://stackoverflow.com/questions/23689001/how-to-reliably-format-a-floating-point-number-to-a-specified-number-of-decimal
    public static function p_e_Round(n:Float,prec:Int)
    {
        if(n==0)
            return "0." + ([for(i in 0...prec) "0"].join(""));

        var minusSign:Bool = (n<0.0);
        n = Math.abs(n);
        var intPart:Int = Math.floor(n);
        var p = Math.pow(10, prec);
        var fracPart = Math.round( p*(n - intPart) );
        var buf:StringBuf = new StringBuf();

        if(minusSign)
            buf.addChar("-".code);
        buf.add(Std.string(intPart));

        if(fracPart==0)
        {
            buf.addChar(".".code);
            for(i in 0...prec)
                buf.addChar("0".code);
        }
        else 
        {
            buf.addChar(".".code);
            p = p/10;
            var nZeros:Int = 0;
            while(fracPart<p)
            {
                p = p/10;
                buf.addChar("0".code);
            }
            buf.add(fracPart);
        }
        return buf.toString();
    }

    static function p_e_escapeString(s: String): String {
        function p_e_escapeChar(c: String): String {
            switch c {
                case "\\": return "\\\\";
                case "\"": return "\\\"";
                case "\n": return "\\n";
                case "\t": return "\\t";
                case _: return c;
            }
        }
        return s.split("").map(p_e_escapeChar).join("");
    }

    static function p_e_bool(): Bool -> String {
        return function(b) { return b ? "true" : "false"; };
    }

    static function p_e_int(): Int -> String {
        return function(i) { return Std.string(i); };
    }

    static function p_e_double(): Float -> String {
        return function(d) { 
            var s0 = p_e_Round(d, 7);
            var s1 = s0.substring(0, s0.length - 1);
            return s1 == "-0.000000" ? "0.000000" : s1;
        };
    }

    static function p_e_string(): String -> String {
        return function(s) { return "\"" + p_e_escapeString(s) + "\""; };
    }

    static function p_e_list<V>(f0: V -> String): Array<V> -> String {
        return function(lst) {
            return "[" + lst.map(f0).join(", ") + "]";
        };
    }

    static function p_e_ulist<V>(f0: V -> String): Array<V> -> String {
        return function(lst) {
            var vs = lst.map(f0);
            vs.sort(Reflect.compare);
            return "[" + vs.join(", ") + "]";
        };
    }
    
    static function p_e_idict<V>(f0: V -> String): Map<Int, V> -> String {
        function f1(k: Int, v: V): String {
            return p_e_int()(k) + "=>" + f0(v);
        }
        return function(dct) {
            var vs = [for (k => v in dct) f1(k, v)];
            vs.sort(Reflect.compare);
            return "{" + vs.join(", ") + "}";
        };
    }

    static function p_e_sdict<V>(f0: V -> String): Map<String, V> -> String {
        function f1(k: String, v: V): String {
            return p_e_string()(k) + "=>" + f0(v);
        }
        return function(dct) {
            var vs = [for (k => v in dct) f1(k, v)];
            vs.sort(Reflect.compare);
            return "{" + vs.join(", ") + "}";
        };
    }

    static function p_e_option<V>(f0: V -> String): Null<V> -> String {
        return function(opt) {
            return opt == null ? "null" : f0(opt);
        };
    }

    $$code$$
    
    static function main() {
        var p_e_out = p_e_entry();
        sys.io.File.saveContent("result.out", p_e_out);
    }
}