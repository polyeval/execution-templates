defmodule Example do
    def p_e_escape_string(s) do
        p_e_escape_char = fn c ->
            case c do
            "\\" -> "\\\\"
            "\"" -> "\\\""
            "\n" -> "\\n"
            "\t" -> "\\t"
            _ -> c
            end
        end
        s |> String.codepoints() |> Enum.map(p_e_escape_char) |> Enum.join()
    end
    
    def p_e_bool do
        fn b -> 
            unless is_boolean(b) do
                raise ArgumentError
            end
            if b, do: "true", else: "false"
        end
    end
    
    def p_e_int do
        fn i -> 
            unless is_integer(i) do
                raise ArgumentError
            end
            Integer.to_string(i)
        end
    end

    def p_e_double do
        fn d -> 
            unless is_float(d) do
                raise ArgumentError
            end
            s0 = :erlang.float_to_binary(d, decimals: 7)
            s1 = String.slice(s0, 0..-2//1)
            if s1 == "-0.000000", do: "0.000000", else: s1
        end
    end

    def p_e_string do
        fn s -> 
            unless is_binary(s) do
                raise ArgumentError
            end
            "\"" <> p_e_escape_string(s) <> "\""
        end
    end

    def p_e_list(f0) do
        fn lst -> 
            unless is_list(lst) do
                raise ArgumentError
            end
            "[" <> (lst |> Enum.map(f0) |> Enum.join(", ")) <> "]" 
        end
    end    
    
    def p_e_ulist(f0) do
        fn lst ->
            unless is_list(lst) do
                raise ArgumentError
            end
            "[" <> (lst |> Enum.map(f0) |> Enum.sort() |> Enum.join(", ")) <> "]"
        end
    end

    def p_e_idict(f0) do
        f1 = fn {k, v} -> p_e_int().(k) <> "=>" <> f0.(v) end
        fn dct -> 
            unless is_map(dct) do
                raise ArgumentError
            end            
            "{" <> (dct |> Enum.map(f1) |> Enum.join(", ")) <> "}"
        end
    end

    def p_e_sdict(f0) do
        f1 = fn {k, v} -> p_e_string().(k) <> "=>" <> f0.(v) end
        fn dct -> 
            unless is_map(dct) do
                raise ArgumentError
            end            
            "{" <> (dct |> Enum.map(f1) |> Enum.join(", ")) <> "}"
        end
    end

    def p_e_option(f0) do
        fn opt -> 
            case opt do
                nil -> "null"
                x -> f0.(x)
            end
        end
    end

    $$code$$

    def main do
        p_e_out = p_e_entry()
        File.write!("result.out", p_e_out)
    end
end

Example.main()