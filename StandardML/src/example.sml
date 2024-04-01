fun p_e_replaceNeg (s: string) : string =
    if String.isPrefix "~" s then "-" ^ String.extract (s, 1, NONE) else s;

fun p_e_escapeString (s: string) : string =
    let
        fun p_e_escapeChar (c: char) : string =
            case c of
                #"\r" => "\\r"
                | #"\n" => "\\n"
                | #"\t" => "\\t"
                | #"\"" => "\\\""
                | #"\\" => "\\\\"
                | _ => String.str c
    in
        String.concat (List.map p_e_escapeChar (String.explode s))
    end;

fun p_e_bool (b: bool) : string =
    if b then "true" else "false";

fun p_e_int (i: int) : string =
    p_e_replaceNeg (Int.toString i);

fun p_e_double (d: real) : string =
    let 
        val s0 = Real.fmt (StringCvt.FIX (SOME 7)) d;
        val s1 = p_e_replaceNeg (String.substring (s0, 0, size s0 - 1));
    in
        if s1 = "-0.000000" then "0.000000" else s1
    end;

fun p_e_string (s: string) : string =
    "\"" ^ p_e_escapeString s ^ "\"";

fun p_e_list (f0: 'a -> string) (lst: 'a list) : string =
    "[" ^ String.concatWith ", " (List.map f0 lst) ^ "]";

fun p_e_ulist (f0: 'a -> string) (lst: 'a list) : string =
    "[" ^ String.concatWith ", " (ListMergeSort.sort op > (List.map f0 lst)) ^ "]";


fun p_e_idict (f0: 'a -> string) (dct: (int, 'a) HashTable.hash_table) : string =
    let
        fun f1 (k, v) = p_e_int k ^ "=>" ^ f0 v
    in
        "{" ^ String.concatWith ", " (ListMergeSort.sort op > (List.map f1 (HashTable.listItemsi dct))) ^ "}"
    end

fun p_e_sdict (f0: 'a -> string) (dct: (string, 'a) HashTable.hash_table) : string =
    let
        fun f1 (k, v) = p_e_string k ^ "=>" ^ f0 v
    in
        "{" ^ String.concatWith ", " (ListMergeSort.sort op > (List.map f1 (HashTable.listItemsi dct))) ^ "}"
    end

fun p_e_option (f0: 'a -> string) (opt: 'a option) : string =
    case opt of
        SOME x => f0 x
        | NONE => "null";

fun p_e_createIdict (lst: (int * 'a) list) : (int, 'a) HashTable.hash_table =
    let
        val ht = HashTable.mkTable (Word.fromInt, op=) (10, Fail "")
    in
        List.app (fn (k, v) => HashTable.insert ht (k, v)) lst;
        ht
    end;

fun p_e_createSdict (lst: (string * 'a) list) : (string, 'a) HashTable.hash_table =
    let
        val ht = HashTable.mkTable (HashString.hashString, op=) (10, Fail "")
    in
        List.app (fn (k, v) => HashTable.insert ht (k, v)) lst;
        ht
    end;

$$code$$

let
    val p_e_out = p_e_entry
in
    let
        val oc = TextIO.openOut "result.out"
    in
        TextIO.output (oc, p_e_out);
        TextIO.closeOut oc
    end
end;