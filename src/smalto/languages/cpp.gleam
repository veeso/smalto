import gleam/option
import smalto/grammar.{type Grammar, type Rule, Grammar}

pub fn grammar() -> Grammar {
  Grammar(name: "cpp", extends: option.Some("c"), rules: rules())
}

fn rules() -> List(Rule) {
  [
    grammar.greedy_rule(
      "comment",
      "\\/\\/(?:[^\\r\\n\\\\]|\\\\(?:\\r\\n?|\\n|(?![\\r\\n])))*|\\/\\*[\\s\\S]*?(?:\\*\\/|$)",
    ),
    grammar.greedy_rule(
      "char",
      "'(?:\\\\(?:\\r\\n|[\\s\\S])|[^'\\\\\\r\\n]){0,32}'",
    ),
    grammar.greedy_rule_with_inside(
      "property",
      "(?im)(?<=^[\\t ]*)#\\s*[a-z](?:[^\\r\\n\\\\/]|\\/(?!\\*)|\\/\\*(?:[^*]|\\*(?!\\/))*\\*\\/|\\\\(?:\\r\\n|[\\s\\S]))*",
      [
        grammar.rule("string", "^(?<=#\\s*include\\s*)<[^>]+>"),
        grammar.greedy_rule(
          "string",
          "\"(?:\\\\(?:\\r\\n|[\\s\\S])|[^\"\\\\\\r\\n])*\"",
        ),
        grammar.rule("macro-name", "(?i)(?<=^#\\s*define\\s+)\\w+\\b(?!\\()"),
        grammar.rule("function", "(?i)(?<=^#\\s*define\\s+)\\w+\\b(?=\\()"),
        grammar.rule("keyword", "^(?<=#\\s*)[a-z]+"),
        grammar.rule("directive-hash", "^#"),
        grammar.rule("punctuation", "##|\\\\(?=[\\r\\n])"),
        grammar.rule_with_inside("expression", "\\S[\\s\\S]*", [
          grammar.greedy_rule_with_inside(
            "module",
            "(?<=\\b(?:import|module)\\s+)(?:\"(?:\\\\(?:\\r\\n|[\\s\\S])|[^\"\\\\\\r\\n])*\"|<[^<>\\r\\n]*>|\\b(?!\\b(?:alignas|alignof|asm|auto|bool|break|case|catch|char|char16_t|char32_t|char8_t|class|co_await|co_return|co_yield|compl|concept|const|const_cast|consteval|constexpr|constinit|continue|decltype|default|delete|do|double|dynamic_cast|else|enum|explicit|export|extern|final|float|for|friend|goto|if|import|inline|int|int16_t|int32_t|int64_t|int8_t|long|module|mutable|namespace|new|noexcept|nullptr|operator|override|private|protected|public|register|reinterpret_cast|requires|return|short|signed|sizeof|static|static_assert|static_cast|struct|switch|template|this|thread_local|throw|try|typedef|typeid|typename|uint16_t|uint32_t|uint64_t|uint8_t|union|unsigned|using|virtual|void|volatile|wchar_t|while)\\b)\\w+(?:\\s*\\.\\s*\\w+)*\\b(?:\\s*:\\s*\\b(?!\\b(?:alignas|alignof|asm|auto|bool|break|case|catch|char|char16_t|char32_t|char8_t|class|co_await|co_return|co_yield|compl|concept|const|const_cast|consteval|constexpr|constinit|continue|decltype|default|delete|do|double|dynamic_cast|else|enum|explicit|export|extern|final|float|for|friend|goto|if|import|inline|int|int16_t|int32_t|int64_t|int8_t|long|module|mutable|namespace|new|noexcept|nullptr|operator|override|private|protected|public|register|reinterpret_cast|requires|return|short|signed|sizeof|static|static_assert|static_cast|struct|switch|template|this|thread_local|throw|try|typedef|typeid|typename|uint16_t|uint32_t|uint64_t|uint8_t|union|unsigned|using|virtual|void|volatile|wchar_t|while)\\b)\\w+(?:\\s*\\.\\s*\\w+)*\\b)?|:\\s*\\b(?!\\b(?:alignas|alignof|asm|auto|bool|break|case|catch|char|char16_t|char32_t|char8_t|class|co_await|co_return|co_yield|compl|concept|const|const_cast|consteval|constexpr|constinit|continue|decltype|default|delete|do|double|dynamic_cast|else|enum|explicit|export|extern|final|float|for|friend|goto|if|import|inline|int|int16_t|int32_t|int64_t|int8_t|long|module|mutable|namespace|new|noexcept|nullptr|operator|override|private|protected|public|register|reinterpret_cast|requires|return|short|signed|sizeof|static|static_assert|static_cast|struct|switch|template|this|thread_local|throw|try|typedef|typeid|typename|uint16_t|uint32_t|uint64_t|uint8_t|union|unsigned|using|virtual|void|volatile|wchar_t|while)\\b)\\w+(?:\\s*\\.\\s*\\w+)*\\b)",
            [
              grammar.rule("string", "^[<\"][\\s\\S]+"),
              grammar.rule("operator", ":"),
              grammar.rule("punctuation", "\\."),
            ],
          ),
          grammar.greedy_rule(
            "string",
            "R\"([^()\\\\ ]{0,16})\\([\\s\\S]*?\\)\\1\"",
          ),
          grammar.greedy_rule_with_inside(
            "base-clause",
            "(?<=\\b(?:class|struct)\\s+\\w+\\s*:\\s*)[^;{}\"'\\s]+(?:\\s+[^;{}\"'\\s]+)*(?=\\s*[;{])",
            [
              grammar.greedy_rule(
                "comment",
                "\\/\\/(?:[^\\r\\n\\\\]|\\\\(?:\\r\\n?|\\n|(?![\\r\\n])))*|\\/\\*[\\s\\S]*?(?:\\*\\/|$)",
              ),
              grammar.greedy_rule(
                "char",
                "'(?:\\\\(?:\\r\\n|[\\s\\S])|[^'\\\\\\r\\n]){0,32}'",
              ),
              grammar.greedy_rule_with_inside(
                "property",
                "(?im)(?<=^[\\t ]*)#\\s*[a-z](?:[^\\r\\n\\\\/]|\\/(?!\\*)|\\/\\*(?:[^*]|\\*(?!\\/))*\\*\\/|\\\\(?:\\r\\n|[\\s\\S]))*",
                [
                  grammar.rule("string", "^(?<=#\\s*include\\s*)<[^>]+>"),
                  grammar.greedy_rule(
                    "string",
                    "\"(?:\\\\(?:\\r\\n|[\\s\\S])|[^\"\\\\\\r\\n])*\"",
                  ),
                  grammar.rule(
                    "macro-name",
                    "(?i)(?<=^#\\s*define\\s+)\\w+\\b(?!\\()",
                  ),
                  grammar.rule(
                    "function",
                    "(?i)(?<=^#\\s*define\\s+)\\w+\\b(?=\\()",
                  ),
                  grammar.rule("keyword", "^(?<=#\\s*)[a-z]+"),
                  grammar.rule("directive-hash", "^#"),
                  grammar.rule("punctuation", "##|\\\\(?=[\\r\\n])"),
                  grammar.rule_with_inside("expression", "\\S[\\s\\S]*", [
                    grammar.greedy_rule_with_inside(
                      "module",
                      "(?<=\\b(?:import|module)\\s+)(?:\"(?:\\\\(?:\\r\\n|[\\s\\S])|[^\"\\\\\\r\\n])*\"|<[^<>\\r\\n]*>|\\b(?!\\b(?:alignas|alignof|asm|auto|bool|break|case|catch|char|char16_t|char32_t|char8_t|class|co_await|co_return|co_yield|compl|concept|const|const_cast|consteval|constexpr|constinit|continue|decltype|default|delete|do|double|dynamic_cast|else|enum|explicit|export|extern|final|float|for|friend|goto|if|import|inline|int|int16_t|int32_t|int64_t|int8_t|long|module|mutable|namespace|new|noexcept|nullptr|operator|override|private|protected|public|register|reinterpret_cast|requires|return|short|signed|sizeof|static|static_assert|static_cast|struct|switch|template|this|thread_local|throw|try|typedef|typeid|typename|uint16_t|uint32_t|uint64_t|uint8_t|union|unsigned|using|virtual|void|volatile|wchar_t|while)\\b)\\w+(?:\\s*\\.\\s*\\w+)*\\b(?:\\s*:\\s*\\b(?!\\b(?:alignas|alignof|asm|auto|bool|break|case|catch|char|char16_t|char32_t|char8_t|class|co_await|co_return|co_yield|compl|concept|const|const_cast|consteval|constexpr|constinit|continue|decltype|default|delete|do|double|dynamic_cast|else|enum|explicit|export|extern|final|float|for|friend|goto|if|import|inline|int|int16_t|int32_t|int64_t|int8_t|long|module|mutable|namespace|new|noexcept|nullptr|operator|override|private|protected|public|register|reinterpret_cast|requires|return|short|signed|sizeof|static|static_assert|static_cast|struct|switch|template|this|thread_local|throw|try|typedef|typeid|typename|uint16_t|uint32_t|uint64_t|uint8_t|union|unsigned|using|virtual|void|volatile|wchar_t|while)\\b)\\w+(?:\\s*\\.\\s*\\w+)*\\b)?|:\\s*\\b(?!\\b(?:alignas|alignof|asm|auto|bool|break|case|catch|char|char16_t|char32_t|char8_t|class|co_await|co_return|co_yield|compl|concept|const|const_cast|consteval|constexpr|constinit|continue|decltype|default|delete|do|double|dynamic_cast|else|enum|explicit|export|extern|final|float|for|friend|goto|if|import|inline|int|int16_t|int32_t|int64_t|int8_t|long|module|mutable|namespace|new|noexcept|nullptr|operator|override|private|protected|public|register|reinterpret_cast|requires|return|short|signed|sizeof|static|static_assert|static_cast|struct|switch|template|this|thread_local|throw|try|typedef|typeid|typename|uint16_t|uint32_t|uint64_t|uint8_t|union|unsigned|using|virtual|void|volatile|wchar_t|while)\\b)\\w+(?:\\s*\\.\\s*\\w+)*\\b)",
                      [
                        grammar.rule("string", "^[<\"][\\s\\S]+"),
                        grammar.rule("operator", ":"),
                        grammar.rule("punctuation", "\\."),
                      ],
                    ),
                    grammar.greedy_rule(
                      "string",
                      "R\"([^()\\\\ ]{0,16})\\([\\s\\S]*?\\)\\1\"",
                    ),
                    grammar.rule(
                      "class-name",
                      "(?<=\\b(?:class|concept|enum|struct|typename)\\s+)(?!\\b(?:alignas|alignof|asm|auto|bool|break|case|catch|char|char16_t|char32_t|char8_t|class|co_await|co_return|co_yield|compl|concept|const|const_cast|consteval|constexpr|constinit|continue|decltype|default|delete|do|double|dynamic_cast|else|enum|explicit|export|extern|final|float|for|friend|goto|if|import|inline|int|int16_t|int32_t|int64_t|int8_t|long|module|mutable|namespace|new|noexcept|nullptr|operator|override|private|protected|public|register|reinterpret_cast|requires|return|short|signed|sizeof|static|static_assert|static_cast|struct|switch|template|this|thread_local|throw|try|typedef|typeid|typename|uint16_t|uint32_t|uint64_t|uint8_t|union|unsigned|using|virtual|void|volatile|wchar_t|while)\\b)\\w+",
                    ),
                    grammar.rule(
                      "class-name",
                      "\\b[A-Z]\\w*(?=\\s*::\\s*\\w+\\s*\\()",
                    ),
                    grammar.rule(
                      "class-name",
                      "(?i)\\b[A-Z_]\\w*(?=\\s*::\\s*~\\w+\\s*\\()",
                    ),
                    grammar.rule(
                      "class-name",
                      "\\b\\w+(?=\\s*<(?:[^<>]|<(?:[^<>]|<[^<>]*>)*>)*>\\s*::\\s*\\w+\\s*\\()",
                    ),
                    grammar.rule_with_inside(
                      "generic-function",
                      "(?i)\\b(?!operator\\b)[a-z_]\\w*\\s*<(?:[^<>]|<[^<>]*>)*>(?=\\s*\\()",
                      [
                        grammar.rule("function", "^\\w+"),
                        grammar.rule("class-name", "<[\\s\\S]+"),
                      ],
                    ),
                    grammar.rule(
                      "keyword",
                      "\\b(?:alignas|alignof|asm|auto|bool|break|case|catch|char|char16_t|char32_t|char8_t|class|co_await|co_return|co_yield|compl|concept|const|const_cast|consteval|constexpr|constinit|continue|decltype|default|delete|do|double|dynamic_cast|else|enum|explicit|export|extern|final|float|for|friend|goto|if|import|inline|int|int16_t|int32_t|int64_t|int8_t|long|module|mutable|namespace|new|noexcept|nullptr|operator|override|private|protected|public|register|reinterpret_cast|requires|return|short|signed|sizeof|static|static_assert|static_cast|struct|switch|template|this|thread_local|throw|try|typedef|typeid|typename|uint16_t|uint32_t|uint64_t|uint8_t|union|unsigned|using|virtual|void|volatile|wchar_t|while)\\b",
                    ),
                    grammar.rule(
                      "constant",
                      "\\b(?:EOF|NULL|SEEK_CUR|SEEK_END|SEEK_SET|__DATE__|__FILE__|__LINE__|__TIMESTAMP__|__TIME__|__func__|stderr|stdin|stdout)\\b",
                    ),
                    grammar.rule("function", "(?i)\\b[a-z_]\\w*(?=\\s*\\()"),
                    grammar.greedy_rule(
                      "number",
                      "(?i)(?:\\b0b[01']+|\\b0x(?:[\\da-f']+(?:\\.[\\da-f']*)?|\\.[\\da-f']+)(?:p[+-]?[\\d']+)?|(?:\\b[\\d']+(?:\\.[\\d']*)?|\\B\\.[\\d']+)(?:e[+-]?[\\d']+)?)[ful]{0,4}",
                    ),
                    grammar.rule("punctuation", "::"),
                    grammar.rule(
                      "operator",
                      ">>=?|<<=?|->|--|\\+\\+|&&|\\|\\||[?:~]|<=>|[-+*/%&|^!=<>]=?|\\b(?:and|and_eq|bitand|bitor|not|not_eq|or|or_eq|xor|xor_eq)\\b",
                    ),
                    grammar.rule("punctuation", "[{}[\\];(),.:]"),
                    grammar.rule("boolean", "\\b(?:false|true)\\b"),
                  ]),
                ],
              ),
              grammar.rule(
                "keyword",
                "\\b(?:alignas|alignof|asm|auto|bool|break|case|catch|char|char16_t|char32_t|char8_t|class|co_await|co_return|co_yield|compl|concept|const|const_cast|consteval|constexpr|constinit|continue|decltype|default|delete|do|double|dynamic_cast|else|enum|explicit|export|extern|final|float|for|friend|goto|if|import|inline|int|int16_t|int32_t|int64_t|int8_t|long|module|mutable|namespace|new|noexcept|nullptr|operator|override|private|protected|public|register|reinterpret_cast|requires|return|short|signed|sizeof|static|static_assert|static_cast|struct|switch|template|this|thread_local|throw|try|typedef|typeid|typename|uint16_t|uint32_t|uint64_t|uint8_t|union|unsigned|using|virtual|void|volatile|wchar_t|while)\\b",
              ),
              grammar.rule(
                "constant",
                "\\b(?:EOF|NULL|SEEK_CUR|SEEK_END|SEEK_SET|__DATE__|__FILE__|__LINE__|__TIMESTAMP__|__TIME__|__func__|stderr|stdin|stdout)\\b",
              ),
              grammar.rule("function", "(?i)\\b[a-z_]\\w*(?=\\s*\\()"),
              grammar.rule("class-name", "(?i)\\b[a-z_]\\w*\\b(?!\\s*::)"),
              grammar.rule(
                "operator",
                ">>=?|<<=?|->|--|\\+\\+|&&|\\|\\||[?:~]|<=>|[-+*/%&|^!=<>]=?|\\b(?:and|and_eq|bitand|bitor|not|not_eq|or|or_eq|xor|xor_eq)\\b",
              ),
              grammar.rule("punctuation", "[{}[\\];(),.:]"),
              grammar.rule("boolean", "\\b(?:false|true)\\b"),
            ],
          ),
          grammar.rule(
            "class-name",
            "(?<=\\b(?:class|concept|enum|struct|typename)\\s+)(?!\\b(?:alignas|alignof|asm|auto|bool|break|case|catch|char|char16_t|char32_t|char8_t|class|co_await|co_return|co_yield|compl|concept|const|const_cast|consteval|constexpr|constinit|continue|decltype|default|delete|do|double|dynamic_cast|else|enum|explicit|export|extern|final|float|for|friend|goto|if|import|inline|int|int16_t|int32_t|int64_t|int8_t|long|module|mutable|namespace|new|noexcept|nullptr|operator|override|private|protected|public|register|reinterpret_cast|requires|return|short|signed|sizeof|static|static_assert|static_cast|struct|switch|template|this|thread_local|throw|try|typedef|typeid|typename|uint16_t|uint32_t|uint64_t|uint8_t|union|unsigned|using|virtual|void|volatile|wchar_t|while)\\b)\\w+",
          ),
          grammar.rule("class-name", "\\b[A-Z]\\w*(?=\\s*::\\s*\\w+\\s*\\()"),
          grammar.rule(
            "class-name",
            "(?i)\\b[A-Z_]\\w*(?=\\s*::\\s*~\\w+\\s*\\()",
          ),
          grammar.rule(
            "class-name",
            "\\b\\w+(?=\\s*<(?:[^<>]|<(?:[^<>]|<[^<>]*>)*>)*>\\s*::\\s*\\w+\\s*\\()",
          ),
          grammar.rule_with_inside(
            "generic-function",
            "(?i)\\b(?!operator\\b)[a-z_]\\w*\\s*<(?:[^<>]|<[^<>]*>)*>(?=\\s*\\()",
            [
              grammar.rule("function", "^\\w+"),
              grammar.rule("class-name", "<[\\s\\S]+"),
            ],
          ),
          grammar.rule(
            "keyword",
            "\\b(?:alignas|alignof|asm|auto|bool|break|case|catch|char|char16_t|char32_t|char8_t|class|co_await|co_return|co_yield|compl|concept|const|const_cast|consteval|constexpr|constinit|continue|decltype|default|delete|do|double|dynamic_cast|else|enum|explicit|export|extern|final|float|for|friend|goto|if|import|inline|int|int16_t|int32_t|int64_t|int8_t|long|module|mutable|namespace|new|noexcept|nullptr|operator|override|private|protected|public|register|reinterpret_cast|requires|return|short|signed|sizeof|static|static_assert|static_cast|struct|switch|template|this|thread_local|throw|try|typedef|typeid|typename|uint16_t|uint32_t|uint64_t|uint8_t|union|unsigned|using|virtual|void|volatile|wchar_t|while)\\b",
          ),
          grammar.rule(
            "constant",
            "\\b(?:EOF|NULL|SEEK_CUR|SEEK_END|SEEK_SET|__DATE__|__FILE__|__LINE__|__TIMESTAMP__|__TIME__|__func__|stderr|stdin|stdout)\\b",
          ),
          grammar.rule("function", "(?i)\\b[a-z_]\\w*(?=\\s*\\()"),
          grammar.greedy_rule(
            "number",
            "(?i)(?:\\b0b[01']+|\\b0x(?:[\\da-f']+(?:\\.[\\da-f']*)?|\\.[\\da-f']+)(?:p[+-]?[\\d']+)?|(?:\\b[\\d']+(?:\\.[\\d']*)?|\\B\\.[\\d']+)(?:e[+-]?[\\d']+)?)[ful]{0,4}",
          ),
          grammar.rule("punctuation", "::"),
          grammar.rule(
            "operator",
            ">>=?|<<=?|->|--|\\+\\+|&&|\\|\\||[?:~]|<=>|[-+*/%&|^!=<>]=?|\\b(?:and|and_eq|bitand|bitor|not|not_eq|or|or_eq|xor|xor_eq)\\b",
          ),
          grammar.rule("punctuation", "[{}[\\];(),.:]"),
          grammar.rule("boolean", "\\b(?:false|true)\\b"),
        ]),
      ],
    ),
    grammar.rule("class-name", "\\b[A-Z]\\w*(?=\\s*::\\s*\\w+\\s*\\()"),
    grammar.rule("class-name", "(?i)\\b[A-Z_]\\w*(?=\\s*::\\s*~\\w+\\s*\\()"),
    grammar.rule(
      "class-name",
      "\\b\\w+(?=\\s*<(?:[^<>]|<(?:[^<>]|<[^<>]*>)*>)*>\\s*::\\s*\\w+\\s*\\()",
    ),
    grammar.rule(
      "keyword",
      "\\b(?:alignas|alignof|asm|auto|bool|break|case|catch|char|char16_t|char32_t|char8_t|class|co_await|co_return|co_yield|compl|concept|const|const_cast|consteval|constexpr|constinit|continue|decltype|default|delete|do|double|dynamic_cast|else|enum|explicit|export|extern|final|float|for|friend|goto|if|import|inline|int|int16_t|int32_t|int64_t|int8_t|long|module|mutable|namespace|new|noexcept|nullptr|operator|override|private|protected|public|register|reinterpret_cast|requires|return|short|signed|sizeof|static|static_assert|static_cast|struct|switch|template|this|thread_local|throw|try|typedef|typeid|typename|uint16_t|uint32_t|uint64_t|uint8_t|union|unsigned|using|virtual|void|volatile|wchar_t|while)\\b",
    ),
    grammar.rule(
      "constant",
      "\\b(?:EOF|NULL|SEEK_CUR|SEEK_END|SEEK_SET|__DATE__|__FILE__|__LINE__|__TIMESTAMP__|__TIME__|__func__|stderr|stdin|stdout)\\b",
    ),
    grammar.rule("function", "(?i)\\b[a-z_]\\w*(?=\\s*\\()"),
    grammar.rule(
      "operator",
      ">>=?|<<=?|->|--|\\+\\+|&&|\\|\\||[?:~]|<=>|[-+*/%&|^!=<>]=?|\\b(?:and|and_eq|bitand|bitor|not|not_eq|or|or_eq|xor|xor_eq)\\b",
    ),
    grammar.rule("punctuation", "[{}[\\];(),.:]"),
    grammar.rule("boolean", "\\b(?:false|true)\\b"),
  ]
}
