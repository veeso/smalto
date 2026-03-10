import gleam/option
import smalto/grammar.{type Grammar, type Rule, Grammar}

pub fn grammar() -> Grammar {
  Grammar(name: "toml", extends: option.None, rules: rules())
}

fn rules() -> List(Rule) {
  [
    grammar.greedy_rule("comment", "#.*"),
    grammar.greedy_rule(
      "class-name",
      "(?m)(?:^[\\t ]*\\[\\s*(?:\\[\\s*)?)\\K(?:[\\w-]+|'[^'\\n\\r]*'|\"(?:\\\\.|[^\\\\\"\\r\\n])*\")(?:\\s*\\.\\s*(?:[\\w-]+|'[^'\\n\\r]*'|\"(?:\\\\.|[^\\\\\"\\r\\n])*\"))*(?=\\s*\\])",
    ),
    grammar.greedy_rule(
      "property",
      "(?m)(?:^[\\t ]*|[{,]\\s*)\\K(?:[\\w-]+|'[^'\\n\\r]*'|\"(?:\\\\.|[^\\\\\"\\r\\n])*\")(?:\\s*\\.\\s*(?:[\\w-]+|'[^'\\n\\r]*'|\"(?:\\\\.|[^\\\\\"\\r\\n])*\"))*(?=\\s*=)",
    ),
    grammar.greedy_rule(
      "string",
      "\"\"\"(?:\\\\[\\s\\S]|[^\\\\])*?\"\"\"|'''[\\s\\S]*?'''|'[^'\\n\\r]*'|\"(?:\\\\.|[^\\\\\"\\r\\n])*\"",
    ),
    grammar.rule(
      "number",
      "(?i)\\b\\d{4}-\\d{2}-\\d{2}(?:[T\\s]\\d{2}:\\d{2}:\\d{2}(?:\\.\\d+)?(?:Z|[+-]\\d{2}:\\d{2})?)?\\b",
    ),
    grammar.rule("number", "\\b\\d{2}:\\d{2}:\\d{2}(?:\\.\\d+)?\\b"),
    grammar.rule(
      "number",
      "(?:\\b0(?:x[\\da-zA-Z]+(?:_[\\da-zA-Z]+)*|o[0-7]+(?:_[0-7]+)*|b[10]+(?:_[10]+)*))\\b|[-+]?\\b\\d+(?:_\\d+)*(?:\\.\\d+(?:_\\d+)*)?(?:[eE][+-]?\\d+(?:_\\d+)*)?\\b|[-+]?\\b(?:inf|nan)\\b",
    ),
    grammar.rule("boolean", "\\b(?:false|true)\\b"),
    grammar.rule("punctuation", "[.,=[\\]{}]"),
  ]
}
