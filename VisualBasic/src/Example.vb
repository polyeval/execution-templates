Module Example
    Function p_e_EscapeString(s As String) As String
        Dim p_e_EscapeChar As Func(Of Char, String) = Function(c As Char)
            If c = "\" Then Return "\\"
            If c = """" Then Return "\"""
            If c = vbLf Then Return "\n"
            If c = vbTab Then Return "\t"
            Return c.ToString()
        End Function
        Return String.Join("", s.Select(Function(c) p_e_EscapeChar(c)))
    End Function

    Function p_e_bool() As Func(Of Boolean, String)
        Return Function(b As Boolean) If(b, "true", "false")
    End Function

    Function p_e_int() As Func(Of Integer, String)
        Return Function(i As Integer) i.ToString()
    End Function

    Function p_e_double() As Func(Of Double, String)
        Return Function(d As Double)
            Dim s0 As String = d.ToString("F7")
            Dim s1 As String = s0.Substring(0, s0.Length - 1)
            Return If(s1 = "-0.000000", "0.000000", s1)
        End Function
    End Function

    Function p_e_string() As Func(Of String, String)
        Return Function(s As String) """" & p_e_EscapeString(s) & """"
    End Function

    Function p_e_list(Of V)(f0 As Func(Of V, String)) As Func(Of List(Of V), String)
        Return Function(lst As List(Of V)) "[" & String.Join(", ", lst.Select(f0)) & "]"
    End Function

    Function p_e_ulist(Of V)(f0 As Func(Of V, String)) As Func(Of List(Of V), String)
        Return Function(lst As List(Of V)) "[" & String.Join(", ", lst.Select(f0).OrderBy(Function(x) x)) & "]"
    End Function

    Function p_e_idict(Of V)(f0 As Func(Of V, String)) As Func(Of Dictionary(Of Integer, V), String)
        Dim f1 As Func(Of KeyValuePair(Of Integer, V), String) = Function(kv) p_e_int()(kv.Key) & "=>" & f0(kv.Value)
        Return Function(dct As Dictionary(Of Integer, V)) "{" & String.Join(", ", dct.Select(f1).OrderBy(Function(x) x)) & "}"
    End Function

    Function p_e_sdict(Of V)(f0 As Func(Of V, String)) As Func(Of Dictionary(Of String, V), String)
        Dim f1 As Func(Of KeyValuePair(Of String, V), String) = Function(kv) p_e_string()(kv.Key) & "=>" & f0(kv.Value)
        Return Function(dct As Dictionary(Of String, V)) "{" & String.Join(", ", dct.Select(f1).OrderBy(Function(x) x)) & "}"
    End Function

    Function p_e_option(Of V As Structure)(f0 As Func(Of V, String)) As Func(Of V?, String)
        Return Function(opt As V?) If(opt.HasValue, f0(opt.Value), "null")
    End Function

    $$code$$

    Sub Main()
        Dim p_e_out As String = p_e_entry()
        System.IO.File.WriteAllText("result.out", p_e_out)
    End Sub
End Module