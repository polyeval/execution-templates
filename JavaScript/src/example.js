function p_e_escape_string(s) {
    const p_e_escape_char = (c) => {
        if (c === '\\') return "\\\\";
        if (c === '\"') return "\\\"";
        if (c === '\n') return "\\n";
        if (c === '\t') return "\\t";
        return c;
    }
    return [...s].map(p_e_escape_char).join('');
}

function p_e_bool() {
    return (b) => {
        if (typeof b !== "boolean") throw new Error();
        return b ? "true" : "false";
    }
}

function p_e_int() {
    return (i) => {
        if (typeof i !== "number" || !Number.isInteger(i)) throw new Error();
        return i.toString();
    }
}

function p_e_double() {
    return (d) => {
        if (typeof d !== "number") throw new Error();
        const s0 = d.toFixed(7);
        const s1 = s0.substring(0, s0.length - 1);
        return s1 === "-0.000000" ? "0.000000" : s1;
    }
}

function p_e_string() {
    return (s) => {
        if (typeof s !== "string") throw new Error();
        return "\"" + p_e_escape_string(s) + "\"";
    }
}

function p_e_list(f0) {
    return (lst) => {
        if (!Array.isArray(lst)) throw new Error();
        return "[" + lst.map(f0).join(", ") + "]";
    }
}

function p_e_ulist(f0) {
    return (lst) => {
        if (!Array.isArray(lst)) throw new Error();
        return "[" + lst.map(f0).sort().join(", ") + "]";
    }
}

function p_e_idict(f0) {
    const f1 = ([k, v]) => p_e_int()(k) + "=>" + f0(v);
    return (dct) => {
        if (!dct instanceof Map) throw new Error();
        return "{" + [...dct].map(f1).sort().join(", ") + "}";
    }
}

function p_e_sdict(f0) {
    const f1 = ([k, v]) => p_e_string()(k) + "=>" + f0(v);
    return (dct) => {
        if (!dct instanceof Map) throw new Error();        
        return "{" + [...dct].map(f1).sort().join(", ") + "}";
    }
}

function p_e_option(f0) {
    return (opt) => {
        return opt === null ? "null" : f0(opt);
    }
}

$$code$$

const p_e_out = p_e_entry();
const fs = require('fs');
fs.writeFileSync("result.out", p_e_out);
