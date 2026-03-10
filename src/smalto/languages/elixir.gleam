import gleam/option
import smalto/grammar.{type Grammar, type Rule, Grammar}

pub fn grammar() -> Grammar {
  Grammar(name: "elixir", extends: option.None, rules: rules())
}

fn rules() -> List(Rule) {
  [
    grammar.rule_with_inside(
      "doc",
      "@(?:doc|moduledoc)\\s+(?:(\"\"\"|''')[\\s\\S]*?\\1|(\"|')(?:\\\\(?:\\r\\n|[\\s\\S])|(?!\\2)[^\\\\\\r\\n])*\\2)",
      [
        grammar.rule("attribute", "^@\\w+"),
        grammar.rule("string", "['\"][\\s\\S]+"),
      ],
    ),
    grammar.greedy_rule("comment", "#.*"),
    grammar.greedy_rule(
      "regex",
      "~[rR](?:(\"\"\"|''')(?:\\\\[\\s\\S]|(?!\\1)[^\\\\])+\\1|([\\/|\"'])(?:\\\\.|(?!\\2)[^\\\\\\r\\n])+\\2|\\((?:\\\\.|[^\\\\)\\r\\n])+\\)|\\[(?:\\\\.|[^\\\\\\]\\r\\n])+\\]|\\{(?:\\\\.|[^\\\\}\\r\\n])+\\}|<(?:\\\\.|[^\\\\>\\r\\n])+>)[uismxfr]*",
    ),
    grammar.greedy_rule_with_inside(
      "string",
      "~[cCsSwW](?:(\"\"\"|''')(?:\\\\[\\s\\S]|(?!\\1)[^\\\\])+\\1|([\\/|\"'])(?:\\\\.|(?!\\2)[^\\\\\\r\\n])+\\2|\\((?:\\\\.|[^\\\\)\\r\\n])+\\)|\\[(?:\\\\.|[^\\\\\\]\\r\\n])+\\]|\\{(?:\\\\.|#\\{[^}]+\\}|#(?!\\{)|[^#\\\\}\\r\\n])+\\}|<(?:\\\\.|[^\\\\>\\r\\n])+>)[csa]?",
      [
        grammar.nested_rule("interpolation", "#\\{[^}]+\\}", "elixir"),
      ],
    ),
    grammar.greedy_rule_with_inside("string", "(\"\"\"|''')[\\s\\S]*?\\1", [
      grammar.nested_rule("interpolation", "#\\{[^}]+\\}", "elixir"),
    ]),
    grammar.greedy_rule_with_inside(
      "string",
      "(\"|')(?:\\\\(?:\\r\\n|[\\s\\S])|(?!\\1)[^\\\\\\r\\n])*\\1",
      [
        grammar.nested_rule("interpolation", "#\\{[^}]+\\}", "elixir"),
      ],
    ),
    grammar.rule("symbol", "(?<=^|[^:]):\\w+"),
    grammar.rule("class-name", "\\b[A-Z]\\w*\\b"),
    grammar.rule("attr-name", "\\b\\w+\\??:(?!:)"),
    grammar.rule("variable", "(?<=^|[^&])&\\d+"),
    grammar.rule("variable", "@\\w+"),
    grammar.rule(
      "function",
      "\\b[_a-zA-Z]\\w*[?!]?(?:(?=\\s*(?:\\.\\s*)?\\()|(?=\\/\\d))",
    ),
    grammar.rule(
      "number",
      "(?i)\\b(?:0[box][a-f\\d_]+|\\d[\\d_]*)(?:\\.[\\d_]+)?(?:e[+-]?[\\d_]+)?\\b",
    ),
    grammar.rule(
      "keyword",
      "\\b(?:after|alias|and|case|catch|cond|def(?:callback|delegate|exception|impl|macro|module|n|np|p|protocol|struct)?|do|else|end|fn|for|if|import|not|or|quote|raise|require|rescue|try|unless|unquote|use|when)\\b",
    ),
    grammar.rule("boolean", "\\b(?:false|nil|true)\\b"),
    grammar.rule(
      "operator",
      "\\bin\\b|&&?|\\|[|>]?|\\\\\\\\|::|\\.\\.\\.?|\\+\\+?|-[->]?|<[-=>]|>=|!==?|\\B!|=(?:==?|[>~])?|[*\\/^]",
    ),
    grammar.rule("operator", "(?<=[^<])<(?!<)"),
    grammar.rule("operator", "(?<=[^>])>(?!>)"),
    grammar.rule("punctuation", "<<|>>|[.,%\\[\\]{}()]"),
  ]
}
