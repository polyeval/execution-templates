p_e_escapeString = (s) ->
    p_e_escapeChar = (c) ->
        switch c
            when '\\' then "\\\\"
            when '"' then "\\\""
            when '\n' then "\\n"
            when '\t' then "\\t"            
            else c
    [...s].map(p_e_escapeChar).join('')

p_e_bool = ->
    (b) ->
        throw new Error() unless typeof b is "boolean"
        if b then "true" else "false"

p_e_int = ->
    (i) ->
        throw new Error() unless typeof i is "number" and Number.isInteger(i)
        i.toString()

p_e_double = ->
    (d) ->
        throw new Error() unless typeof d is "number"
        s0 = d.toFixed(7)
        s1 = s0.slice(0, -1)
        if s1 == "-0.000000" then "0.000000" else s1

p_e_string = ->
    (s) ->
        throw new Error() unless typeof s is "string"
        "\"" + p_e_escapeString(s) + "\""

p_e_list = (f0) ->
    (lst) ->
        throw new Error() unless Array.isArray(lst)
        "[" + lst.map(f0).join(", ") + "]"

p_e_ulist = (f0) ->
    (lst) ->
        throw new Error() unless Array.isArray(lst)
        "[" + lst.map(f0).sort().join(", ") + "]"

p_e_idict = (f0) ->
    f1 = ([k, v]) -> p_e_int()(k) + "=>" + f0(v)
    (dct) ->
        throw new Error() unless dct instanceof Map
        "{" + [...dct].map(f1).sort().join(", ") + "}"

p_e_sdict = (f0) ->
    f1 = ([k, v]) -> p_e_string()(k) + "=>" + f0(v)
    (dct) ->
        throw new Error() unless dct instanceof Map        
        "{" + [...dct].map(f1).sort().join(", ") + "}"

p_e_option = (f0) ->
    (opt) ->
        if opt != null  
            f0(opt)
        else
            "null"

$$code$$

p_e_out = p_e_entry()
require("fs").writeFileSync("result.out", p_e_out)