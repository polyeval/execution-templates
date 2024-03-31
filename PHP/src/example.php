<?php

function p_e_escape_string($s) {
    $p_e_escape_char = function ($c) {
        if ($c === "\\") return "\\\\";
        if ($c === "\"") return "\\\"";
        if ($c === "\n") return "\\n";
        if ($c === "\t") return "\\t";
        return $c;
    };
    return implode(array_map($p_e_escape_char, str_split($s)));
}

function p_e_bool() {
    return fn(bool $b) => $b ? "true" : "false";
}

function p_e_int() {
    return fn(int $b) => strval($b);
}

function p_e_double() {
    return function(float $d) {
        $s0 = sprintf("%.7f", $d);
        $s1 = substr($s0, 0, strlen($s0) - 1);
        return $s1 === "-0.000000" ? "0.000000" : $s1;
    };
}

function p_e_string() {
    return fn(string $s) => "\"" . p_e_escape_string($s) . "\"";
}

function p_e_list($f0) {
    return function(array $lst) use ($f0) {
        return "[" . implode(", ", array_map($f0, $lst)) . "]";
    };
}

function p_e_ulist($f0) {
    return function(array $lst) use ($f0) {
        $vs = array_map($f0, $lst);
        sort($vs);
        return "[" . implode(", ", $vs) . "]";
    };
}

function p_e_idict($f0) {
    $f1 = fn($k, $v) => p_e_int()($k) . "=>" . $f0($v);
    return function(array $dct) use ($f1) {
        $vs = array_map($f1, array_keys($dct), array_values($dct));
        sort($vs);
        return "{" . implode(", ", $vs) . "}";
    };
}

function p_e_sdict($f0) {
    $f1 = fn($k, $v) => p_e_string()($k) . "=>" . $f0($v);
    return function(array $dct) use ($f1) {
        $vs = array_map($f1, array_keys($dct), array_values($dct));
        sort($vs);
        return "{" . implode(", ", $vs) . "}";
    };
}

function p_e_option($f0) {
    return function($opt) use ($f0) {
        return $opt !== null ? $f0($opt) : "null";
    };
}

$$code$$

$p_e_out = p_e_entry();
file_put_contents("result.out", $p_e_out);