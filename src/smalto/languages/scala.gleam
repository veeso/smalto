import gleam/option
import smalto/grammar.{type Grammar, type Rule, Grammar}

pub fn grammar() -> Grammar {
  Grammar(name: "scala", extends: option.Some("java"), rules: rules())
}

fn rules() -> List(Rule) {
  [
    grammar.greedy_rule("comment", "(?<=^|[^\\\\])\\/\\*[\\s\\S]*?(?:\\*\\/|$)"),
    grammar.greedy_rule("comment", "(?<=^|[^\\\\:])\\/\\/.*"),
    grammar.greedy_rule_with_inside(
      "string-interpolation",
      "(?i)\\b[a-z]\\w*(?:\"\"\"(?:[^$]|\\$(?:[^{]|\\{(?:[^{}]|\\{[^{}]*\\})*\\}))*?\"\"\"|\"(?:[^$\"\\r\\n]|\\$(?:[^{]|\\{(?:[^{}]|\\{[^{}]*\\})*\\}))*\")",
      [
        grammar.greedy_rule("function", "^\\w+"),
        grammar.greedy_rule("symbol", "\\\\\\$\"|\\$[$\"]"),
        grammar.greedy_rule_with_inside(
          "interpolation",
          "\\$(?:\\w+|\\{(?:[^{}]|\\{[^{}]*\\})*\\})",
          [
            grammar.rule("punctuation", "^\\$\\{?|\\}$"),
            grammar.rule_with_inside("expression", "[\\s\\S]+", [
              grammar.greedy_rule("string", "\"\"\"[\\s\\S]*?\"\"\""),
              grammar.greedy_rule("char", "'(?:\\\\.|[^'\\\\\\r\\n]){1,6}'"),
              grammar.greedy_rule(
                "string",
                "(\"|')(?:\\\\.|(?!\\1)[^\\\\\\r\\n])*\\1",
              ),
              grammar.rule(
                "punctuation",
                "(?<=^|[^.])@\\w+(?:\\s*\\.\\s*\\w+)*",
              ),
              grammar.rule_with_inside(
                "generics",
                "<(?:[\\w\\s,.?]|&(?!&)|<(?:[\\w\\s,.?]|&(?!&)|<(?:[\\w\\s,.?]|&(?!&)|<(?:[\\w\\s,.?]|&(?!&))*>)*>)*>)*>",
                [
                  grammar.rule_with_inside(
                    "class-name",
                    "(?<=^|[^\\w.])(?:[a-z]\\w*\\s*\\.\\s*)*(?:[A-Z]\\w*\\s*\\.\\s*)*[A-Z](?:[\\d_A-Z]*[a-z]\\w*)?\\b",
                    [
                      grammar.rule_with_inside(
                        "namespace",
                        "^[a-z]\\w*(?:\\s*\\.\\s*[a-z]\\w*)*(?:\\s*\\.)?",
                        [
                          grammar.rule("punctuation", "\\."),
                        ],
                      ),
                      grammar.rule("punctuation", "\\."),
                    ],
                  ),
                  grammar.rule(
                    "keyword",
                    "\\b(?:abstract|assert|boolean|break|byte|case|catch|char|class|const|continue|default|do|double|else|enum|exports|extends|final|finally|float|for|goto|if|implements|import|instanceof|int|interface|long|module|native|new|non-sealed|null|open|opens|package|permits|private|protected|provides|public|record(?!\\s*[(){}[\\]<>=%~.:,;?+\\-*/&|^])|requires|return|sealed|short|static|strictfp|super|switch|synchronized|this|throw|throws|to|transient|transitive|try|uses|var|void|volatile|while|with|yield)\\b",
                  ),
                  grammar.rule("punctuation", "[<>(),.:]"),
                  grammar.rule("operator", "[?&|]"),
                ],
              ),
              grammar.rule_with_inside(
                "import",
                "(?<=\\bimport\\s+)(?:[a-z]\\w*\\s*\\.\\s*)*(?:[A-Z]\\w*\\s*\\.\\s*)*(?:[A-Z]\\w*|\\*)(?=\\s*;)",
                [
                  grammar.rule("punctuation", "\\."),
                  grammar.rule("operator", "\\*"),
                  grammar.rule("class-name", "\\w+"),
                ],
              ),
              grammar.rule_with_inside(
                "static",
                "(?<=\\bimport\\s+static\\s+)(?:[a-z]\\w*\\s*\\.\\s*)*(?:[A-Z]\\w*\\s*\\.\\s*)*(?:\\w+|\\*)(?=\\s*;)",
                [
                  grammar.rule("static", "\\b\\w+$"),
                  grammar.rule("punctuation", "\\."),
                  grammar.rule("operator", "\\*"),
                  grammar.rule("class-name", "\\w+"),
                ],
              ),
              grammar.rule_with_inside(
                "namespace",
                "(?<=\\b(?:exports|import(?:\\s+static)?|module|open|opens|package|provides|requires|to|transitive|uses|with)\\s+)(?!\\b(?:abstract|assert|boolean|break|byte|case|catch|char|class|const|continue|default|do|double|else|enum|exports|extends|final|finally|float|for|goto|if|implements|import|instanceof|int|interface|long|module|native|new|non-sealed|null|open|opens|package|permits|private|protected|provides|public|record(?!\\s*[(){}[\\]<>=%~.:,;?+\\-*/&|^])|requires|return|sealed|short|static|strictfp|super|switch|synchronized|this|throw|throws|to|transient|transitive|try|uses|var|void|volatile|while|with|yield)\\b)[a-z]\\w*(?:\\.[a-z]\\w*)*\\.?",
                [
                  grammar.rule("punctuation", "\\."),
                ],
              ),
              grammar.rule(
                "keyword",
                "<-|=>|\\b(?:abstract|case|catch|class|def|derives|do|else|enum|extends|extension|final|finally|for|forSome|given|if|implicit|import|infix|inline|lazy|match|new|null|object|opaque|open|override|package|private|protected|return|sealed|self|super|this|throw|trait|transparent|try|type|using|val|var|while|with|yield)\\b",
              ),
              grammar.rule("boolean", "\\b(?:false|true)\\b"),
              grammar.rule(
                "number",
                "(?i)\\b0x(?:[\\da-f]*\\.)?[\\da-f]+|(?:\\b\\d+(?:\\.\\d*)?|\\B\\.\\d+)(?:e\\d+)?[dfl]?",
              ),
              grammar.rule(
                "operator",
                "(?m)(?<=^|[^.])(?:<<=?|>>>?=?|->|--|\\+\\+|&&|\\|\\||::|[?:~]|[-+*/%&|^!=<>]=?)",
              ),
              grammar.rule("punctuation", "[{}[\\];(),.:]"),
              grammar.rule(
                "builtin",
                "\\b(?:Any|AnyRef|AnyVal|Boolean|Byte|Char|Double|Float|Int|Long|Nothing|Short|String|Unit)\\b",
              ),
              grammar.rule("symbol", "'[^\\d\\s\\\\]\\w*"),
            ]),
          ],
        ),
        grammar.rule("string", "[\\s\\S]+"),
      ],
    ),
    grammar.rule(
      "keyword",
      "<-|=>|\\b(?:abstract|case|catch|class|def|derives|do|else|enum|extends|extension|final|finally|for|forSome|given|if|implicit|import|infix|inline|lazy|match|new|null|object|opaque|open|override|package|private|protected|return|sealed|self|super|this|throw|trait|transparent|try|type|using|val|var|while|with|yield)\\b",
    ),
    grammar.rule("boolean", "\\b(?:false|true)\\b"),
    grammar.rule(
      "number",
      "(?i)\\b0x(?:[\\da-f]*\\.)?[\\da-f]+|(?:\\b\\d+(?:\\.\\d*)?|\\B\\.\\d+)(?:e\\d+)?[dfl]?",
    ),
    grammar.rule("punctuation", "[{}[\\];(),.:]"),
    grammar.rule(
      "builtin",
      "\\b(?:Any|AnyRef|AnyVal|Boolean|Byte|Char|Double|Float|Int|Long|Nothing|Short|String|Unit)\\b",
    ),
    grammar.rule("symbol", "'[^\\d\\s\\\\]\\w*"),
  ]
}
