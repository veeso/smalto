import gleam/option
import smalto/grammar.{type Grammar, type Rule, Grammar}

pub fn grammar() -> Grammar {
  Grammar(name: "erlang", extends: option.None, rules: rules())
}

fn rules() -> List(Rule) {
  [
    grammar.rule("comment", "%.+"),
    grammar.greedy_rule("string", "\"(?:\\\\.|[^\\\\\"\\r\\n])*\""),
    grammar.rule("function", "'(?:\\\\.|[^\\\\'\\r\\n])+'(?=\\()"),
    grammar.rule("atom", "'(?:\\\\.|[^\\\\'\\r\\n])+'"),
    grammar.rule("boolean", "\\b(?:false|true)\\b"),
    grammar.rule(
      "keyword",
      "\\b(?:after|begin|case|catch|end|fun|if|of|receive|try|when)\\b",
    ),
    grammar.rule("number", "\\$\\\\?."),
    grammar.rule("number", "(?i)\\b\\d+#[a-z0-9]+"),
    grammar.rule(
      "number",
      "(?i)(?:\\b\\d+(?:\\.\\d*)?|\\B\\.\\d+)(?:e[+-]?\\d+)?",
    ),
    grammar.rule("function", "\\b[a-z][\\w@]*(?=\\()"),
    grammar.rule("variable", "(?<=^|[^@])(?:\\b|\\?)[A-Z_][\\w@]*"),
    grammar.rule(
      "operator",
      "[=\\/<>:]=|=[:\\/]=|\\+\\+?|--?|[=*\\/!]|\\b(?:and|andalso|band|bnot|bor|bsl|bsr|bxor|div|not|or|orelse|rem|xor)\\b",
    ),
    grammar.rule("operator", "(?<=^|[^<])<(?!<)"),
    grammar.rule("operator", "(?<=^|[^>])>(?!>)"),
    grammar.rule("atom", "\\b[a-z][\\w@]*"),
    grammar.rule("punctuation", "[()[\\]{}:;,.#|]|<<|>>"),
  ]
}
