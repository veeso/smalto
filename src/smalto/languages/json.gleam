import gleam/option
import smalto/grammar.{type Grammar, type Rule, Grammar}

pub fn grammar() -> Grammar {
  Grammar(name: "json", extends: option.None, rules: rules())
}

fn rules() -> List(Rule) {
  [
    grammar.greedy_rule(
      "property",
      "(?<=^|[^\\\\])\"(?:\\\\.|[^\\\\\"\\r\\n])*\"(?=\\s*:)",
    ),
    grammar.greedy_rule(
      "string",
      "(?<=^|[^\\\\])\"(?:\\\\.|[^\\\\\"\\r\\n])*\"(?!\\s*:)",
    ),
    grammar.greedy_rule("comment", "\\/\\/.*|\\/\\*[\\s\\S]*?(?:\\*\\/|$)"),
    grammar.rule("number", "(?i)-?\\b\\d+(?:\\.\\d+)?(?:e[+-]?\\d+)?\\b"),
    grammar.rule("punctuation", "[{}[\\],]"),
    grammar.rule("operator", ":"),
    grammar.rule("boolean", "\\b(?:false|true)\\b"),
    grammar.rule("keyword", "\\bnull\\b"),
  ]
}
