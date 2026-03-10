import gleam/option
import smalto/grammar.{type Grammar, type Rule, Grammar}

pub fn grammar() -> Grammar {
  Grammar(name: "ruby", extends: option.Some("clike"), rules: rules())
}

fn rules() -> List(Rule) {
  [
    grammar.greedy_rule("comment", "(?m)#.*|^=begin\\s[\\s\\S]*?^=end"),
    grammar.greedy_rule_with_inside(
      "string-literal",
      "%[qQiIwWs]?(?:([^a-zA-Z0-9\\s{(\\[<=])(?:(?!\\1)[^\\\\]|\\\\[\\s\\S])*\\1|\\((?:[^()\\\\]|\\\\[\\s\\S]|\\((?:[^()\\\\]|\\\\[\\s\\S])*\\))*\\)|\\{(?:[^{}\\\\]|\\\\[\\s\\S]|\\{(?:[^{}\\\\]|\\\\[\\s\\S])*\\})*\\}|\\[(?:[^\\[\\]\\\\]|\\\\[\\s\\S]|\\[(?:[^\\[\\]\\\\]|\\\\[\\s\\S])*\\])*\\]|<(?:[^<>\\\\]|\\\\[\\s\\S]|<(?:[^<>\\\\]|\\\\[\\s\\S])*>)*>)",
      [
        grammar.rule_with_inside(
          "interpolation",
          "(?<=(?:^|[^\\\\])(?:\\\\{2})*)#\\{(?:[^{}]|\\{[^{}]*\\})*\\}",
          [
            grammar.rule_with_inside("content", "^(?<=#\\{)[\\s\\S]+(?=\\}$)", [
              grammar.greedy_rule_with_inside(
                "string-literal",
                "(\"|')(?:#\\{[^}]+\\}|#(?!\\{)|\\\\(?:\\r\\n|[\\s\\S])|(?!\\1)[^\\\\#\\r\\n])*\\1",
                [
                  grammar.rule("string", "[\\s\\S]+"),
                ],
              ),
              grammar.greedy_rule_with_inside(
                "heredoc-string",
                "(?i)<<[-~]?([a-z_]\\w*)[\\r\\n](?:.*[\\r\\n])*?[\\t ]*\\1",
                [
                  grammar.rule_with_inside(
                    "delimiter",
                    "(?i)^<<[-~]?[a-z_]\\w*|\\b[a-z_]\\w*$",
                    [
                      grammar.rule("symbol", "\\b\\w+"),
                      grammar.rule("punctuation", "^<<[-~]?"),
                    ],
                  ),
                  grammar.rule("string", "[\\s\\S]+"),
                ],
              ),
              grammar.greedy_rule_with_inside(
                "heredoc-string",
                "(?i)<<[-~]?'([a-z_]\\w*)'[\\r\\n](?:.*[\\r\\n])*?[\\t ]*\\1",
                [
                  grammar.rule_with_inside(
                    "delimiter",
                    "(?i)^<<[-~]?'[a-z_]\\w*'|\\b[a-z_]\\w*$",
                    [
                      grammar.rule("symbol", "\\b\\w+"),
                      grammar.rule("punctuation", "^<<[-~]?'|'$"),
                    ],
                  ),
                  grammar.rule("string", "[\\s\\S]+"),
                ],
              ),
              grammar.greedy_rule_with_inside(
                "command-literal",
                "%x(?:([^a-zA-Z0-9\\s{(\\[<=])(?:(?!\\1)[^\\\\]|\\\\[\\s\\S])*\\1|\\((?:[^()\\\\]|\\\\[\\s\\S]|\\((?:[^()\\\\]|\\\\[\\s\\S])*\\))*\\)|\\{(?:[^{}\\\\]|\\\\[\\s\\S]|\\{(?:[^{}\\\\]|\\\\[\\s\\S])*\\})*\\}|\\[(?:[^\\[\\]\\\\]|\\\\[\\s\\S]|\\[(?:[^\\[\\]\\\\]|\\\\[\\s\\S])*\\])*\\]|<(?:[^<>\\\\]|\\\\[\\s\\S]|<(?:[^<>\\\\]|\\\\[\\s\\S])*>)*>)",
                [
                  grammar.rule("string", "[\\s\\S]+"),
                ],
              ),
              grammar.greedy_rule_with_inside(
                "command-literal",
                "`(?:#\\{[^}]+\\}|#(?!\\{)|\\\\(?:\\r\\n|[\\s\\S])|[^\\\\`#\\r\\n])*`",
                [
                  grammar.rule("string", "[\\s\\S]+"),
                ],
              ),
              grammar.rule_with_inside(
                "class-name",
                "(?<=\\b(?:class|module)\\s+|\\bcatch\\s+\\()[\\w.\\\\]+|\\b[A-Z_]\\w*(?=\\s*\\.\\s*new\\b)",
                [
                  grammar.rule("punctuation", "[.\\\\]"),
                ],
              ),
              grammar.greedy_rule_with_inside(
                "regex-literal",
                "%r(?:([^a-zA-Z0-9\\s{(\\[<=])(?:(?!\\1)[^\\\\]|\\\\[\\s\\S])*\\1|\\((?:[^()\\\\]|\\\\[\\s\\S]|\\((?:[^()\\\\]|\\\\[\\s\\S])*\\))*\\)|\\{(?:[^{}\\\\]|\\\\[\\s\\S]|\\{(?:[^{}\\\\]|\\\\[\\s\\S])*\\})*\\}|\\[(?:[^\\[\\]\\\\]|\\\\[\\s\\S]|\\[(?:[^\\[\\]\\\\]|\\\\[\\s\\S])*\\])*\\]|<(?:[^<>\\\\]|\\\\[\\s\\S]|<(?:[^<>\\\\]|\\\\[\\s\\S])*>)*>)[egimnosux]{0,6}",
                [
                  grammar.rule("regex", "[\\s\\S]+"),
                ],
              ),
              grammar.greedy_rule_with_inside(
                "regex-literal",
                "(?<=^|[^/])\\/(?!\\/)(?:\\[[^\\r\\n\\]]+\\]|\\\\.|[^[/\\\\\\r\\n])+\\/[egimnosux]{0,6}(?=\\s*(?:$|[\\r\\n,.;})#]))",
                [
                  grammar.rule("regex", "[\\s\\S]+"),
                ],
              ),
              grammar.rule("variable", "[@$]+[a-zA-Z_]\\w*(?:[?!]|\\b)"),
              grammar.greedy_rule(
                "symbol",
                "(?<=^|[^:]):(?:\"(?:\\\\.|[^\"\\\\\\r\\n])*\"|(?:\\b[a-zA-Z_]\\w*|[^\\s\\0-\\x7F]+)[?!]?|\\$.)",
              ),
              grammar.greedy_rule(
                "symbol",
                "(?<=[\\r\\n{(,][ \\t]*)(?:\"(?:\\\\.|[^\"\\\\\\r\\n])*\"|(?:\\b[a-zA-Z_]\\w*|[^\\s\\0-\\x7F]+)[?!]?|\\$.)(?=:(?!:))",
              ),
              grammar.rule_with_inside(
                "method-definition",
                "(?<=\\bdef\\s+)\\w+(?:\\s*\\.\\s*\\w+)?",
                [
                  grammar.rule("function", "\\b\\w+$"),
                  grammar.rule("keyword", "^self\\b"),
                  grammar.rule("class-name", "^\\w+"),
                  grammar.rule("punctuation", "\\."),
                ],
              ),
              grammar.rule(
                "keyword",
                "\\b(?:BEGIN|END|alias|and|begin|break|case|class|def|define_method|defined|do|each|else|elsif|end|ensure|extend|for|if|in|include|module|new|next|nil|not|or|prepend|private|protected|public|raise|redo|require|rescue|retry|return|self|super|then|throw|undef|unless|until|when|while|yield)\\b",
              ),
              grammar.rule("boolean", "\\b(?:false|true)\\b"),
              grammar.rule(
                "builtin",
                "\\b(?:Array|Bignum|Binding|Class|Continuation|Dir|Exception|FalseClass|File|Fixnum|Float|Hash|IO|Integer|MatchData|Method|Module|NilClass|Numeric|Object|Proc|Range|Regexp|Stat|String|Struct|Symbol|TMS|Thread|ThreadGroup|Time|TrueClass)\\b",
              ),
              grammar.rule("constant", "\\b[A-Z][A-Z0-9_]*(?:[?!]|\\b)"),
              grammar.rule(
                "number",
                "(?i)\\b0x[\\da-f]+\\b|(?:\\b\\d+(?:\\.\\d*)?|\\B\\.\\d+)(?:e[+-]?\\d+)?",
              ),
              grammar.rule("punctuation", "::"),
              grammar.rule(
                "operator",
                "\\.{2,3}|&\\.|===|<?=>|[!=]?~|(?:&&|\\|\\||<<|>>|\\*\\*|[+\\-*/%<>!^&|=])=?|[?:]",
              ),
              grammar.rule("punctuation", "[(){}[\\].,;]"),
            ]),
            grammar.rule("punctuation", "^#\\{|\\}$"),
          ],
        ),
        grammar.rule("string", "[\\s\\S]+"),
      ],
    ),
    grammar.rule("variable", "[@$]+[a-zA-Z_]\\w*(?:[?!]|\\b)"),
    grammar.rule(
      "keyword",
      "\\b(?:BEGIN|END|alias|and|begin|break|case|class|def|define_method|defined|do|each|else|elsif|end|ensure|extend|for|if|in|include|module|new|next|nil|not|or|prepend|private|protected|public|raise|redo|require|rescue|retry|return|self|super|then|throw|undef|unless|until|when|while|yield)\\b",
    ),
    grammar.rule("boolean", "\\b(?:false|true)\\b"),
    grammar.rule(
      "builtin",
      "\\b(?:Array|Bignum|Binding|Class|Continuation|Dir|Exception|FalseClass|File|Fixnum|Float|Hash|IO|Integer|MatchData|Method|Module|NilClass|Numeric|Object|Proc|Range|Regexp|Stat|String|Struct|Symbol|TMS|Thread|ThreadGroup|Time|TrueClass)\\b",
    ),
    grammar.rule("constant", "\\b[A-Z][A-Z0-9_]*(?:[?!]|\\b)"),
    grammar.rule(
      "number",
      "(?i)\\b0x[\\da-f]+\\b|(?:\\b\\d+(?:\\.\\d*)?|\\B\\.\\d+)(?:e[+-]?\\d+)?",
    ),
    grammar.rule(
      "operator",
      "\\.{2,3}|&\\.|===|<?=>|[!=]?~|(?:&&|\\|\\||<<|>>|\\*\\*|[+\\-*/%<>!^&|=])=?|[?:]",
    ),
    grammar.rule("punctuation", "[(){}[\\].,;]"),
  ]
}
