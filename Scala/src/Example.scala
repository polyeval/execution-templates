import java.io.File

object Example {
    def p_e_escapeString(s: String): String = {
        val p_e_escapeChar: Char => String = c => c match {
            case '\\' => "\\\\"
            case '\"' => "\\\""
            case '\n' => "\\n"
            case '\t' => "\\t"
            case c => c.toString
        }
        s.map(p_e_escapeChar).mkString
    }

    def p_e_bool(): Boolean => String = {
        case true => "true"
        case false => "false"
    }

    def p_e_int(): Int => String = {
        i => i.toString
    }

    def p_e_double(): Double => String = {
        d => {
            val s0 = f"$d%.7f"
            val s1 = s0.substring(0, s0.length - 1)
            if (s1 == "-0.000000") "0.000000" else s1
        }
    }

    def p_e_string(): String => String = {
        s => "\"" + p_e_escapeString(s) + "\""
    }

    def p_e_list[V](f0: V => String): scala.collection.Seq[V] => String = {
        lst => "[" + lst.map(f0).mkString(", ") + "]"
    }

    def p_e_ulist[V](f0: V => String): scala.collection.Seq[V] => String = {
        lst => "[" + lst.map(f0).sorted.mkString(", ") + "]"
    }

    def p_e_idict[V](f0: V => String): scala.collection.Map[Int, V] => String = {
        val f1: ((Int, V)) => String = kv => p_e_int()(kv._1) + "=>" + f0(kv._2)
        dct => "{" + dct.map(f1).toList.sorted.mkString(", ") + "}"
    }

    def p_e_sdict[V](f0: V => String): scala.collection.Map[String, V] => String = {
        val f1: ((String, V)) => String = kv => p_e_string()(kv._1) + "=>" + f0(kv._2)
        dct => "{" + dct.map(f1).toList.sorted.mkString(", ") + "}"
    }

    def p_e_option[V](f0: V => String): Option[V] => String = {
        opt => opt match {
            case Some(v) => f0(v)
            case None => "null"
        }
    }

    $$code$$

    def main(args: Array[String]): Unit = {
        val p_e_out = p_e_entry()
        new java.io.PrintWriter("result.out") { write(p_e_out); close }
    }
}