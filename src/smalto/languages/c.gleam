import gleam/option
import smalto/grammar.{type Grammar, type Rule, Grammar}

pub fn grammar() -> Grammar {
  Grammar(name: "c", extends: option.Some("clike"), rules: rules())
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
      "(?im)(?:^[\\t ]*)\\K#\\s*[a-z](?:[^\\r\\n\\\\/]|\\/(?!\\*)|\\/\\*(?:[^*]|\\*(?!\\/))*\\*\\/|\\\\(?:\\r\\n|[\\s\\S]))*",
      [
        grammar.rule("string", "^(?:#\\s*include\\s*)\\K<[^>]+>"),
        grammar.greedy_rule(
          "string",
          "\"(?:\\\\(?:\\r\\n|[\\s\\S])|[^\"\\\\\\r\\n])*\"",
        ),
        grammar.greedy_rule(
          "char",
          "'(?:\\\\(?:\\r\\n|[\\s\\S])|[^'\\\\\\r\\n]){0,32}'",
        ),
        grammar.greedy_rule(
          "comment",
          "\\/\\/(?:[^\\r\\n\\\\]|\\\\(?:\\r\\n?|\\n|(?![\\r\\n])))*|\\/\\*[\\s\\S]*?(?:\\*\\/|$)",
        ),
        grammar.rule("macro-name", "(?i)(?:^#\\s*define\\s+)\\K\\w+\\b(?!\\()"),
        grammar.rule("function", "(?i)(?:^#\\s*define\\s+)\\K\\w+\\b(?=\\()"),
        grammar.rule("keyword", "^(?:#\\s*)\\K[a-z]+"),
        grammar.rule("directive-hash", "^#"),
        grammar.rule("punctuation", "##|\\\\(?=[\\r\\n])"),
        grammar.rule_with_inside("expression", "\\S[\\s\\S]*", [
          grammar.greedy_rule(
            "comment",
            "\\/\\/(?:[^\\r\\n\\\\]|\\\\(?:\\r\\n?|\\n|(?![\\r\\n])))*|\\/\\*[\\s\\S]*?(?:\\*\\/|$)",
          ),
          grammar.greedy_rule(
            "char",
            "'(?:\\\\(?:\\r\\n|[\\s\\S])|[^'\\\\\\r\\n]){0,32}'",
          ),
          grammar.greedy_rule(
            "property",
            "(?im)(?:^[\\t ]*)\\K#\\s*[a-z](?:[^\\r\\n\\\\/]|\\/(?!\\*)|\\/\\*(?:[^*]|\\*(?!\\/))*\\*\\/|\\\\(?:\\r\\n|[\\s\\S]))*",
          ),
          grammar.greedy_rule(
            "string",
            "\"(?:\\\\(?:\\r\\n|[\\s\\S])|[^\"\\\\\\r\\n])*\"",
          ),
          grammar.rule(
            "class-name",
            "(?:\\b(?:enum|struct)\\s+(?:__attribute__\\s*\\(\\([\\s\\S]*?\\)\\)\\s*)?)\\K\\w+|\\b[a-z]\\w*_t\\b",
          ),
          grammar.rule(
            "keyword",
            "\\b(?:_Alignas|_Alignof|_Atomic|_Bool|_Complex|_Generic|_Imaginary|_Noreturn|_Static_assert|_Thread_local|__attribute__|asm|auto|break|case|char|const|continue|default|do|double|else|enum|extern|float|for|goto|if|inline|int|long|register|return|short|signed|sizeof|static|struct|switch|typedef|typeof|union|unsigned|void|volatile|while)\\b",
          ),
          grammar.rule(
            "constant",
            "\\b(?:EOF|NULL|SEEK_CUR|SEEK_END|SEEK_SET|__DATE__|__FILE__|__LINE__|__TIMESTAMP__|__TIME__|__func__|stderr|stdin|stdout)\\b",
          ),
          grammar.rule("function", "(?i)\\b[a-z_]\\w*(?=\\s*\\()"),
          grammar.rule(
            "number",
            "(?i)(?:\\b0x(?:[\\da-f]+(?:\\.[\\da-f]*)?|\\.[\\da-f]+)(?:p[+-]?\\d+)?|(?:\\b\\d+(?:\\.\\d*)?|\\B\\.\\d+)(?:e[+-]?\\d+)?)[ful]{0,4}",
          ),
          grammar.rule(
            "operator",
            ">>=?|<<=?|->|([-+&|:])\\1|[?:~]|[-+*/%&|^!=<>]=?",
          ),
          grammar.rule("punctuation", "[{}[\\];(),.:]"),
        ]),
      ],
    ),
    grammar.greedy_rule(
      "string",
      "\"(?:\\\\(?:\\r\\n|[\\s\\S])|[^\"\\\\\\r\\n])*\"",
    ),
    grammar.rule(
      "class-name",
      "(?:\\b(?:enum|struct)\\s+(?:__attribute__\\s*\\(\\([\\s\\S]*?\\)\\)\\s*)?)\\K\\w+|\\b[a-z]\\w*_t\\b",
    ),
    grammar.rule(
      "keyword",
      "\\b(?:_Alignas|_Alignof|_Atomic|_Bool|_Complex|_Generic|_Imaginary|_Noreturn|_Static_assert|_Thread_local|__attribute__|asm|auto|break|case|char|const|continue|default|do|double|else|enum|extern|float|for|goto|if|inline|int|long|register|return|short|signed|sizeof|static|struct|switch|typedef|typeof|union|unsigned|void|volatile|while)\\b",
    ),
    grammar.rule(
      "constant",
      "\\b(?:EOF|NULL|SEEK_CUR|SEEK_END|SEEK_SET|__DATE__|__FILE__|__LINE__|__TIMESTAMP__|__TIME__|__func__|stderr|stdin|stdout)\\b",
    ),
    grammar.rule("function", "(?i)\\b[a-z_]\\w*(?=\\s*\\()"),
    grammar.rule(
      "number",
      "(?i)(?:\\b0x(?:[\\da-f]+(?:\\.[\\da-f]*)?|\\.[\\da-f]+)(?:p[+-]?\\d+)?|(?:\\b\\d+(?:\\.\\d*)?|\\B\\.\\d+)(?:e[+-]?\\d+)?)[ful]{0,4}",
    ),
    grammar.rule("operator", ">>=?|<<=?|->|([-+&|:])\\1|[?:~]|[-+*/%&|^!=<>]=?"),
    grammar.rule("punctuation", "[{}[\\];(),.:]"),
  ]
}
