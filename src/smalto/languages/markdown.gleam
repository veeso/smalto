import gleam/option
import smalto/grammar.{type Grammar, type Rule, Grammar}

pub fn grammar() -> Grammar {
  Grammar(name: "markdown", extends: option.None, rules: rules())
}

fn rules() -> List(Rule) {
  [
    grammar.greedy_rule("comment", "<!--(?:(?!<!--)[\\s\\S])*?-->"),
    grammar.greedy_rule_with_inside(
      "front-matter-block",
      "(?<=^(?:\\s*[\\r\\n])?)---(?!.)[\\s\\S]*?[\\r\\n]---(?!.)",
      [
        grammar.rule("punctuation", "^---|---$"),
        grammar.rule_with_inside("yaml", "\\S+(?:\\s+\\S+)*", [
          grammar.rule(
            "string",
            "(?<=[\\-:]\\s*(?:\\s(?:!(?:<[\\w\\-%#;/?:@&=+$,.!~*'()[\\]]+>|(?:[a-zA-Z\\d-]*!)?[\\w\\-%#;/?:@&=+$.~*'()]+)?(?:[ 	]+[*&][^\\s[\\]{},]+)?|[*&][^\\s[\\]{},]+(?:[ 	]+!(?:<[\\w\\-%#;/?:@&=+$,.!~*'()[\\]]+>|(?:[a-zA-Z\\d-]*!)?[\\w\\-%#;/?:@&=+$.~*'()]+)?)?)[ \\t]+)?[|>])[ \\t]*(?:((?:\\r?\\n|\\r)[ \\t]+)\\S[^\\r\\n]*(?:\\2[^\\r\\n]+)*)",
          ),
          grammar.rule("comment", "#.*"),
          grammar.greedy_rule(
            "atrule",
            "(?<=(?:^|[:\\-,[{\\r\\n?])[ \\t]*(?:(?:!(?:<[\\w\\-%#;/?:@&=+$,.!~*'()[\\]]+>|(?:[a-zA-Z\\d-]*!)?[\\w\\-%#;/?:@&=+$.~*'()]+)?(?:[ 	]+[*&][^\\s[\\]{},]+)?|[*&][^\\s[\\]{},]+(?:[ 	]+!(?:<[\\w\\-%#;/?:@&=+$,.!~*'()[\\]]+>|(?:[a-zA-Z\\d-]*!)?[\\w\\-%#;/?:@&=+$.~*'()]+)?)?)[ \\t]+)?)(?:(?:[^\\s\\x00-\\x08\\x0e-\\x1f!\"#%&'*,\\-:>?@[\\]`{|}\\x7f-\\x84\\x86-\\x9f\\x{d800}-\\x{dfff}\\x{fffe}\\x{ffff}]|[?:-][^\\s\\x00-\\x08\\x0e-\\x1f,[\\]{}\\x7f-\\x84\\x86-\\x9f\\x{d800}-\\x{dfff}\\x{fffe}\\x{ffff}])(?:[ \\t]*(?:(?![#:])[^\\s\\x00-\\x08\\x0e-\\x1f,[\\]{}\\x7f-\\x84\\x86-\\x9f\\x{d800}-\\x{dfff}\\x{fffe}\\x{ffff}]|:[^\\s\\x00-\\x08\\x0e-\\x1f,[\\]{}\\x7f-\\x84\\x86-\\x9f\\x{d800}-\\x{dfff}\\x{fffe}\\x{ffff}]))*|\"(?:[^\"\\\\\\r\\n]|\\\\.)*\"|'(?:[^'\\\\\\r\\n]|\\\\.)*')(?=\\s*:\\s)",
          ),
          grammar.rule("important", "(?m)(?<=^[ \\t]*)%.+"),
          grammar.rule(
            "number",
            "(?m)(?<=[:\\-,[{]\\s*(?:\\s(?:!(?:<[\\w\\-%#;/?:@&=+$,.!~*'()[\\]]+>|(?:[a-zA-Z\\d-]*!)?[\\w\\-%#;/?:@&=+$.~*'()]+)?(?:[ 	]+[*&][^\\s[\\]{},]+)?|[*&][^\\s[\\]{},]+(?:[ 	]+!(?:<[\\w\\-%#;/?:@&=+$,.!~*'()[\\]]+>|(?:[a-zA-Z\\d-]*!)?[\\w\\-%#;/?:@&=+$.~*'()]+)?)?)[ \\t]+)?)(?:\\d{4}-\\d\\d?-\\d\\d?(?:[tT]|[ \\t]+)\\d\\d?:\\d{2}:\\d{2}(?:\\.\\d*)?(?:[ \\t]*(?:Z|[-+]\\d\\d?(?::\\d{2})?))?|\\d{4}-\\d{2}-\\d{2}|\\d\\d?:\\d{2}(?::\\d{2}(?:\\.\\d*)?)?)(?=[ \\t]*(?:$|,|\\]|\\}|(?:[\\r\\n]\\s*)?#))",
          ),
          grammar.rule(
            "important",
            "(?im)(?<=[:\\-,[{]\\s*(?:\\s(?:!(?:<[\\w\\-%#;/?:@&=+$,.!~*'()[\\]]+>|(?:[a-zA-Z\\d-]*!)?[\\w\\-%#;/?:@&=+$.~*'()]+)?(?:[ 	]+[*&][^\\s[\\]{},]+)?|[*&][^\\s[\\]{},]+(?:[ 	]+!(?:<[\\w\\-%#;/?:@&=+$,.!~*'()[\\]]+>|(?:[a-zA-Z\\d-]*!)?[\\w\\-%#;/?:@&=+$.~*'()]+)?)?)[ \\t]+)?)(?:false|true)(?=[ \\t]*(?:$|,|\\]|\\}|(?:[\\r\\n]\\s*)?#))",
          ),
          grammar.rule(
            "important",
            "(?im)(?<=[:\\-,[{]\\s*(?:\\s(?:!(?:<[\\w\\-%#;/?:@&=+$,.!~*'()[\\]]+>|(?:[a-zA-Z\\d-]*!)?[\\w\\-%#;/?:@&=+$.~*'()]+)?(?:[ 	]+[*&][^\\s[\\]{},]+)?|[*&][^\\s[\\]{},]+(?:[ 	]+!(?:<[\\w\\-%#;/?:@&=+$,.!~*'()[\\]]+>|(?:[a-zA-Z\\d-]*!)?[\\w\\-%#;/?:@&=+$.~*'()]+)?)?)[ \\t]+)?)(?:null|~)(?=[ \\t]*(?:$|,|\\]|\\}|(?:[\\r\\n]\\s*)?#))",
          ),
          grammar.greedy_rule(
            "string",
            "(?m)(?<=[:\\-,[{]\\s*(?:\\s(?:!(?:<[\\w\\-%#;/?:@&=+$,.!~*'()[\\]]+>|(?:[a-zA-Z\\d-]*!)?[\\w\\-%#;/?:@&=+$.~*'()]+)?(?:[ 	]+[*&][^\\s[\\]{},]+)?|[*&][^\\s[\\]{},]+(?:[ 	]+!(?:<[\\w\\-%#;/?:@&=+$,.!~*'()[\\]]+>|(?:[a-zA-Z\\d-]*!)?[\\w\\-%#;/?:@&=+$.~*'()]+)?)?)[ \\t]+)?)(?:\"(?:[^\"\\\\\\r\\n]|\\\\.)*\"|'(?:[^'\\\\\\r\\n]|\\\\.)*')(?=[ \\t]*(?:$|,|\\]|\\}|(?:[\\r\\n]\\s*)?#))",
          ),
          grammar.rule(
            "number",
            "(?im)(?<=[:\\-,[{]\\s*(?:\\s(?:!(?:<[\\w\\-%#;/?:@&=+$,.!~*'()[\\]]+>|(?:[a-zA-Z\\d-]*!)?[\\w\\-%#;/?:@&=+$.~*'()]+)?(?:[ 	]+[*&][^\\s[\\]{},]+)?|[*&][^\\s[\\]{},]+(?:[ 	]+!(?:<[\\w\\-%#;/?:@&=+$,.!~*'()[\\]]+>|(?:[a-zA-Z\\d-]*!)?[\\w\\-%#;/?:@&=+$.~*'()]+)?)?)[ \\t]+)?)(?:[+-]?(?:0x[\\da-f]+|0o[0-7]+|(?:\\d+(?:\\.\\d*)?|\\.\\d+)(?:e[+-]?\\d+)?|\\.inf|\\.nan))(?=[ \\t]*(?:$|,|\\]|\\}|(?:[\\r\\n]\\s*)?#))",
          ),
          grammar.rule(
            "tag",
            "!(?:<[\\w\\-%#;/?:@&=+$,.!~*'()[\\]]+>|(?:[a-zA-Z\\d-]*!)?[\\w\\-%#;/?:@&=+$.~*'()]+)?",
          ),
          grammar.rule("important", "[*&][^\\s[\\]{},]+"),
          grammar.rule("punctuation", "---|[:[\\]{}\\-,|>?]|\\.\\.\\."),
        ]),
      ],
    ),
    grammar.rule("punctuation", "(?m)^>(?:[\\t ]*>)*"),
    grammar.rule_with_inside(
      "table",
      "(?m)^\\|?(?:\\\\.|``(?:[^`\\r\\n]|`(?!`))+``|`[^`\\r\\n]+`|[^\\\\|\\r\\n`])+(?:\\|(?:\\\\.|``(?:[^`\\r\\n]|`(?!`))+``|`[^`\\r\\n]+`|[^\\\\|\\r\\n`])+)+\\|?(?:(?:\\n|\\r\\n?)|(?![\\s\\S]))\\|?[ \\t]*:?-{3,}:?[ \\t]*(?:\\|[ \\t]*:?-{3,}:?[ \\t]*)+\\|?(?:\\n|\\r\\n?)(?:\\|?(?:\\\\.|``(?:[^`\\r\\n]|`(?!`))+``|`[^`\\r\\n]+`|[^\\\\|\\r\\n`])+(?:\\|(?:\\\\.|``(?:[^`\\r\\n]|`(?!`))+``|`[^`\\r\\n]+`|[^\\\\|\\r\\n`])+)+\\|?(?:(?:\\n|\\r\\n?)|(?![\\s\\S])))*",
      [
        grammar.rule_with_inside(
          "table-data-rows",
          "^(?<=\\|?(?:\\\\.|``(?:[^`\\r\\n]|`(?!`))+``|`[^`\\r\\n]+`|[^\\\\|\\r\\n`])+(?:\\|(?:\\\\.|``(?:[^`\\r\\n]|`(?!`))+``|`[^`\\r\\n]+`|[^\\\\|\\r\\n`])+)+\\|?(?:(?:\\n|\\r\\n?)|(?![\\s\\S]))\\|?[ \\t]*:?-{3,}:?[ \\t]*(?:\\|[ \\t]*:?-{3,}:?[ \\t]*)+\\|?(?:\\n|\\r\\n?))(?:\\|?(?:\\\\.|``(?:[^`\\r\\n]|`(?!`))+``|`[^`\\r\\n]+`|[^\\\\|\\r\\n`])+(?:\\|(?:\\\\.|``(?:[^`\\r\\n]|`(?!`))+``|`[^`\\r\\n]+`|[^\\\\|\\r\\n`])+)+\\|?(?:(?:\\n|\\r\\n?)|(?![\\s\\S])))*$",
          [
            grammar.rule_with_inside(
              "table-data",
              "(?:\\\\.|``(?:[^`\\r\\n]|`(?!`))+``|`[^`\\r\\n]+`|[^\\\\|\\r\\n`])+",
              [
                grammar.rule(
                  "keyword",
                  "(?<=(?:^|\\n)[ \\t]*\\n|(?:^|\\r\\n?)[ \\t]*\\r\\n?)(?: {4}|\\t).+(?:(?:\\n|\\r\\n?)(?: {4}|\\t).+)*",
                ),
                grammar.greedy_rule_with_inside(
                  "code",
                  "(?m)^```[\\s\\S]*?^```$",
                  [
                    grammar.rule(
                      "code-block",
                      "(?m)^(?<=```.*(?:\\n|\\r\\n?))[\\s\\S]+?(?=(?:\\n|\\r\\n?)^```$)",
                    ),
                    grammar.rule("code-language", "^(?<=```).+"),
                    grammar.rule("punctuation", "```"),
                  ],
                ),
                grammar.rule_with_inside(
                  "important",
                  "(?m)\\S.*(?:\\n|\\r\\n?)(?:==+|--+)(?=[ \\t]*$)",
                  [
                    grammar.rule("punctuation", "==+$|--+$"),
                  ],
                ),
                grammar.rule_with_inside("important", "(?m)(?<=^\\s*)#.+", [
                  grammar.rule("punctuation", "^#+|#+$"),
                ]),
                grammar.rule(
                  "punctuation",
                  "(?m)(?<=^\\s*)([*-])(?:[\\t ]*\\2){2,}(?=\\s*$)",
                ),
                grammar.rule(
                  "punctuation",
                  "(?m)(?<=^\\s*)(?:[*+-]|\\d+\\.)(?=[\\t ].)",
                ),
                grammar.rule_with_inside(
                  "url",
                  "!?\\[[^\\]]+\\]:[\\t ]+(?:\\S+|<(?:\\\\.|[^>\\\\])+>)(?:[\\t ]+(?:\"(?:\\\\.|[^\"\\\\])*\"|'(?:\\\\.|[^'\\\\])*'|\\((?:\\\\.|[^)\\\\])*\\)))?",
                  [
                    grammar.rule("variable", "^(?<=!?\\[)[^\\]]+"),
                    grammar.rule(
                      "string",
                      "(?:\"(?:\\\\.|[^\"\\\\])*\"|'(?:\\\\.|[^'\\\\])*'|\\((?:\\\\.|[^)\\\\])*\\))$",
                    ),
                    grammar.rule("punctuation", "^[\\[\\]!:]|[<>]"),
                  ],
                ),
                grammar.greedy_rule_with_inside(
                  "bold",
                  "(?<=(?:^|[^\\\\])(?:\\\\{2})*)(?:\\b__(?:(?!_)(?:\\\\.|[^\\\\\\n\\r]|(?:\\n|\\r\\n?)(?![\\r\\n]))|_(?:(?!_)(?:\\\\.|[^\\\\\\n\\r]|(?:\\n|\\r\\n?)(?![\\r\\n])))+_)+__\\b|\\*\\*(?:(?!\\*)(?:\\\\.|[^\\\\\\n\\r]|(?:\\n|\\r\\n?)(?![\\r\\n]))|\\*(?:(?!\\*)(?:\\\\.|[^\\\\\\n\\r]|(?:\\n|\\r\\n?)(?![\\r\\n])))+\\*)+\\*\\*)",
                  [
                    grammar.rule_with_inside(
                      "content",
                      "(?<=^..)[\\s\\S]+(?=..$)",
                      [
                        grammar.greedy_rule_with_inside(
                          "url",
                          "(?<=(?:^|[^\\\\])(?:\\\\{2})*)(?:!?\\[(?:(?!\\])(?:\\\\.|[^\\\\\\n\\r]|(?:\\n|\\r\\n?)(?![\\r\\n])))+\\](?:\\([^\\s)]+(?:[\\t ]+\"(?:\\\\.|[^\"\\\\])*\")?\\)|[ \\t]?\\[(?:(?!\\])(?:\\\\.|[^\\\\\\n\\r]|(?:\\n|\\r\\n?)(?![\\r\\n])))+\\]))",
                          [
                            grammar.rule("operator", "^!"),
                            grammar.rule_with_inside(
                              "content",
                              "(?<=^\\[)[^\\]]+(?=\\])",
                              [
                                grammar.greedy_rule_with_inside(
                                  "italic",
                                  "(?<=(?:^|[^\\\\])(?:\\\\{2})*)(?:\\b_(?:(?!_)(?:\\\\.|[^\\\\\\n\\r]|(?:\\n|\\r\\n?)(?![\\r\\n]))|__(?:(?!_)(?:\\\\.|[^\\\\\\n\\r]|(?:\\n|\\r\\n?)(?![\\r\\n])))+__)+_\\b|\\*(?:(?!\\*)(?:\\\\.|[^\\\\\\n\\r]|(?:\\n|\\r\\n?)(?![\\r\\n]))|\\*\\*(?:(?!\\*)(?:\\\\.|[^\\\\\\n\\r]|(?:\\n|\\r\\n?)(?![\\r\\n])))+\\*\\*)+\\*)",
                                  [
                                    grammar.rule_with_inside(
                                      "content",
                                      "(?<=^.)[\\s\\S]+(?=.$)",
                                      [
                                        grammar.greedy_rule_with_inside(
                                          "strike",
                                          "(?<=(?:^|[^\\\\])(?:\\\\{2})*)(?:(~~?)(?:(?!~)(?:\\\\.|[^\\\\\\n\\r]|(?:\\n|\\r\\n?)(?![\\r\\n])))+\\2)",
                                          [
                                            grammar.rule_with_inside(
                                              "content",
                                              "(?<=^~~?)[\\s\\S]+(?=\\1$)",
                                              [
                                                grammar.greedy_rule(
                                                  "code",
                                                  "(?<=^|[^\\\\`])(?:``[^`\\r\\n]+(?:`[^`\\r\\n]+)*``(?!`)|`[^`\\r\\n]+`(?!`))",
                                                ),
                                              ],
                                            ),
                                            grammar.rule("punctuation", "~~?"),
                                          ],
                                        ),
                                      ],
                                    ),
                                    grammar.rule("punctuation", "[*_]"),
                                  ],
                                ),
                              ],
                            ),
                            grammar.rule(
                              "variable",
                              "(?<=^\\][ \\t]?\\[)[^\\]]+(?=\\]$)",
                            ),
                            grammar.rule("url", "(?<=^\\]\\()[^\\s)]+"),
                            grammar.rule(
                              "string",
                              "(?<=^[ \\t]+)\"(?:\\\\.|[^\"\\\\])*\"(?=\\)$)",
                            ),
                          ],
                        ),
                      ],
                    ),
                    grammar.rule("punctuation", "\\*\\*|__"),
                  ],
                ),
                grammar.greedy_rule("prolog", "<\\?[\\s\\S]+?\\?>"),
                grammar.greedy_rule_with_inside(
                  "doctype",
                  "(?i)<!DOCTYPE(?:[^>\"'[\\]]|\"[^\"]*\"|'[^']*')+(?:\\[(?:[^<\"'\\]]|\"[^\"]*\"|'[^']*'|<(?!!--)|<!--(?:[^-]|-(?!->))*-->)*\\]\\s*)?>",
                  [
                    grammar.greedy_rule(
                      "internal-subset",
                      "(?<=^[^\\[]*\\[)[\\s\\S]+(?=\\]>$)",
                    ),
                    grammar.greedy_rule("string", "\"[^\"]*\"|'[^']*'"),
                    grammar.rule("punctuation", "^<!|>$|[[\\]]"),
                    grammar.rule("doctype-tag", "(?i)^DOCTYPE"),
                    grammar.rule("name", "[^\\s<>'\"]+"),
                  ],
                ),
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
                            grammar.rule(
                              "atrule",
                              "@[\\w-](?:[^;{\\s\"']|\\s+(?!\\s)|(?:\"(?:\\\\(?:\\r\\n|[\\s\\S])|[^\"\\\\\\r\\n])*\"|'(?:\\\\(?:\\r\\n|[\\s\\S])|[^'\\\\\\r\\n])*'))*?(?:;|(?=\\s*\\{))",
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
                                grammar.rule(
                                  "interpolation",
                                  "(?<=(?:^|[^\\\\])(?:\\\\{2})*)\\$\\{(?:[^{}]|\\{(?:[^{}]|\\{[^}]*\\})*\\})+\\}",
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
                            grammar.rule(
                              "constant",
                              "\\b[A-Z](?:[A-Z_]|\\dx?)*\\b",
                            ),
                            grammar.rule(
                              "keyword",
                              "(?<=(?:^|\\})\\s*)catch\\b",
                            ),
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
                grammar.greedy_rule(
                  "cdata",
                  "(?i)<!\\[CDATA\\[[\\s\\S]*?\\]\\]>",
                ),
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
            grammar.rule("punctuation", "\\|"),
          ],
        ),
        grammar.rule_with_inside(
          "table-line",
          "^(?<=\\|?(?:\\\\.|``(?:[^`\\r\\n]|`(?!`))+``|`[^`\\r\\n]+`|[^\\\\|\\r\\n`])+(?:\\|(?:\\\\.|``(?:[^`\\r\\n]|`(?!`))+``|`[^`\\r\\n]+`|[^\\\\|\\r\\n`])+)+\\|?(?:(?:\\n|\\r\\n?)|(?![\\s\\S])))\\|?[ \\t]*:?-{3,}:?[ \\t]*(?:\\|[ \\t]*:?-{3,}:?[ \\t]*)+\\|?(?:\\n|\\r\\n?)$",
          [
            grammar.rule("punctuation", "\\||:?-{3,}:?"),
          ],
        ),
        grammar.rule_with_inside(
          "table-header-row",
          "^\\|?(?:\\\\.|``(?:[^`\\r\\n]|`(?!`))+``|`[^`\\r\\n]+`|[^\\\\|\\r\\n`])+(?:\\|(?:\\\\.|``(?:[^`\\r\\n]|`(?!`))+``|`[^`\\r\\n]+`|[^\\\\|\\r\\n`])+)+\\|?(?:(?:\\n|\\r\\n?)|(?![\\s\\S]))$",
          [
            grammar.rule(
              "important",
              "(?:\\\\.|``(?:[^`\\r\\n]|`(?!`))+``|`[^`\\r\\n]+`|[^\\\\|\\r\\n`])+",
            ),
            grammar.rule("punctuation", "\\|"),
          ],
        ),
      ],
    ),
    grammar.rule("entity", "(?i)&#x?[\\da-f]{1,8};"),
  ]
}
