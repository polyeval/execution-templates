#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <unordered_map>
#include <algorithm>
#include <optional>
#include <functional> 
#include <ranges>
#include <format>

using namespace std;
using namespace std::literals;

string p_e_escapeString(const string& s) {
    auto p_e_escape_char = [](char c) -> string {
        if (c == '\\') return "\\\\";
        if (c == '\"') return "\\\"";
        if (c == '\n') return "\\n";
        if (c == '\t') return "\\t";
        return string(1, c);
    };
    // Commented code will be availabe in g++14
    // vector<string> res = s | views::transform(p_e_escape_char) | ranges::to<vector<string>>();
    auto tmp = s | views::transform(p_e_escape_char);
    vector<string> res = vector<string>(tmp.begin(), tmp.end());
    return ranges::fold_left(res | views::join_with(""sv), string(), plus());
}

function<string(const bool&)> p_e_bool() {
    return [](const bool& b) { return b ? "true" : "false"; };
}

function<string(const int&)> p_e_int() {
    return [](const int& i) { return to_string(i); };
}

function<string(const double&)> p_e_double() {
    return [](const double& d) { 
        string s0 = format("{:.7f}", d);
        string s1 = s0.substr(0, s0.length() - 1);
        return (s1 == "-0.000000") ? "0.000000" : s1;
    };
}

function<string(const string&)> p_e_string() {
    return [](const string& s) { return "\"" + p_e_escapeString(s) + "\""; };
}

template <typename V>
function<string(const vector<V>&)> p_e_list(function<string(const V&)> f0) {
    return [f0 = move(f0)](const vector<V>& lst) -> string {
        // vector<string> vs = lst | views::transform(f0) | ranges::to<vector<string>>();
        auto tmp = lst | views::transform(f0);
        vector<string> vs = vector<string>(tmp.begin(), tmp.end());
        return "[" + ranges::fold_left(vs | views::join_with(", "sv), string(), plus()) + "]";
    };
}

template <typename V>
function<string(const vector<V>&)> p_e_ulist(function<string(const V&)> f0) {
    return [f0 = move(f0)](const vector<V>& lst) -> string {
        // vector<string> vs = lst | views::transform(f0) | ranges::to<vector<string>>();
        auto tmp = lst | views::transform(f0);
        vector<string> vs = vector<string>(tmp.begin(), tmp.end());
        ranges::sort(vs);
        return "[" + ranges::fold_left(vs | views::join_with(", "sv), string(), plus()) + "]";
    };
}

template <typename V>
function<string(const unordered_map<int, V>&)> p_e_idict(function<string(const V&)> f0) {
    function<string(pair<int, V>)> f1 = [f0 = move(f0)](auto kv){return p_e_int()(kv.first) + "=>" + f0(kv.second); };
    return [f1 = move(f1)](const unordered_map<int, V>& dct) -> string {
        // vector<string> vs = dct | views::transform(f1) | ranges::to<vector<string>>();
        auto tmp = dct | views::transform(f1);
        vector<string> vs = vector<string>(tmp.begin(), tmp.end());
        ranges::sort(vs);
        return "{" + ranges::fold_left(vs | views::join_with(", "sv), string(), plus()) + "}";
    };
}

template <typename V>
function<string(const unordered_map<string, V>&)> p_e_sdict(function<string(const V&)> f0) {
    function<string(pair<string, V>)> f1 = [f0 = move(f0)](auto kv){return p_e_string()(kv.first) + "=>" + f0(kv.second); };
    return [f1 = move(f1)](const unordered_map<string, V>& dct) -> string {
        // vector<string> vs = dct | views::transform(f1) | ranges::to<vector<string>>();
        auto tmp = dct | views::transform(f1);
        vector<string> vs = vector<string>(tmp.begin(), tmp.end());
        ranges::sort(vs);
        return "{" + ranges::fold_left(vs | views::join_with(", "sv), string(), plus()) + "}";
    };
}

template <typename V>
function<string(const optional<V>&)> p_e_option(function<string(const V&)> f0) {
    return [f0 = move(f0)](const optional<V>& opt) -> string {
        if (opt.has_value()) {
            return f0(opt.value());
        } else {
            return "null";
        }
    };
}

$$code$$

int main() {
    string p_e_out = p_e_entry();
    ofstream("result.out") << p_e_out;
}