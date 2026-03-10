import gleam/option
import smalto/grammar.{type Grammar, type Rule, Grammar}

pub fn grammar() -> Grammar {
  Grammar(name: "html", extends: option.None, rules: rules())
}

fn rules() -> List(Rule) {
  [
    grammar.greedy_rule("comment", "<!--(?:(?!<!--)[\\s\\S])*?-->"),
    grammar.greedy_rule("prolog", "<\\?[\\s\\S]+?\\?>"),
    grammar.greedy_rule_with_inside(
      "doctype",
      "(?i)<!DOCTYPE(?:[^>\"'[\\]]|\"[^\"]*\"|'[^']*')+(?:\\[(?:[^<\"'\\]]|\"[^\"]*\"|'[^']*'|<(?!!--)|<!--(?:[^-]|-(?!->))*-->)*\\]\\s*)?>",
      [
        grammar.greedy_rule_with_inside(
          "internal-subset",
          "(?<=^[^\\[]*\\[)[\\s\\S]+(?=\\]>$)",
          [
            grammar.greedy_rule_with_inside(
              "style",
              "(?i)(?<=<style[^>]*>)(?:<!\\[CDATA\\[(?:[^\\]]|\\](?!\\]>))*\\]\\]>|(?!<!\\[CDATA\\[)[\\s\\S])*?(?=<\\/style>)",
              [
                grammar.rule_with_inside(
                  "included-cdata",
                  "(?i)<!\\[CDATA\\[[\\s\\S]*?\\]\\]>",
                  [
                    grammar.rule_with_inside(
                      "language-css",
                      "(?i)(?<=^<!\\[CDATA\\[)[\\s\\S]+?(?=\\]\\]>$)",
                      [
                        grammar.rule("comment", "\\/\\*[\\s\\S]*?\\*\\/"),
                        grammar.nested_rule(
                          "atrule",
                          "@[\\w-](?:[^;{\\s\"']|\\s+(?!\\s)|(?:\"(?:\\\\(?:\\r\\n|[\\s\\S])|[^\"\\\\\\r\\n])*\"|'(?:\\\\(?:\\r\\n|[\\s\\S])|[^'\\\\\\r\\n])*'))*?(?:;|(?=\\s*\\{))",
                          "css",
                        ),
                        grammar.greedy_rule_with_inside(
                          "url",
                          "(?i)\\burl\\((?:(?:\"(?:\\\\(?:\\r\\n|[\\s\\S])|[^\"\\\\\\r\\n])*\"|'(?:\\\\(?:\\r\\n|[\\s\\S])|[^'\\\\\\r\\n])*')|(?:[^\\\\\\r\\n()\"']|\\\\[\\s\\S])*)\\)",
                          [
                            grammar.rule("function", "(?i)^url"),
                            grammar.rule("punctuation", "^\\(|\\)$"),
                            grammar.rule(
                              "url",
                              "^(?:\"(?:\\\\(?:\\r\\n|[\\s\\S])|[^\"\\\\\\r\\n])*\"|'(?:\\\\(?:\\r\\n|[\\s\\S])|[^'\\\\\\r\\n])*')$",
                            ),
                          ],
                        ),
                        grammar.rule(
                          "selector",
                          "(?<=^|[{}\\s])[^{}\\s](?:[^{};\"'\\s]|\\s+(?![\\s{])|(?:\"(?:\\\\(?:\\r\\n|[\\s\\S])|[^\"\\\\\\r\\n])*\"|'(?:\\\\(?:\\r\\n|[\\s\\S])|[^'\\\\\\r\\n])*'))*(?=\\s*\\{)",
                        ),
                        grammar.greedy_rule(
                          "string",
                          "(?:\"(?:\\\\(?:\\r\\n|[\\s\\S])|[^\"\\\\\\r\\n])*\"|'(?:\\\\(?:\\r\\n|[\\s\\S])|[^'\\\\\\r\\n])*')",
                        ),
                        grammar.rule(
                          "property",
                          "(?i)(?<=^|[^-\\w\\xA0-\\x{FFFF}])(?!\\s)[-_a-z\\xA0-\\x{FFFF}](?:(?!\\s)[-\\w\\xA0-\\x{FFFF}])*(?=\\s*:)",
                        ),
                        grammar.rule("important", "(?i)!important\\b"),
                        grammar.rule(
                          "function",
                          "(?i)(?<=^|[^-a-z0-9])[-a-z0-9]+(?=\\()",
                        ),
                        grammar.rule("punctuation", "[(){};:,]"),
                      ],
                    ),
                    grammar.rule("cdata", "(?i)^<!\\[CDATA\\[|\\]\\]>$"),
                  ],
                ),
                grammar.rule("language-css", "[\\s\\S]+"),
              ],
            ),
            grammar.greedy_rule_with_inside(
              "script",
              "(?i)(?<=<script[^>]*>)(?:<!\\[CDATA\\[(?:[^\\]]|\\](?!\\]>))*\\]\\]>|(?!<!\\[CDATA\\[)[\\s\\S])*?(?=<\\/script>)",
              [
                grammar.rule_with_inside(
                  "included-cdata",
                  "(?i)<!\\[CDATA\\[[\\s\\S]*?\\]\\]>",
                  [
                    grammar.rule_with_inside(
                      "language-javascript",
                      "(?i)(?<=^<!\\[CDATA\\[)[\\s\\S]+?(?=\\]\\]>$)",
                      [
                        grammar.greedy_rule(
                          "comment",
                          "(?<=^|[^\\\\])\\/\\*[\\s\\S]*?(?:\\*\\/|$)",
                        ),
                        grammar.greedy_rule(
                          "comment",
                          "(?<=^|[^\\\\:])\\/\\/.*",
                        ),
                        grammar.greedy_rule("comment", "^#!.*"),
                        grammar.greedy_rule_with_inside(
                          "template-string",
                          "`(?:\\\\[\\s\\S]|\\$\\{(?:[^{}]|\\{(?:[^{}]|\\{[^}]*\\})*\\})+\\}|(?!\\$\\{)[^\\\\`])*`",
                          [
                            grammar.rule("string", "^`|`$"),
                            grammar.nested_rule(
                              "interpolation",
                              "(?<=(?:^|[^\\\\])(?:\\\\{2})*)\\$\\{(?:[^{}]|\\{(?:[^{}]|\\{[^}]*\\})*\\})+\\}",
                              "javascript",
                            ),
                            grammar.rule("string", "[\\s\\S]+"),
                          ],
                        ),
                        grammar.greedy_rule(
                          "property",
                          "(?m)(?<=(?:^|[,{])[ \\t]*)([\"'])(?:\\\\(?:\\r\\n|[\\s\\S])|(?!\\2)[^\\\\\\r\\n])*\\2(?=\\s*:)",
                        ),
                        grammar.greedy_rule(
                          "string",
                          "([\"'])(?:\\\\(?:\\r\\n|[\\s\\S])|(?!\\1)[^\\\\\\r\\n])*\\1",
                        ),
                        grammar.rule_with_inside(
                          "class-name",
                          "(?<=\\b(?:class|extends|implements|instanceof|interface|new)\\s+)[\\w.\\\\]+",
                          [
                            grammar.rule("punctuation", "[.\\\\]"),
                          ],
                        ),
                        grammar.rule(
                          "class-name",
                          "(?<=^|[^$\\w\\xA0-\\x{FFFF}])(?!\\s)[_$A-Z\\xA0-\\x{FFFF}](?:(?!\\s)[$\\w\\xA0-\\x{FFFF}])*(?=\\.(?:constructor|prototype))",
                        ),
                        grammar.greedy_rule_with_inside(
                          "regex",
                          "(?<=(?:^|[^$\\w\\xA0-\\x{FFFF}.\"'\\])\\s]|\\b(?:return|yield))\\s*)\\/(?:(?:\\[(?:[^\\]\\\\\\r\\n]|\\\\.)*\\]|\\\\.|[^/\\\\\\[\\r\\n])+\\/[dgimyus]{0,7}|(?:\\[(?:[^[\\]\\\\\\r\\n]|\\\\.|\\[(?:[^[\\]\\\\\\r\\n]|\\\\.|\\[(?:[^[\\]\\\\\\r\\n]|\\\\.)*\\])*\\])*\\]|\\\\.|[^/\\\\\\[\\r\\n])+\\/[dgimyus]{0,7}v[dgimyus]{0,7})(?=(?:\\s|\\/\\*(?:[^*]|\\*(?!\\/))*\\*\\/)*(?:$|[\\r\\n,.;:})\\]]|\\/\\/))",
                          [
                            grammar.rule(
                              "language-regex",
                              "^(?<=\\/)[\\s\\S]+(?=\\/[a-z]*$)",
                            ),
                            grammar.rule("regex-delimiter", "^\\/|\\/$"),
                            grammar.rule("regex-flags", "^[a-z]+$"),
                          ],
                        ),
                        grammar.rule(
                          "function",
                          "#?(?!\\s)[_$a-zA-Z\\xA0-\\x{FFFF}](?:(?!\\s)[$\\w\\xA0-\\x{FFFF}])*(?=\\s*[=:]\\s*(?:async\\s*)?(?:\\bfunction\\b|(?:\\((?:[^()]|\\([^()]*\\))*\\)|(?!\\s)[_$a-zA-Z\\xA0-\\x{FFFF}](?:(?!\\s)[$\\w\\xA0-\\x{FFFF}])*)\\s*=>))",
                        ),
                        grammar.rule(
                          "parameter",
                          "(?<=function(?:\\s+(?!\\s)[_$a-zA-Z\\xA0-\\x{FFFF}](?:(?!\\s)[$\\w\\xA0-\\x{FFFF}])*)?\\s*\\(\\s*)(?!\\s)(?:[^()\\s]|\\s+(?![\\s)])|\\([^()]*\\))+(?=\\s*\\))",
                        ),
                        grammar.rule(
                          "parameter",
                          "(?i)(?<=^|[^$\\w\\xA0-\\x{FFFF}])(?!\\s)[_$a-z\\xA0-\\x{FFFF}](?:(?!\\s)[$\\w\\xA0-\\x{FFFF}])*(?=\\s*=>)",
                        ),
                        grammar.rule(
                          "parameter",
                          "(?<=\\(\\s*)(?!\\s)(?:[^()\\s]|\\s+(?![\\s)])|\\([^()]*\\))+(?=\\s*\\)\\s*=>)",
                        ),
                        grammar.rule(
                          "parameter",
                          "(?<=(?:\\b|\\s|^)(?!(?:as|async|await|break|case|catch|class|const|continue|debugger|default|delete|do|else|enum|export|extends|finally|for|from|function|get|if|implements|import|in|instanceof|interface|let|new|null|of|package|private|protected|public|return|set|static|super|switch|this|throw|try|typeof|undefined|var|void|while|with|yield)(?![$\\w\\xA0-\\x{FFFF}]))(?:(?!\\s)[_$a-zA-Z\\xA0-\\x{FFFF}](?:(?!\\s)[$\\w\\xA0-\\x{FFFF}])*\\s*)\\(\\s*|\\]\\s*\\(\\s*)(?!\\s)(?:[^()\\s]|\\s+(?![\\s)])|\\([^()]*\\))+(?=\\s*\\)\\s*\\{)",
                        ),
                        grammar.rule("constant", "\\b[A-Z](?:[A-Z_]|\\dx?)*\\b"),
                        grammar.rule("keyword", "(?<=(?:^|\\})\\s*)catch\\b"),
                        grammar.rule(
                          "keyword",
                          "(?<=^|[^.]|\\.\\.\\.\\s*)\\b(?:as|assert(?=\\s*\\{)|async(?=\\s*(?:function\\b|\\(|[$\\w\\xA0-\\x{FFFF}]|$))|await|break|case|class|const|continue|debugger|default|delete|do|else|enum|export|extends|finally(?=\\s*(?:\\{|$))|for|from(?=\\s*(?:['\"]|$))|function|(?:get|set)(?=\\s*(?:[#\\[$\\w\\xA0-\\x{FFFF}]|$))|if|implements|import|in|instanceof|interface|let|new|null|of|package|private|protected|public|return|static|super|switch|this|throw|try|typeof|undefined|var|void|while|with|yield)\\b",
                        ),
                        grammar.rule("boolean", "\\b(?:false|true)\\b"),
                        grammar.rule(
                          "function",
                          "#?(?!\\s)[_$a-zA-Z\\xA0-\\x{FFFF}](?:(?!\\s)[$\\w\\xA0-\\x{FFFF}])*(?=\\s*(?:\\.\\s*(?:apply|bind|call)\\s*)?\\()",
                        ),
                        grammar.rule(
                          "number",
                          "(?<=^|[^\\w$])(?:NaN|Infinity|0[bB][01]+(?:_[01]+)*n?|0[oO][0-7]+(?:_[0-7]+)*n?|0[xX][\\dA-Fa-f]+(?:_[\\dA-Fa-f]+)*n?|\\d+(?:_\\d+)*n|(?:\\d+(?:_\\d+)*(?:\\.(?:\\d+(?:_\\d+)*)?)?|\\.\\d+(?:_\\d+)*)(?:[Ee][+-]?\\d+(?:_\\d+)*)?)(?![\\w$])",
                        ),
                        grammar.rule(
                          "property",
                          "(?m)(?<=(?:^|[,{])[ \\t]*)(?!\\s)[_$a-zA-Z\\xA0-\\x{FFFF}](?:(?!\\s)[$\\w\\xA0-\\x{FFFF}])*(?=\\s*:)",
                        ),
                        grammar.rule(
                          "operator",
                          "--|\\+\\+|\\*\\*=?|=>|&&=?|\\|\\|=?|[!=]==|<<=?|>>>?=?|[-+*/%&|^!=<>]=?|\\.{3}|\\?\\?=?|\\?\\.?|[~:]",
                        ),
                        grammar.rule("punctuation", "[{}[\\];(),.:]"),
                      ],
                    ),
                    grammar.rule("cdata", "(?i)^<!\\[CDATA\\[|\\]\\]>$"),
                  ],
                ),
                grammar.rule("language-javascript", "[\\s\\S]+"),
              ],
            ),
            grammar.greedy_rule("cdata", "(?i)<!\\[CDATA\\[[\\s\\S]*?\\]\\]>"),
            grammar.greedy_rule_with_inside(
              "tag",
              "<\\/?(?!\\d)[^\\s>\\/=$<%]+(?:\\s(?:\\s*[^\\s>\\/=]+(?:\\s*=\\s*(?:\"[^\"]*\"|'[^']*'|[^\\s'\">=]+(?=[\\s>]))|(?=[\\s/>])))+)?\\s*\\/?>",
              [
                grammar.rule_with_inside("tag", "^<\\/?[^\\s>\\/]+", [
                  grammar.rule("punctuation", "^<\\/?"),
                  grammar.rule("namespace", "^[^\\s>\\/:]+:"),
                ]),
                grammar.rule_with_inside(
                  "special-attr",
                  "(?i)(?<=^|[\"'\\s])(?:style)\\s*=\\s*(?:\"[^\"]*\"|'[^']*'|[^\\s'\">=]+(?=[\\s>]))",
                  [
                    grammar.rule("attr-name", "^[^\\s=]+"),
                    grammar.rule_with_inside("attr-value", "=[\\s\\S]+", [
                      grammar.rule(
                        "css",
                        "(?<=^=\\s*([\"']|(?![\"'])))\\S[\\s\\S]*(?=\\2$)",
                      ),
                      grammar.rule("attr-equals", "^="),
                      grammar.rule("punctuation", "\"|'"),
                    ]),
                  ],
                ),
                grammar.rule_with_inside(
                  "special-attr",
                  "(?i)(?<=^|[\"'\\s])(?:on(?:abort|blur|change|click|composition(?:end|start|update)|dblclick|error|focus(?:in|out)?|key(?:down|up)|load|mouse(?:down|enter|leave|move|out|over|up)|reset|resize|scroll|select|slotchange|submit|unload|wheel))\\s*=\\s*(?:\"[^\"]*\"|'[^']*'|[^\\s'\">=]+(?=[\\s>]))",
                  [
                    grammar.rule("attr-name", "^[^\\s=]+"),
                    grammar.rule_with_inside("attr-value", "=[\\s\\S]+", [
                      grammar.rule(
                        "javascript",
                        "(?<=^=\\s*([\"']|(?![\"'])))\\S[\\s\\S]*(?=\\2$)",
                      ),
                      grammar.rule("attr-equals", "^="),
                      grammar.rule("punctuation", "\"|'"),
                    ]),
                  ],
                ),
                grammar.rule_with_inside(
                  "attr-value",
                  "=\\s*(?:\"[^\"]*\"|'[^']*'|[^\\s'\">=]+)",
                  [
                    grammar.rule("attr-equals", "^="),
                    grammar.rule("punctuation", "^(?<=\\s*)[\"']|[\"']$"),
                    grammar.rule("named-entity", "(?i)&[\\da-z]{1,8};"),
                    grammar.rule("entity", "(?i)&#x?[\\da-f]{1,8};"),
                  ],
                ),
                grammar.rule("punctuation", "\\/?>"),
                grammar.rule_with_inside("attr-name", "[^\\s>\\/]+", [
                  grammar.rule("namespace", "^[^\\s>\\/:]+:"),
                ]),
              ],
            ),
            grammar.rule("entity", "(?i)&#x?[\\da-f]{1,8};"),
          ],
        ),
        grammar.greedy_rule("string", "\"[^\"]*\"|'[^']*'"),
        grammar.rule("punctuation", "^<!|>$|[[\\]]"),
        grammar.rule("doctype-tag", "(?i)^DOCTYPE"),
        grammar.rule("name", "[^\\s<>'\"]+"),
      ],
    ),
    grammar.rule("entity", "(?i)&#x?[\\da-f]{1,8};"),
  ]
}
