import Data.List
import Data.Function 
import Data.Maybe
import Data.Map (Map)
import Text.Printf
import qualified Data.Map.Strict as Map

p_e_escapeString :: String -> String
p_e_escapeString s =
    let p_e_escapeChar :: Char -> String
        p_e_escapeChar c =
            case c of
                '\\' -> "\\\\"
                '\"' -> "\\\""
                '\n' -> "\\n"
                '\t' -> "\\t"
                _ -> [c]
    in concatMap p_e_escapeChar s

p_e_bool :: Bool -> String
p_e_bool b =
    if b then "true" else "false"

p_e_int :: Int -> String
p_e_int i =
    show i

p_e_double :: Double -> String
p_e_double d =
    let s0 = printf "%.7f" d
        s1 = take (length s0 - 1) s0
    in if s1 == "-0.000000" then "0.000000" else s1

p_e_string :: String -> String
p_e_string s =
    "\"" ++ p_e_escapeString s ++ "\""

p_e_list :: (a -> String) -> [a] -> String
p_e_list f0 lst =
    "[" ++ intercalate ", " (lst & map f0) ++ "]"

p_e_ulist :: (a -> String) -> [a] -> String
p_e_ulist f0 lst =
    "[" ++ intercalate ", " (lst & map f0 & sort) ++ "]"

p_e_idict :: (a -> String) -> Map Int a -> String
p_e_idict f0 dct =
    let f1 (k, v) = p_e_int k ++ "=>" ++ f0 v
    in "{" ++ intercalate ", " (dct & Map.toList & map f1 & sort) ++ "}"

p_e_sdict :: (a -> String) -> Map String a -> String
p_e_sdict f0 dct =
    let f1 (k, v) = p_e_string k ++ "=>" ++ f0 v
    in "{" ++ intercalate ", " (dct & Map.toList & map f1 & sort) ++ "}"

p_e_option :: (a -> String) -> Maybe a -> String
p_e_option f0 opt =
    case opt of
        Just x -> f0 x
        Nothing -> "null"

$$code$$

main :: IO ()
main = do
    let p_e_out = p_e_entry ()
    writeFile "result.out" p_e_out