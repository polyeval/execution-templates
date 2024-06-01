module Example where
import Prelude 
import Data.Array as Array
import Data.String as String
import Data.String.CodeUnits as CodeUnits
import Data.Number.Format (toStringWith, fixed)
import Effect (Effect)
import Data.Map (Map)
import Data.Map as Map
import Data.Foldable as Foldable
import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple(..))
import Node.Encoding (Encoding(..))
import Node.FS.Sync (writeTextFile)

p_e_escapeString :: String -> String
p_e_escapeString s = 
    let p_e_escapeChar :: Char -> String
        p_e_escapeChar c = 
            case c of
                '\\' -> "\\\\"
                '\"' -> "\\\""
                '\n' -> "\\n"
                '\t' -> "\\t"
                _ -> CodeUnits.fromCharArray [c]
    in s # CodeUnits.toCharArray # map p_e_escapeChar # String.joinWith ""

p_e_bool :: Boolean -> String
p_e_bool b = 
    if b then "true" else "false"

p_e_int :: Int -> String
p_e_int i = 
    show i

p_e_double :: Number -> String
p_e_double d = 
    let s0 = toStringWith (fixed 7) d
        s1 = (String.take (String.length s0 - 1) s0)
    in if s1 == "-0.000000" then "0.000000" else s1

p_e_string :: String -> String
p_e_string s = 
    "\"" <> p_e_escapeString s <> "\""

p_e_list :: forall a. (a -> String) -> Array a -> String
p_e_list f0 lst = 
    "[" <> (lst # map f0 # String.joinWith ", ") <> "]"

p_e_ulist :: forall a. (a -> String) -> Array a -> String
p_e_ulist f0 lst = 
    "[" <> (lst # map f0 # Array.sort # String.joinWith ", ") <> "]"

p_e_idict :: forall a. (a -> String) -> Map Int a -> String
p_e_idict f0 dct = 
    let f1 = \(Tuple k v) -> p_e_int k <> "=>" <> f0 v
    in "{" <> (dct # (Map.toUnfoldable :: forall k v. Map k v -> Array (Tuple k v)) # map f1 # Array.sort # String.joinWith ", ") <> "}"

p_e_sdict :: forall a. (a -> String) -> Map String a -> String
p_e_sdict f0 dct = 
    let f1 = \(Tuple k v) -> p_e_string k <> "=>" <> f0 v
    in "{" <> (dct # (Map.toUnfoldable :: forall k v. Map k v -> Array (Tuple k v)) # map f1 # Array.sort # String.joinWith ", ") <> "}"

p_e_option :: forall a. (a -> String) -> Maybe a -> String
p_e_option f0 opt = 
    case opt of
        Just x -> f0 x
        Nothing -> "null"

$$code$$

main :: Effect Unit
main =
    let p_e_out = p_e_entry
    in writeTextFile UTF8 "result.out" p_e_out