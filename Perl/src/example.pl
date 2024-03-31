use strict;

use builtin qw(true false is_bool);
use feature qw(signatures);
use List::Util qw(
  reduce any all none notall first reductions 
  max maxstr min minstr product sum sum0 
  pairs unpairs pairkeys pairvalues pairfirst pairgrep pairmap 
  shuffle uniq uniqint uniqnum uniqstr zip mesh
);

sub p_e_escape_string($s) {
    my $p_e_escape_char = sub($c) {
        if ($c eq "\\") { return "\\\\"; }
        if ($c eq "\"") { return "\\\""; }
        if ($c eq "\n") { return "\\n"; }
        if ($c eq "\t") { return "\\t"; }
        return $c;
    };
    return join("", map { $p_e_escape_char->($_) } split(//, $s));
}

sub p_e_bool() {
    return sub($b) {
        unless (is_bool($b)) { die; }
        return $b ? "true" : "false";
    };
}

sub p_e_int() {
    return sub($i) {
        unless ($i =~ /^-?\d+\z/) { die; }
        return $i;
    };
}

sub p_e_double() {
    return sub($d) {
        unless ($d =~ /^-?(?:\d+\.?|\.\d)\d*\z/) { die; }
        my $s0 = sprintf("%.7f", $d);
        my $s1 = substr($s0, 0, length($s0) - 1);
        return $s1 eq "-0.000000" ? "0.000000" : $s1;
    };
}

sub p_e_string() {
    return sub($s) {
        return "\"" . p_e_escape_string($s) . "\"";
    };
}

sub p_e_list($f0) {
    return sub($lst) {
        unless (ref $lst eq "ARRAY") { die; }
        return "[" . join(", ", map { $f0->($_) } @$lst) . "]";
    };
}

sub p_e_ulist($f0) {
    return sub($lst) {
        unless (ref $lst eq "ARRAY") { die; }
        return "[" . join(", ", sort map { $f0->($_) } @$lst) . "]";
    };
}

sub p_e_idict($f0) {
    my $f1 = sub($k, $v) {
        return p_e_int()->($k) . "=>" . $f0->($v);
    };
    return sub($dct) {
        unless (ref $dct eq "HASH") { die; }
        return "{" . join(", ", sort { $a cmp $b } (pairmap { $f1->($a, $b) } %$dct)) . "}";
    };
}

sub p_e_sdict($f0) {
    my $f1 = sub($k, $v) {
        return p_e_string()->($k) . "=>" . $f0->($v);
    };
    return sub($dct) {
        unless (ref $dct eq "HASH") { die; }
        return "{" . join(", ", sort { $a cmp $b } (pairmap { $f1->($a, $b) } %$dct)) . "}";
    };
}

sub p_e_option($f0) {
    return sub($opt) {
        return $opt ? $f0->($opt) : "null";
    };
}

$$code$$

my $p_e_out = p_e_entry();
open(my $fh, ">", "result.out");
print $fh $p_e_out;
close $fh;