module Example exposing (..)
import Dict exposing (Dict)
import Posix.IO as IO exposing (..)
import Posix.IO.Process as Process
import Posix.IO.File as File
import Round

p_e_escapeString : String -> String
p_e_escapeString s =
    let p_e_escapeChar : Char -> String
        p_e_escapeChar c =
            case c of
                '\\' -> "\\\\"
                '\"' -> "\\\""
                '\n' -> "\\n"
                '\t' -> "\\t"
                _ -> String.fromChar c
    in s|> String.toList |> List.map p_e_escapeChar |> String.join ""

p_e_bool : Bool -> String
p_e_bool b =
    if b then "true" else "false"

p_e_int : Int -> String
p_e_int i =
    String.fromInt i

p_e_double : Float -> String
p_e_double d =
    let s0 = Round.round 7 d
        s1 = String.slice 0 (String.length s0 - 1) s0
    in if s1 == "-0.000000" then "0.000000" else s1

p_e_string : String -> String
p_e_string s =
    "\"" ++ p_e_escapeString s ++ "\""

p_e_list : (a -> String) -> List a -> String
p_e_list f0 lst =
    "[" ++ String.join ", " (lst |> List.map f0) ++ "]"

p_e_ulist : (a -> String) -> List a -> String
p_e_ulist f0 lst =
    "[" ++ String.join ", " (lst |> List.map f0 |> List.sort) ++ "]"

p_e_idict : (a -> String) -> Dict Int a -> String
p_e_idict f0 dct =
    let f1 kv = p_e_int (Tuple.first kv) ++ "=>" ++ f0 (Tuple.second kv)
    in "{" ++ String.join ", " (dct |> Dict.toList |> List.map f1 |> List.sort) ++ "}"

p_e_sdict : (a -> String) -> Dict String a -> String
p_e_sdict f0 dct =
    let f1 kv = p_e_string (Tuple.first kv) ++ "=>" ++ f0 (Tuple.second kv)
    in "{" ++ String.join ", " (dct |> Dict.toList |> List.map f1 |> List.sort) ++ "}"

p_e_option : (a -> String) -> Maybe a -> String
p_e_option f0 opt =
    case opt of
        Just x -> f0 x
        Nothing -> "null"

$$code$$

program : Process -> IO ()
program process =
    let p_e_out = p_e_entry
    in File.writeContentsTo "result.out" p_e_out