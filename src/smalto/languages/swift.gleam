import gleam/option
import smalto/grammar.{type Grammar, type Rule, Grammar}

pub fn grammar() -> Grammar {
  Grammar(name: "swift", extends: option.Some("clike"), rules: rules())
}

fn rules() -> List(Rule) {
  [
    grammar.greedy_rule(
      "comment",
      "(?<=^|[^\\\\:])(?:\\/\\/.*|\\/\\*(?:[^/*]|\\/(?!\\*)|\\*(?!\\/)|\\/\\*(?:[^*]|\\*(?!\\/))*\\*\\/)*\\*\\/)",
    ),
    grammar.greedy_rule_with_inside(
      "string-literal",
      "(?<=^|[^\"#])(?:\"(?:\\\\(?:\\((?:[^()]|\\([^()]*\\))*\\)|\\r\\n|[^(])|[^\\\\\\r\\n\"])*\"|\"\"\"(?:\\\\(?:\\((?:[^()]|\\([^()]*\\))*\\)|[^(])|[^\\\\\"]|\"(?!\"\"))*\"\"\")(?![\"#])",
      [
        grammar.rule_with_inside(
          "interpolation",
          "(?<=\\\\\\()(?:[^()]|\\([^()]*\\))*(?=\\))",
          [
            grammar.greedy_rule_with_inside(
              "string-literal",
              "(?<=^|[^\"#])(#+)(?:\"(?:\\\\(?:#+\\((?:[^()]|\\([^()]*\\))*\\)|\\r\\n|[^#])|[^\\\\\\r\\n])*?\"|\"\"\"(?:\\\\(?:#+\\((?:[^()]|\\([^()]*\\))*\\)|[^#])|[^\\\\])*?\"\"\")\\2",
              [
                grammar.rule(
                  "interpolation",
                  "(?<=\\\\#+\\()(?:[^()]|\\([^()]*\\))*(?=\\))",
                ),
                grammar.rule("punctuation", "^\\)|\\\\#+\\($"),
                grammar.rule("string", "[\\s\\S]+"),
              ],
            ),
            grammar.rule_with_inside(
              "property",
              "#(?:(?:elseif|if)\\b(?:[ 	]*(?:![ \\t]*)?(?:\\b\\w+\\b(?:[ \\t]*\\((?:[^()]|\\([^()]*\\))*\\))?|\\((?:[^()]|\\([^()]*\\))*\\))(?:[ \\t]*(?:&&|\\|\\|))?)+|(?:else|endif)\\b)",
              [
                grammar.rule("directive-name", "^#\\w+"),
                grammar.rule("boolean", "\\b(?:false|true)\\b"),
                grammar.rule("number", "\\b\\d+(?:\\.\\d+)*\\b"),
                grammar.rule("operator", "!|&&|\\|\\||[<>]=?"),
                grammar.rule("punctuation", "[(),]"),
              ],
            ),
            grammar.rule(
              "constant",
              "#(?:colorLiteral|column|dsohandle|file(?:ID|Literal|Path)?|function|imageLiteral|line)\\b",
            ),
            grammar.rule("property", "#\\w+\\b"),
            grammar.rule("atrule", "@\\w+"),
            grammar.rule("function", "(?<=\\bfunc\\s+)\\w+"),
            grammar.rule(
              "important",
              "\\b(?<=break|continue)\\s+\\w+|\\b[a-zA-Z_]\\w*(?=\\s*:\\s*(?:for|repeat|while)\\b)",
            ),
            grammar.rule(
              "keyword",
              "\\b(?:Any|Protocol|Self|Type|actor|as|assignment|associatedtype|associativity|async|await|break|case|catch|class|continue|convenience|default|defer|deinit|didSet|do|dynamic|else|enum|extension|fallthrough|fileprivate|final|for|func|get|guard|higherThan|if|import|in|indirect|infix|init|inout|internal|is|isolated|lazy|left|let|lowerThan|mutating|none|nonisolated|nonmutating|open|operator|optional|override|postfix|precedencegroup|prefix|private|protocol|public|repeat|required|rethrows|return|right|safe|self|set|some|static|struct|subscript|super|switch|throw|throws|try|typealias|unowned|unsafe|var|weak|where|while|willSet)\\b",
            ),
            grammar.rule("boolean", "\\b(?:false|true)\\b"),
            grammar.rule("constant", "\\bnil\\b"),
            grammar.rule("short-argument", "\\$\\d+\\b"),
            grammar.rule("keyword", "\\b_\\b"),
            grammar.rule(
              "number",
              "(?i)\\b(?:[\\d_]+(?:\\.[\\de_]+)?|0x[a-f0-9_]+(?:\\.[a-f0-9p_]+)?|0b[01_]+|0o[0-7_]+)\\b",
            ),
            grammar.rule("class-name", "\\b[A-Z](?:[A-Z_\\d]*[a-z]\\w*)?\\b"),
            grammar.rule("function", "(?i)\\b[a-z_]\\w*(?=\\s*\\()"),
            grammar.rule("constant", "\\b(?:[A-Z_]{2,}|k[A-Z][A-Za-z_]+)\\b"),
            grammar.rule(
              "operator",
              "[-+*/%=!<>&|^~?]+|\\.[.\\-+*/%=!<>&|^~?]+",
            ),
            grammar.rule("punctuation", "[{}[\\]();,.:\\\\]"),
          ],
        ),
        grammar.rule("punctuation", "^\\)|\\\\\\($"),
        grammar.rule("punctuation", "\\\\(?=[\\r\\n])"),
        grammar.rule("string", "[\\s\\S]+"),
      ],
    ),
    grammar.rule(
      "keyword",
      "\\b(?:Any|Protocol|Self|Type|actor|as|assignment|associatedtype|associativity|async|await|break|case|catch|class|continue|convenience|default|defer|deinit|didSet|do|dynamic|else|enum|extension|fallthrough|fileprivate|final|for|func|get|guard|higherThan|if|import|in|indirect|infix|init|inout|internal|is|isolated|lazy|left|let|lowerThan|mutating|none|nonisolated|nonmutating|open|operator|optional|override|postfix|precedencegroup|prefix|private|protocol|public|repeat|required|rethrows|return|right|safe|self|set|some|static|struct|subscript|super|switch|throw|throws|try|typealias|unowned|unsafe|var|weak|where|while|willSet)\\b",
    ),
    grammar.rule("boolean", "\\b(?:false|true)\\b"),
    grammar.rule("short-argument", "\\$\\d+\\b"),
    grammar.rule(
      "number",
      "(?i)\\b(?:[\\d_]+(?:\\.[\\de_]+)?|0x[a-f0-9_]+(?:\\.[a-f0-9p_]+)?|0b[01_]+|0o[0-7_]+)\\b",
    ),
    grammar.rule("class-name", "\\b[A-Z](?:[A-Z_\\d]*[a-z]\\w*)?\\b"),
    grammar.rule("function", "(?i)\\b[a-z_]\\w*(?=\\s*\\()"),
    grammar.rule("constant", "\\b(?:[A-Z_]{2,}|k[A-Z][A-Za-z_]+)\\b"),
    grammar.rule("operator", "[-+*/%=!<>&|^~?]+|\\.[.\\-+*/%=!<>&|^~?]+"),
    grammar.rule("punctuation", "[{}[\\]();,.:\\\\]"),
  ]
}
