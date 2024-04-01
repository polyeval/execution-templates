using Printf

function p_e_escape_string(s::String)::String
    p_e_escape_char(c::Char)::String = begin
        if c == '\\' 
            return "\\\\"
        elseif c == '\"' 
            return "\\\""
        elseif c == '\n' 
            return "\\n"
        elseif c == '\t' 
            return "\\t"
        else
            return string(c)
        end
    end
    return join(map(p_e_escape_char, collect(s)))
end

function p_e_bool()
    return (b::Bool) -> b ? "true" : "false"
end

function p_e_int()
    return (i::Int) -> string(i)
end

function p_e_double()
    return (d::Float64) -> begin
        s0 = @sprintf("%.7f", d)
        s1 = s0[1:end-1]
        s1 == "-0.000000" ? "0.000000" : s1
    end
end

function p_e_string()
    return (s::String) -> "\"" * p_e_escape_string(s) * "\""
end

function p_e_list(f0)
    return (lst::Vector) -> "[" * join(map(f0, lst), ", ") * "]"
end

function p_e_ulist(f0)
    return (lst::Vector)  -> "[" * join(sort(map(f0, lst)), ", ") * "]"
end

function p_e_idict(f0)
    f1 = kv -> p_e_int()(kv[1]) * "=>" * f0(kv[2])
    return (dct::Dict) -> "{" * join(sort(map(f1, collect(dct))), ", ") * "}"
end

function p_e_sdict(f0)
    f1 = kv -> p_e_string()(kv[1]) * "=>" * f0(kv[2])
    return (dct::Dict) -> "{" * join(sort(map(f1, collect(dct))), ", ") * "}"
end

function p_e_option(f0)
    return (opt::Union{Any, Missing}) -> ismissing(opt) ? "null" : f0(opt)
end

$$code$$

p_e_out = p_e_entry()
open("result.out", "w") do writer
    write(writer, p_e_out)
end
