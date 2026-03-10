import gleam/option
import smalto/grammar.{type Grammar, type Rule, Grammar}

pub fn grammar() -> Grammar {
  Grammar(name: "php", extends: option.Some("clike"), rules: rules())
}

fn rules() -> List(Rule) {
  [
    grammar.rule("important", "(?i)\\?>$|^<\\?(?:php(?=\\s)|=)?"),
    grammar.rule("comment", "\\/\\*[\\s\\S]*?\\*\\/|\\/\\/.*|#(?!\\[).*"),
    grammar.greedy_rule_with_inside(
      "nowdoc-string",
      "<<<'([^']+)'[\\r\\n](?:.*[\\r\\n])*?\\1;",
      [
        grammar.rule_with_inside("symbol", "(?i)^<<<'[^']+'|[a-z_]\\w*;$", [
          grammar.rule("punctuation", "^<<<'?|[';]$"),
        ]),
      ],
    ),
    grammar.greedy_rule_with_inside(
      "heredoc-string",
      "(?i)<<<(?:\"([^\"]+)\"[\\r\\n](?:.*[\\r\\n])*?\\1;|([a-z_]\\w*)[\\r\\n](?:.*[\\r\\n])*?\\2;)",
      [
        grammar.rule_with_inside(
          "symbol",
          "(?i)^<<<(?:\"[^\"]+\"|[a-z_]\\w*)|[a-z_]\\w*;$",
          [
            grammar.rule("punctuation", "^<<<\"?|[\";]$"),
          ],
        ),
        grammar.rule_with_inside(
          "interpolation",
          "\\{\\$(?:\\{(?:\\{[^{}]+\\}|[^{}]+)\\}|[^{}])+\\}|(?<=^|[^\\\\{])\\$+(?:\\w+(?:\\[[^\\r\\n\\[\\]]+\\]|->\\w+)?)",
          [
            grammar.rule(
              "comment",
              "\\/\\*[\\s\\S]*?\\*\\/|\\/\\/.*|#(?!\\[).*",
            ),
            grammar.greedy_rule(
              "backtick-quoted-string",
              "`(?:\\\\[\\s\\S]|[^\\\\`])*`",
            ),
            grammar.greedy_rule(
              "single-quoted-string",
              "'(?:\\\\[\\s\\S]|[^\\\\'])*'",
            ),
            grammar.greedy_rule(
              "double-quoted-string",
              "\"(?:\\\\[\\s\\S]|[^\\\\\"])*\"",
            ),
            grammar.greedy_rule_with_inside(
              "attribute",
              "(?im)#\\[(?:[^\"'\\/#]|\\/(?![*/])|\\/\\/.*$|#(?!\\[).*$|\\/\\*(?:[^*]|\\*(?!\\/))*\\*\\/|\"(?:\\\\[\\s\\S]|[^\\\\\"])*\"|'(?:\\\\[\\s\\S]|[^\\\\'])*')+\\](?=\\s*[a-z$#])",
              [
                grammar.rule_with_inside(
                  "attribute-content",
                  "^(?<=#\\[)[\\s\\S]+(?=\\]$)",
                  [
                    grammar.rule(
                      "comment",
                      "\\/\\*[\\s\\S]*?\\*\\/|\\/\\/.*|#(?!\\[).*",
                    ),
                    grammar.greedy_rule(
                      "class-name",
                      "(?i)(?<=[^:]|^)\\b[a-z_]\\w*(?!\\\\)\\b",
                    ),
                    grammar.greedy_rule_with_inside(
                      "class-name",
                      "(?i)(?<=[^:]|^)(?:\\\\?\\b[a-z_]\\w*)+",
                      [
                        grammar.rule("punctuation", "\\\\"),
                      ],
                    ),
                    grammar.rule("boolean", "(?i)\\b(?:false|true)\\b"),
                    grammar.greedy_rule(
                      "constant",
                      "(?i)(?<=::\\s*)\\b[a-z_]\\w*\\b(?!\\s*\\()",
                    ),
                    grammar.greedy_rule(
                      "constant",
                      "(?i)(?<=\\b(?:case|const)\\s+)\\b[a-z_]\\w*(?=\\s*[;=])",
                    ),
                    grammar.rule("constant", "(?i)\\b(?:null)\\b"),
                    grammar.rule(
                      "constant",
                      "\\b[A-Z_][A-Z0-9_]*\\b(?!\\s*\\()",
                    ),
                    grammar.rule(
                      "number",
                      "(?i)\\b0b[01]+(?:_[01]+)*\\b|\\b0o[0-7]+(?:_[0-7]+)*\\b|\\b0x[\\da-f]+(?:_[\\da-f]+)*\\b|(?:\\b\\d+(?:_\\d+)*\\.?(?:\\d+(?:_\\d+)*)?|\\B\\.\\d+)(?:e[+-]?\\d+)?",
                    ),
                    grammar.rule(
                      "operator",
                      "<?=>|\\?\\?=?|\\.{3}|\\??->|[!=]=?=?|::|\\*\\*=?|--|\\+\\+|&&|\\|\\||<<|>>|[?~]|[/^|%*&<>.+-]=?",
                    ),
                    grammar.rule("punctuation", "[{}\\[\\](),:;]"),
                  ],
                ),
                grammar.rule("punctuation", "^#\\[|\\]$"),
              ],
            ),
            grammar.rule("variable", "\\$+(?:\\w+\\b|(?=\\{))"),
            grammar.rule_with_inside(
              "package",
              "(?i)(?<=namespace\\s+|use\\s+(?:function\\s+)?)(?:\\\\?\\b[a-z_]\\w*)+\\b(?!\\\\)",
              [
                grammar.rule("punctuation", "\\\\"),
              ],
            ),
            grammar.rule(
              "class-name",
              "(?i)(?<=\\b(?:class|enum|interface|trait)\\s+)\\b[a-z_]\\w*(?!\\\\)\\b",
            ),
            grammar.rule(
              "function",
              "(?i)(?<=\\bfunction\\s+)[a-z_]\\w*(?=\\s*\\()",
            ),
            grammar.greedy_rule(
              "type-casting",
              "(?i)(?<=\\(\\s*)\\b(?:array|bool|boolean|float|int|integer|object|string)\\b(?=\\s*\\))",
            ),
            grammar.greedy_rule(
              "type-hint",
              "(?i)(?<=[(,?]\\s*)\\b(?:array(?!\\s*\\()|bool|callable|(?:false|null)(?=\\s*\\|)|float|int|iterable|mixed|object|self|static|string)\\b(?=\\s*\\$)",
            ),
            grammar.greedy_rule(
              "return-type",
              "(?i)(?<=\\)\\s*:\\s*(?:\\?\\s*)?)\\b(?:array(?!\\s*\\()|bool|callable|(?:false|null)(?=\\s*\\|)|float|int|iterable|mixed|never|object|self|static|string|void)\\b",
            ),
            grammar.greedy_rule(
              "type-declaration",
              "(?i)\\b(?:array(?!\\s*\\()|bool|float|int|iterable|mixed|object|string|void)\\b",
            ),
            grammar.greedy_rule(
              "type-declaration",
              "(?i)(?<=\\|\\s*)(?:false|null)\\b|\\b(?:false|null)(?=\\s*\\|)",
            ),
            grammar.greedy_rule(
              "static-context",
              "(?i)\\b(?:parent|self|static)(?=\\s*::)",
            ),
            grammar.rule("keyword", "(?i)(?<=\\byield\\s+)from\\b"),
            grammar.rule("keyword", "(?i)\\bclass\\b"),
            grammar.rule(
              "keyword",
              "(?i)(?<=(?:^|[^\\s>:]|(?:^|[^-])>|(?:^|[^:]):)\\s*)\\b(?:abstract|and|array|as|break|callable|case|catch|clone|const|continue|declare|default|die|do|echo|else|elseif|empty|enddeclare|endfor|endforeach|endif|endswitch|endwhile|enum|eval|exit|extends|final|finally|fn|for|foreach|function|global|goto|if|implements|include|include_once|instanceof|insteadof|interface|isset|list|match|namespace|never|new|or|parent|print|private|protected|public|readonly|require|require_once|return|self|static|switch|throw|trait|try|unset|use|var|while|xor|yield|__halt_compiler)\\b",
            ),
            grammar.rule(
              "argument-name",
              "(?i)(?<=[(,]\\s*)\\b[a-z_]\\w*(?=\\s*:(?!:))",
            ),
            grammar.greedy_rule(
              "class-name",
              "(?i)(?<=\\b(?:extends|implements|instanceof|new(?!\\s+self|\\s+static))\\s+|\\bcatch\\s*\\()\\b[a-z_]\\w*(?!\\\\)\\b",
            ),
            grammar.greedy_rule(
              "class-name",
              "(?i)(?<=\\|\\s*)\\b[a-z_]\\w*(?!\\\\)\\b",
            ),
            grammar.greedy_rule(
              "class-name",
              "(?i)\\b[a-z_]\\w*(?!\\\\)\\b(?=\\s*\\|)",
            ),
            grammar.greedy_rule_with_inside(
              "class-name-fully-qualified",
              "(?i)(?<=\\|\\s*)(?:\\\\?\\b[a-z_]\\w*)+\\b",
              [
                grammar.rule("punctuation", "\\\\"),
              ],
            ),
            grammar.greedy_rule_with_inside(
              "class-name-fully-qualified",
              "(?i)(?:\\\\?\\b[a-z_]\\w*)+\\b(?=\\s*\\|)",
              [
                grammar.rule("punctuation", "\\\\"),
              ],
            ),
            grammar.greedy_rule_with_inside(
              "class-name-fully-qualified",
              "(?i)(?<=\\b(?:extends|implements|instanceof|new(?!\\s+self\\b|\\s+static\\b))\\s+|\\bcatch\\s*\\()(?:\\\\?\\b[a-z_]\\w*)+\\b(?!\\\\)",
              [
                grammar.rule("punctuation", "\\\\"),
              ],
            ),
            grammar.greedy_rule(
              "type-declaration",
              "(?i)\\b[a-z_]\\w*(?=\\s*\\$)",
            ),
            grammar.greedy_rule_with_inside(
              "class-name-fully-qualified",
              "(?i)(?:\\\\?\\b[a-z_]\\w*)+(?=\\s*\\$)",
              [
                grammar.rule("punctuation", "\\\\"),
              ],
            ),
            grammar.greedy_rule("static-context", "(?i)\\b[a-z_]\\w*(?=\\s*::)"),
            grammar.greedy_rule_with_inside(
              "class-name-fully-qualified",
              "(?i)(?:\\\\?\\b[a-z_]\\w*)+(?=\\s*::)",
              [
                grammar.rule("punctuation", "\\\\"),
              ],
            ),
            grammar.greedy_rule(
              "type-hint",
              "(?i)(?<=[(,?]\\s*)[a-z_]\\w*(?=\\s*\\$)",
            ),
            grammar.greedy_rule_with_inside(
              "class-name-fully-qualified",
              "(?i)(?<=[(,?]\\s*)(?:\\\\?\\b[a-z_]\\w*)+(?=\\s*\\$)",
              [
                grammar.rule("punctuation", "\\\\"),
              ],
            ),
            grammar.greedy_rule(
              "return-type",
              "(?i)(?<=\\)\\s*:\\s*(?:\\?\\s*)?)\\b[a-z_]\\w*(?!\\\\)\\b",
            ),
            grammar.greedy_rule_with_inside(
              "class-name-fully-qualified",
              "(?i)(?<=\\)\\s*:\\s*(?:\\?\\s*)?)(?:\\\\?\\b[a-z_]\\w*)+\\b(?!\\\\)",
              [
                grammar.rule("punctuation", "\\\\"),
              ],
            ),
            grammar.rule("constant", "(?i)\\b(?:null)\\b"),
            grammar.rule("constant", "\\b[A-Z_][A-Z0-9_]*\\b(?!\\s*\\()"),
            grammar.rule_with_inside(
              "function",
              "(?i)(?<=^|[^\\\\\\w])\\\\?[a-z_](?:[\\w\\\\]*\\w)?(?=\\s*\\()",
              [
                grammar.rule("punctuation", "\\\\"),
              ],
            ),
            grammar.rule("property", "(?<=->\\s*)\\w+"),
            grammar.rule(
              "number",
              "(?i)\\b0b[01]+(?:_[01]+)*\\b|\\b0o[0-7]+(?:_[0-7]+)*\\b|\\b0x[\\da-f]+(?:_[\\da-f]+)*\\b|(?:\\b\\d+(?:_\\d+)*\\.?(?:\\d+(?:_\\d+)*)?|\\B\\.\\d+)(?:e[+-]?\\d+)?",
            ),
            grammar.rule(
              "operator",
              "<?=>|\\?\\?=?|\\.{3}|\\??->|[!=]=?=?|::|\\*\\*=?|--|\\+\\+|&&|\\|\\||<<|>>|[?~]|[/^|%*&<>.+-]=?",
            ),
            grammar.rule("punctuation", "[{}\\[\\](),:;]"),
          ],
        ),
      ],
    ),
    grammar.rule("variable", "\\$+(?:\\w+\\b|(?=\\{))"),
    grammar.rule("keyword", "(?i)\\bclass\\b"),
    grammar.rule("constant", "(?i)\\b(?:null)\\b"),
    grammar.rule("constant", "\\b[A-Z_][A-Z0-9_]*\\b(?!\\s*\\()"),
    grammar.rule(
      "number",
      "(?i)\\b0b[01]+(?:_[01]+)*\\b|\\b0o[0-7]+(?:_[0-7]+)*\\b|\\b0x[\\da-f]+(?:_[\\da-f]+)*\\b|(?:\\b\\d+(?:_\\d+)*\\.?(?:\\d+(?:_\\d+)*)?|\\B\\.\\d+)(?:e[+-]?\\d+)?",
    ),
    grammar.rule(
      "operator",
      "<?=>|\\?\\?=?|\\.{3}|\\??->|[!=]=?=?|::|\\*\\*=?|--|\\+\\+|&&|\\|\\||<<|>>|[?~]|[/^|%*&<>.+-]=?",
    ),
    grammar.rule("punctuation", "[{}\\[\\](),:;]"),
  ]
}
