import gleam/option
import smalto/grammar.{type Grammar, type Rule, Grammar}

pub fn grammar() -> Grammar {
  Grammar(name: "dart", extends: option.Some("clike"), rules: rules())
}

fn rules() -> List(Rule) {
  [
    grammar.greedy_rule(
      "comment",
      "(?:^|[^\\\\])\\K\\/\\*[\\s\\S]*?(?:\\*\\/|$)",
    ),
    grammar.greedy_rule("comment", "(?:^|[^\\\\:])\\K\\/\\/.*"),
    grammar.greedy_rule_with_inside(
      "string-literal",
      "r?(?:(\"\"\"|''')[\\s\\S]*?\\1|([\"'])(?:\\\\.|(?!\\2)[^\\\\\\r\\n])*\\2(?!\\2))",
      [
        grammar.rule_with_inside(
          "interpolation",
          "(?:(?:^|[^\\\\])(?:\\\\{2})*)\\K\\$(?:\\w+|\\{(?:[^{}]|\\{[^{}]*\\})*\\})",
          [
            grammar.rule("punctuation", "^\\$\\{?|\\}$"),
            grammar.rule_with_inside("expression", "[\\s\\S]+", [
              grammar.greedy_rule(
                "comment",
                "(?:^|[^\\\\])\\K\\/\\*[\\s\\S]*?(?:\\*\\/|$)",
              ),
              grammar.greedy_rule("comment", "(?:^|[^\\\\:])\\K\\/\\/.*"),
              grammar.greedy_rule(
                "string-literal",
                "r?(?:(\"\"\"|''')[\\s\\S]*?\\1|([\"'])(?:\\\\.|(?!\\2)[^\\\\\\r\\n])*\\2(?!\\2))",
              ),
              grammar.rule("function", "@\\w+"),
              grammar.rule_with_inside(
                "generics",
                "<(?:[\\w\\s,.&?]|<(?:[\\w\\s,.&?]|<(?:[\\w\\s,.&?]|<[\\w\\s,.&?]*>)*>)*>)*>",
                [
                  grammar.rule_with_inside(
                    "class-name",
                    "(?:^|[^\\w.])\\K(?:[a-z]\\w*\\s*\\.\\s*)*(?:[A-Z]\\w*\\s*\\.\\s*)*[A-Z](?:[\\d_A-Z]*[a-z]\\w*)?\\b",
                    [
                      grammar.rule_with_inside(
                        "namespace",
                        "^[a-z]\\w*(?:\\s*\\.\\s*[a-z]\\w*)*(?:\\s*\\.)?",
                        [
                          grammar.rule("punctuation", "\\."),
                        ],
                      ),
                    ],
                  ),
                  grammar.rule("keyword", "\\b(?:async|sync|yield)\\*"),
                  grammar.rule(
                    "keyword",
                    "\\b(?:abstract|assert|async|await|break|case|catch|class|const|continue|covariant|default|deferred|do|dynamic|else|enum|export|extends|extension|external|factory|final|finally|for|get|hide|if|implements|import|in|interface|library|mixin|new|null|on|operator|part|rethrow|return|set|show|static|super|switch|sync|this|throw|try|typedef|var|void|while|with|yield)\\b",
                  ),
                  grammar.rule("punctuation", "[<>(),.:]"),
                  grammar.rule("operator", "[?&|]"),
                ],
              ),
              grammar.rule(
                "class-name",
                "(?:^|[^\\w.])\\K(?:[a-z]\\w*\\s*\\.\\s*)*(?:[A-Z]\\w*\\s*\\.\\s*)*[A-Z](?:[\\d_A-Z]*[a-z]\\w*)?\\b",
              ),
              grammar.rule(
                "class-name",
                "(?:^|[^\\w.])\\K(?:[a-z]\\w*\\s*\\.\\s*)*(?:[A-Z]\\w*\\s*\\.\\s*)*[A-Z]\\w*(?=\\s+\\w+\\s*[;,=()])",
              ),
              grammar.rule("keyword", "\\b(?:async|sync|yield)\\*"),
              grammar.rule(
                "keyword",
                "\\b(?:abstract|assert|async|await|break|case|catch|class|const|continue|covariant|default|deferred|do|dynamic|else|enum|export|extends|extension|external|factory|final|finally|for|get|hide|if|implements|import|in|interface|library|mixin|new|null|on|operator|part|rethrow|return|set|show|static|super|switch|sync|this|throw|try|typedef|var|void|while|with|yield)\\b",
              ),
              grammar.rule("boolean", "\\b(?:false|true)\\b"),
              grammar.rule("function", "\\b\\w+(?=\\()"),
              grammar.rule(
                "number",
                "(?i)\\b0x[\\da-f]+\\b|(?:\\b\\d+(?:\\.\\d*)?|\\B\\.\\d+)(?:e[+-]?\\d+)?",
              ),
              grammar.rule(
                "operator",
                "\\bis!|\\b(?:as|is)\\b|\\+\\+|--|&&|\\|\\||<<=?|>>=?|~(?:\\/=?)?|[+\\-*\\/%&^|=!<>]=?|\\?",
              ),
              grammar.rule("punctuation", "[{}[\\];(),.:]"),
            ]),
          ],
        ),
        grammar.rule("string", "[\\s\\S]+"),
      ],
    ),
    grammar.rule("function", "@\\w+"),
    grammar.rule(
      "generics",
      "<(?:[\\w\\s,.&?]|<(?:[\\w\\s,.&?]|<(?:[\\w\\s,.&?]|<[\\w\\s,.&?]*>)*>)*>)*>",
    ),
    grammar.rule(
      "class-name",
      "(?:^|[^\\w.])\\K(?:[a-z]\\w*\\s*\\.\\s*)*(?:[A-Z]\\w*\\s*\\.\\s*)*[A-Z](?:[\\d_A-Z]*[a-z]\\w*)?\\b",
    ),
    grammar.rule(
      "class-name",
      "(?:^|[^\\w.])\\K(?:[a-z]\\w*\\s*\\.\\s*)*(?:[A-Z]\\w*\\s*\\.\\s*)*[A-Z]\\w*(?=\\s+\\w+\\s*[;,=()])",
    ),
    grammar.rule("keyword", "\\b(?:async|sync|yield)\\*"),
    grammar.rule(
      "keyword",
      "\\b(?:abstract|assert|async|await|break|case|catch|class|const|continue|covariant|default|deferred|do|dynamic|else|enum|export|extends|extension|external|factory|final|finally|for|get|hide|if|implements|import|in|interface|library|mixin|new|null|on|operator|part|rethrow|return|set|show|static|super|switch|sync|this|throw|try|typedef|var|void|while|with|yield)\\b",
    ),
    grammar.rule("boolean", "\\b(?:false|true)\\b"),
    grammar.rule("function", "\\b\\w+(?=\\()"),
    grammar.rule(
      "number",
      "(?i)\\b0x[\\da-f]+\\b|(?:\\b\\d+(?:\\.\\d*)?|\\B\\.\\d+)(?:e[+-]?\\d+)?",
    ),
    grammar.rule(
      "operator",
      "\\bis!|\\b(?:as|is)\\b|\\+\\+|--|&&|\\|\\||<<=?|>>=?|~(?:\\/=?)?|[+\\-*\\/%&^|=!<>]=?|\\?",
    ),
    grammar.rule("punctuation", "[{}[\\];(),.:]"),
  ]
}
