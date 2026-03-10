import gleam/option
import smalto/grammar.{type Grammar, type Rule, Grammar}

pub fn grammar() -> Grammar {
  Grammar(name: "clike", extends: option.None, rules: rules())
}

fn rules() -> List(Rule) {
  [
    grammar.greedy_rule(
      "comment",
      "(?:^|[^\\\\])\\K\\/\\*[\\s\\S]*?(?:\\*\\/|$)",
    ),
    grammar.greedy_rule("comment", "(?:^|[^\\\\:])\\K\\/\\/.*"),
    grammar.greedy_rule(
      "string",
      "([\"'])(?:\\\\(?:\\r\\n|[\\s\\S])|(?!\\1)[^\\\\\\r\\n])*\\1",
    ),
    grammar.rule_with_inside(
      "class-name",
      "(?:\\b(?:class|extends|implements|instanceof|interface|new)\\s+)\\K[\\w.\\\\]+",
      [
        grammar.rule("punctuation", "[.\\\\]"),
      ],
    ),
    grammar.rule(
      "keyword",
      "\\b(?:break|catch|continue|do|else|finally|for|function|if|in|instanceof|new|null|return|throw|try|while)\\b",
    ),
    grammar.rule("boolean", "\\b(?:false|true)\\b"),
    grammar.rule("function", "\\b\\w+(?=\\()"),
    grammar.rule(
      "number",
      "(?i)\\b0x[\\da-f]+\\b|(?:\\b\\d+(?:\\.\\d*)?|\\B\\.\\d+)(?:e[+-]?\\d+)?",
    ),
    grammar.rule("operator", "[<>]=?|[!=]=?=?|--?|\\+\\+?|&&?|\\|\\|?|[?*/~^%]"),
    grammar.rule("punctuation", "[{}[\\];(),.:]"),
  ]
}
