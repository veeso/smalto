import gleam/option
import smalto/grammar.{type Grammar, type Rule, Grammar}

pub fn grammar() -> Grammar {
  Grammar(name: "python", extends: option.None, rules: rules())
}

fn rules() -> List(Rule) {
  [
    grammar.greedy_rule("comment", "(?<=^|[^\\\\])#.*"),
    grammar.greedy_rule_with_inside(
      "string-interpolation",
      "(?i)(?:f|fr|rf)(?:(\"\"\"|''')[\\s\\S]*?\\1|(\"|')(?:\\\\.|(?!\\2)[^\\\\\\r\\n])*\\2)",
      [
        grammar.nested_rule(
          "interpolation",
          "(?<=(?:^|[^{])(?:\\{\\{)*)\\{(?!\\{)(?:[^{}]|\\{(?!\\{)(?:[^{}]|\\{(?!\\{)(?:[^{}])+\\})+\\})+\\}",
          "python",
        ),
        grammar.rule("string", "[\\s\\S]+"),
      ],
    ),
    grammar.greedy_rule(
      "string",
      "(?i)(?:[rub]|br|rb)?(\"\"\"|''')[\\s\\S]*?\\1",
    ),
    grammar.greedy_rule(
      "string",
      "(?i)(?:[rub]|br|rb)?(\"|')(?:\\\\.|(?!\\1)[^\\\\\\r\\n])*\\1",
    ),
    grammar.rule("function", "(?<=(?:^|\\s)def[ \\t]+)[a-zA-Z_]\\w*(?=\\s*\\()"),
    grammar.rule("class-name", "(?i)(?<=\\bclass\\s+)\\w+"),
    grammar.rule_with_inside(
      "annotation",
      "(?m)(?<=^[\\t ]*)@\\w+(?:\\.\\w+)*",
      [
        grammar.rule("punctuation", "\\."),
      ],
    ),
    grammar.rule(
      "keyword",
      "\\b(?:_(?=\\s*:)|and|as|assert|async|await|break|case|class|continue|def|del|elif|else|except|exec|finally|for|from|global|if|import|in|is|lambda|match|nonlocal|not|or|pass|print|raise|return|try|while|with|yield)\\b",
    ),
    grammar.rule(
      "builtin",
      "\\b(?:__import__|abs|all|any|apply|ascii|basestring|bin|bool|buffer|bytearray|bytes|callable|chr|classmethod|cmp|coerce|compile|complex|delattr|dict|dir|divmod|enumerate|eval|execfile|file|filter|float|format|frozenset|getattr|globals|hasattr|hash|help|hex|id|input|int|intern|isinstance|issubclass|iter|len|list|locals|long|map|max|memoryview|min|next|object|oct|open|ord|pow|property|range|raw_input|reduce|reload|repr|reversed|round|set|setattr|slice|sorted|staticmethod|str|sum|super|tuple|type|unichr|unicode|vars|xrange|zip)\\b",
    ),
    grammar.rule("boolean", "\\b(?:False|None|True)\\b"),
    grammar.rule(
      "number",
      "(?i)\\b0(?:b(?:_?[01])+|o(?:_?[0-7])+|x(?:_?[a-f0-9])+)\\b|(?:\\b\\d+(?:_\\d+)*(?:\\.(?:\\d+(?:_\\d+)*)?)?|\\B\\.\\d+(?:_\\d+)*)(?:e[+-]?\\d+(?:_\\d+)*)?j?(?!\\w)",
    ),
    grammar.rule(
      "operator",
      "[-+%=]=?|!=|:=|\\*\\*?=?|\\/\\/?=?|<[<=>]?|>[=>]?|[&|^~]",
    ),
    grammar.rule("punctuation", "[{}[\\];(),.:]"),
  ]
}
