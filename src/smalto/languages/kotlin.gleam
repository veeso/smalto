import gleam/option
import smalto/grammar.{type Grammar, type Rule, Grammar}

pub fn grammar() -> Grammar {
  Grammar(name: "kotlin", extends: option.Some("clike"), rules: rules())
}

fn rules() -> List(Rule) {
  [
    grammar.greedy_rule("comment", "(?<=^|[^\\\\])\\/\\*[\\s\\S]*?(?:\\*\\/|$)"),
    grammar.greedy_rule("comment", "(?<=^|[^\\\\:])\\/\\/.*"),
    grammar.rule_with_inside(
      "multiline",
      "\"\"\"(?:[^$]|\\$(?:(?!\\{)|\\{[^{}]*\\}))*?\"\"\"",
      [
        grammar.rule_with_inside(
          "interpolation",
          "(?i)\\$(?:[a-z_]\\w*|\\{[^{}]*\\})",
          [
            grammar.rule("punctuation", "^\\$\\{?|\\}$"),
            grammar.rule_with_inside("expression", "[\\s\\S]+", [
              grammar.rule_with_inside(
                "singleline",
                "\"(?:[^\"\\\\\\r\\n$]|\\\\.|\\$(?:(?!\\{)|\\{[^{}]*\\}))*\"",
                [
                  grammar.rule(
                    "interpolation",
                    "(?i)(?<=(?:^|[^\\\\])(?:\\\\{2})*)\\$(?:[a-z_]\\w*|\\{[^{}]*\\})",
                  ),
                  grammar.rule("string", "[\\s\\S]+"),
                ],
              ),
              grammar.greedy_rule(
                "char",
                "'(?:[^'\\\\\\r\\n]|\\\\(?:.|u[a-fA-F0-9]{0,4}))'",
              ),
              grammar.rule(
                "builtin",
                "\\B@(?:\\w+:)?(?:[A-Z]\\w*|\\[[^\\]]+\\])",
              ),
              grammar.rule(
                "keyword",
                "(?<=^|[^.])\\b(?:abstract|actual|annotation|as|break|by|catch|class|companion|const|constructor|continue|crossinline|data|do|dynamic|else|enum|expect|external|final|finally|for|fun|get|if|import|in|infix|init|inline|inner|interface|internal|is|lateinit|noinline|null|object|open|operator|out|override|package|private|protected|public|reified|return|sealed|set|super|suspend|tailrec|this|throw|to|try|typealias|val|var|vararg|when|where|while)\\b",
              ),
              grammar.rule("boolean", "\\b(?:false|true)\\b"),
              grammar.rule("symbol", "\\b\\w+@|@\\w+\\b"),
              grammar.greedy_rule(
                "function",
                "(?:`[^\\r\\n`]+`|\\b\\w+)(?=\\s*\\()",
              ),
              grammar.greedy_rule(
                "function",
                "(?<=\\.)(?:`[^\\r\\n`]+`|\\w+)(?=\\s*\\{)",
              ),
              grammar.rule(
                "number",
                "\\b(?:0[xX][\\da-fA-F]+(?:_[\\da-fA-F]+)*|0[bB][01]+(?:_[01]+)*|\\d+(?:_\\d+)*(?:\\.\\d+(?:_\\d+)*)?(?:[eE][+-]?\\d+(?:_\\d+)*)?[fFL]?)\\b",
              ),
              grammar.rule(
                "operator",
                "\\+[+=]?|-[-=>]?|==?=?|!(?:!|==?)?|[\\/*%<>]=?|[?:]:?|\\.\\.|&&|\\|\\||\\b(?:and|inv|or|shl|shr|ushr|xor)\\b",
              ),
              grammar.rule("punctuation", "[{}[\\];(),.:]"),
            ]),
          ],
        ),
        grammar.rule("string", "[\\s\\S]+"),
      ],
    ),
    grammar.rule("boolean", "\\b(?:false|true)\\b"),
    grammar.rule(
      "number",
      "\\b(?:0[xX][\\da-fA-F]+(?:_[\\da-fA-F]+)*|0[bB][01]+(?:_[01]+)*|\\d+(?:_\\d+)*(?:\\.\\d+(?:_\\d+)*)?(?:[eE][+-]?\\d+(?:_\\d+)*)?[fFL]?)\\b",
    ),
    grammar.rule(
      "operator",
      "\\+[+=]?|-[-=>]?|==?=?|!(?:!|==?)?|[\\/*%<>]=?|[?:]:?|\\.\\.|&&|\\|\\||\\b(?:and|inv|or|shl|shr|ushr|xor)\\b",
    ),
    grammar.rule("punctuation", "[{}[\\];(),.:]"),
  ]
}
