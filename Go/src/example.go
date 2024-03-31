package main

import (
    "fmt"
    "os"
    "slices"
    "strconv"
    "strings"
)

func p_e_escapeString(s string) string {
    p_e_escapeChar := func(c rune) string {
        if c == '\\' {
            return "\\\\"
        }
        if c == '"' {
            return "\\\""
        }
        if c == '\n' {
            return "\\n"
        }
        if c == '\t' {
            return "\\t"
        }
        return string(c)
    }
    res := []string{}
    for _, c := range s {
        res = append(res, p_e_escapeChar(c))
    }
    return strings.Join(res, "")
}

func p_e_bool() func(bool) string {
    return func(b bool) string {
        if b {
            return "true"
        } else {
            return "false"
        }
    }
}

func p_e_int() func(int) string {
    return func(i int) string {
        return strconv.Itoa(i)
    }
}

func p_e_double() func(float64) string {
    return func(d float64) string {
        s0 := fmt.Sprintf("%.7f", d)
        s1 := s0[:len(s0)-1]
        if s1 == "-0.000000" {
            return "0.000000"
        } else {
            return s1
        }
    }
}

func p_e_string() func(string) string {
    return func(s string) string {
        return "\"" + p_e_escapeString(s) + "\""
    }
}

func p_e_list[V any](f0 func(V) string) func([]V) string {
    return func(lst []V) string {
        vs := []string{}
        for _, e := range lst {
            vs = append(vs, f0(e))
        }
        return "[" + strings.Join(vs, ", ") + "]"
    }
}

func p_e_ulist[V any](f0 func(V) string) func([]V) string {
    return func(lst []V) string {
        vs := []string{}
        for _, e := range lst {
            vs = append(vs, f0(e))
        }
        slices.Sort(vs)
        return "[" + strings.Join(vs, ", ") + "]"
    }
}

func p_e_idict[V any](f0 func(V) string) func(map[int]V) string {
    f1 := func(k int, v V) string {
        return p_e_int()(k) + "=>" + f0(v)
    } 
    return func(dct map[int]V) string {
        vs := []string{}
        for k, v := range dct {
            vs = append(vs, f1(k, v))
        }
        slices.Sort(vs)
        return "{" + strings.Join(vs, ", ") + "}"
    }
}

func p_e_sdict[V any](f0 func(V) string) func(map[string]V) string {
    f1 := func(k string, v V) string {
        return p_e_string()(k) + "=>" + f0(v)
    }
    return func(dct map[string]V) string {
        vs := []string{}
        for k, v := range dct {
            vs = append(vs, f1(k, v))
        }
        slices.Sort(vs)
        return "{" + strings.Join(vs, ", ") + "}"
    }
}

func p_e_option[V any](f0 func(V) string) func(*V) string {
    return func(opt *V) string {
        if opt == nil {
            return "null"
        } else {
            return f0(*opt)
        }
    }
}

$$code$$

func main() {
    p_e_out := p_e_entry()
    f, _ := os.Create("result.out")
    f.WriteString(p_e_out)
    f.Close()
}