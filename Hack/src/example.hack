use HH\Lib\C;
use HH\Lib\Vec;
use HH\Lib\Str;
use HH\Lib\Dict;

function p_e_escape_string(string $s): string {
    $p_e_escape_char = (string $c): string ==> {
        if ($c === "\\") return "\\\\";
        if ($c === "\"") return "\\\"";
        if ($c === "\n") return "\\n";
        if ($c === "\t") return "\\t";
        return $c;
    };
    return Str\join(Vec\map(Str\chunk($s), $p_e_escape_char), "");
}

function p_e_bool(): (function(bool): string) {
    return $b ==> $b ? "true" : "false";
}

function p_e_int(): (function(int): string) {
    return $i ==> (string)$i;
}

function p_e_double(): (function(float): string) {
    return $d ==> {
        $s0 = Str\format("%.7f", $d);
        $s1 = Str\slice($s0, 0, Str\length($s0) - 1);
        return $s1 === "-0.000000" ? "0.000000" : $s1;
    };
}

function p_e_string(): (function(string): string) {
    return $s ==> "\"" . p_e_escape_string($s) . "\"";
}

function p_e_list<V>((function(V): string) $f0): (function(vec<V>): string) {
    return (vec<V> $lst): string ==> {
        return "[" . Str\join(Vec\map($lst, $f0), ", ") . "]";
    };
}

function p_e_ulist<V>((function(V): string) $f0): (function(vec<V>): string) {
    return (vec<V> $lst): string ==> {
        return "[" . Str\join(Vec\sort(Vec\map($lst, $f0)), ", ") . "]";
    };
}

function p_e_idict<V>((function(V): string) $f0): (function(dict<int, V>): string) {
    $f1 = (int $k, V $v): string ==> p_e_int()($k) . "=>" . $f0($v);
    return (dict<int, V> $dct): string ==> {        
        return "{" . Str\join(Vec\sort(Dict\map_with_key($dct, $f1)), ", ") . "}";
    };
}

function p_e_sdict<V>((function(V): string) $f0): (function(dict<string, V>): string) {
     $f1 = (string $k, V $v): string ==> p_e_string()($k) . "=>" . $f0($v);
    return (dict<string, V> $dct): string ==> {       
        return "{" . Str\join(Vec\sort(Dict\map_with_key($dct, $f1)), ", ") . "}";
    };
}

function p_e_option<V>((function(V): string) $f0): (function(?V): string) {
    return (?V $opt): string ==> $opt !== null ? $f0($opt) : "null";
}

$$code$$

<<__EntryPoint>>
function main(): void {
    $p_e_out = p_e_entry();
    $file = fopen("result.out", "w");
    fwrite($file, $p_e_out);
}