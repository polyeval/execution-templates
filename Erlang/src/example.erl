-module(example).
-export([main/0]).

p_e_escape_string(S) ->
    Pe__escape_char = fun(C) ->
        case C of
            $\\ -> "\\\\";
            $" -> "\\\"";
            $\n -> "\\n";
            $\t -> "\\t";
            _ -> [C]
        end
    end,
    lists:flatten(lists:map(Pe__escape_char, S)).

p_e_bool() ->
    fun(B) ->
        case not ((B =:= true) or (B =:= false)) of 
            true -> erlang:error();
            false -> ok
        end,
        if B -> "true"; true -> "false" end
    end.


p_e_int() ->
    fun(I) ->
        case not is_integer(I) of 
            true -> erlang:error();
            false -> ok
        end,
        integer_to_list(I)
    end.

p_e_double() ->
    fun(D) ->
        case not is_float(D) of 
            true -> erlang:error();
            false -> ok
        end,
        S0 = io_lib:format("~.7f", [D]),
        S1 = string:slice(S0, 0, length(S0) - 1),
        case S1 of
            "-0.000000" -> "0.000000";
            _ -> S1
        end
    end.

p_e_string() ->
    fun(S) ->
        case not is_list(S) of 
            true -> erlang:error();
            false -> ok
        end,
        "\"" ++ p_e_escape_string(S) ++ "\""
    end.

p_e_list(F0) ->
    fun(Lst) -> 
        case not is_list(Lst) of 
            true -> erlang:error();
            false -> ok
        end,
        "[" ++ string:join(lists:map(F0, Lst), ", ") ++ "]"
    end.

p_e_ulist(F0) ->
    fun(Lst) -> 
        case not is_list(Lst) of 
            true -> erlang:error();
            false -> ok
        end,
        "[" ++ string:join(lists:sort(lists:map(F0, Lst)), ", ") ++ "]"
    end.

p_e_idict(F0) ->
    F1 = fun({K, V}) -> (p_e_int())(K) ++ "=>" ++ F0(V) end,
    fun(Dct) ->
        case not is_map(Dct) of 
            true -> erlang:error();
            false -> ok
        end,        
        "{" ++ string:join(lists:sort(lists:map(F1, maps:to_list(Dct))), ", ") ++ "}"
    end.

p_e_sdict(F0) ->
    F1 = fun({K, V}) -> (p_e_string())(K) ++ "=>" ++ F0(V) end,
    fun(Dct) ->
        case not is_map(Dct) of 
            true -> erlang:error();
            false -> ok
        end,
        "{" ++ string:join(lists:sort(lists:map(F1, maps:to_list(Dct))), ", ") ++ "}"
    end.

p_e_option(F0) ->
    fun(Opt) ->
        case Opt of
            undefined -> "null";
            X  -> F0(X)
        end
    end.

$$code$$

main() ->
    P_e_out = p_e_entry(),
    file:write_file("result.out", P_e_out).
