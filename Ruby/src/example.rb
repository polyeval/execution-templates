def p_e_escape_string(s)
    p_e_escape_char = lambda do |c|
        case c 
            when "\\" then "\\\\"
            when "\"" then "\\\""
            when "\n" then "\\n"
            when "\t" then "\\t"
            else c
        end
    end
    s.chars.map(&p_e_escape_char).join
end

def p_e_bool()
    lambda do |b|
        raise "" unless b.is_a?(TrueClass) || b.is_a?(FalseClass)
        b ? "true" : "false"
    end
end

def p_e_int()
    lambda do |i|
        raise "" unless i.is_a?(Integer)
        i.to_s
    end
end

def p_e_double()
    lambda do |d|
        raise "" unless d.is_a?(Float)
        s0 = "%.7f" % d
        s1 = s0[0..-2]
        if s1 == "-0.000000" then "0.000000" else s1 end
    end
end

def p_e_string()
    lambda do |s|
        raise "" unless s.is_a?(String)
        "\"" + p_e_escape_string(s) + "\""
    end
end

def p_e_list(f0)
    lambda do |lst|
        raise "" unless lst.is_a?(Array)
        "[" + lst.map(&f0).join(", ") + "]"
    end
end

def p_e_ulist(f0)
    lambda do |lst|
        raise "" unless lst.is_a?(Array)
        "[" + lst.map(&f0).sort.join(", ") + "]"
    end
end

def p_e_idict(f0)
    f1 = lambda { |k, v| p_e_int.call(k) + "=>" + f0.call(v) }
    lambda do |dct|
        raise "" unless dct.is_a?(Hash)
        "{" + dct.map(&f1).sort.join(", ") + "}"
    end
end

def p_e_sdict(f0)
    f1 = lambda { |k, v| p_e_string.call(k) + "=>" + f0.call(v) }
    lambda do |dct|
        raise "" unless dct.is_a?(Hash)
        "{" + dct.map(&f1).sort.join(", ") + "}"
    end
end

def p_e_option(f0)
    lambda do |opt|
        if opt.nil? then "null" else f0.call(opt) end
    end
end

$$code$$

p_e_out = p_e_entry()
File.open("result.out", "w") { |f| f.write(p_e_out) }