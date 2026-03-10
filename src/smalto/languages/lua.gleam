import gleam/option
import smalto/grammar.{type Grammar, type Rule, Grammar}

pub fn grammar() -> Grammar {
  Grammar(name: "lua", extends: option.None, rules: rules())
}

fn rules() -> List(Rule) {
  [
    grammar.rule("comment", "(?m)^#!.+|--(?:\\[(=*)\\[[\\s\\S]*?\\]\\1\\]|.*)"),
    grammar.greedy_rule(
      "string",
      "([\"'])(?:(?!\\1)[^\\\\\\r\\n]|\\\\z(?:\\r\\n|\\s)|\\\\(?:\\r\\n|[^z]))*\\1|\\[(=*)\\[[\\s\\S]*?\\]\\2\\]",
    ),
    grammar.rule(
      "number",
      "(?i)\\b0x[a-f\\d]+(?:\\.[a-f\\d]*)?(?:p[+-]?\\d+)?\\b|\\b\\d+(?:\\.\\B|(?:\\.\\d*)?(?:e[+-]?\\d+)?\\b)|\\B\\.\\d+(?:e[+-]?\\d+)?\\b",
    ),
    grammar.rule(
      "keyword",
      "\\b(?:and|break|do|else|elseif|end|false|for|function|goto|if|in|local|nil|not|or|repeat|return|then|true|until|while)\\b",
    ),
    grammar.rule("function", "(?!\\d)\\w+(?=\\s*(?:[({]))"),
    grammar.rule("operator", "[-+*%^&|#]|\\/\\/?|<[<=]?|>[>=]?|[=~]=?"),
    grammar.rule("operator", "(?<=^|[^.])\\.\\.(?!\\.)"),
    grammar.rule("punctuation", "[\\[\\](){},;]|\\.+|:+"),
  ]
}
