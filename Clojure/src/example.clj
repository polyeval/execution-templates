(require '[clojure.string :as string])

(defn p_e_escape-string [s]
    (let [p_e_escape-char (fn [c]
            (cond
                (= c \\) "\\\\"
                (= c \") "\\\""
                (= c \newline) "\\n"
                (= c \tab) "\\t"
                :else (str c)))]
    (string/join (map p_e_escape-char s))))

(defn p_e_bool []
    (fn [b]
        (when-not (boolean? b) (throw (IllegalArgumentException. "")))
        (if b "true" "false")))

(defn p_e_int []
    (fn [i]
        (when-not (int? i) (throw (IllegalArgumentException. "")))
        (str i)))

(defn p_e_double []
    (fn [d]        
        (when-not (double? d) (throw (IllegalArgumentException. "")))
        (let [s0 (format "%.7f" d)
            s1 (subs s0 0 (- (count s0) 1))]
            (if (= s1 "-0.000000") "0.000000" s1))))

(defn p_e_string []
    (fn [s]
        (when-not (string? s) (throw (IllegalArgumentException. "")))
        (str "\"" (p_e_escape-string s) "\"")))

(defn p_e_list [f0]
    (fn [lst]
        (when-not (vector? lst) (throw (IllegalArgumentException. "")))
        (str "[" (string/join ", " (map f0 lst)) "]")))

(defn p_e_ulist [f0]
    (fn [lst]
        (when-not (vector? lst) (throw (IllegalArgumentException. "")))
        (str "[" (string/join ", " (sort (map f0 lst))) "]")))

(defn p_e_idict [f0]
    (let [f1 (fn [[k v]] (str ((p_e_int) k) "=>" (f0 v)))]
        (fn [dct]
            (when-not (map? dct) (throw (IllegalArgumentException. "")))
            (str "{" (string/join ", " (sort (map f1 dct))) "}"))))

(defn p_e_sdict [f0]
    (let [f1 (fn [[k v]] (str ((p_e_string) k) "=>" (f0 v)))]
        (fn [dct]
            (when-not (map? dct) (throw (IllegalArgumentException. "")))
            (str "{" (string/join ", " (sort (map f1 dct))) "}"))))

(defn p_e_option [f0]
    (fn [opt]
        (if opt (f0 opt) "null")))

$$code$$

(let [p_e_out (p_e_entry)]
    (spit "result.out" p_e_out))