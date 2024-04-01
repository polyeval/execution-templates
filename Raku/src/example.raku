sub p_e_escape-string(Str $s) {
    my $p_e_escape-char = -> Str $c {
        given $c {
            when "\n" { "\\n" }
            when "\t" { "\\t" }
            when "\\"  { "\\\\" }
            when "\""  { "\\\"" }
            default { $c }
        }
    };
    return $s.comb.map($p_e_escape-char).join;
}

sub p_e_bool() {
    return -> Bool $b { $b ?? "true" !! "false" };
}

sub p_e_int() {
    return -> Int $i { $i.Str };
}

sub p_e_double() {
    return -> Rat $d { 
        my $s0 = sprintf("%.7f", $d);
        my $s1 = substr($s0, 0, $s0.chars - 1);
        $s1 eq "-0.000000" ?? "0.000000" !! $s1
    }
}

sub p_e_string() {
    return -> Str $s { "\"" ~ p_e_escape-string($s) ~ "\"" };
}

sub p_e_list($f0) {
    return -> Array $lst { "[" ~ $lst.map($f0).join(", ") ~ "]" };
}

sub p_e_ulist($f0) {
    return -> Array $lst { "[" ~ $lst.map($f0).sort.join(", ") ~ "]" };
}

sub p_e_idict($f0) {
    my $f1 = -> $kv { p_e_int().($kv.key) ~ "=>" ~ $f0.($kv.value) };
    return -> Hash $dct { "\{" ~ $dct.map($f1).sort.join(", ") ~ "\}" };
}

sub p_e_sdict($f0) {
    my $f1 = -> $kv { p_e_string().($kv.key) ~ "=>" ~ $f0.($kv.value) };
    return -> Hash $dct { "\{" ~ $dct.map($f1).sort.join(", ") ~ "\}" };
}

sub p_e_option($f0) {
    return -> $opt { $opt.defined ?? $f0.($opt) !! "null" };
}

$$code$$

my $p_e_out = p_e_entry();
spurt "result.out", $p_e_out;