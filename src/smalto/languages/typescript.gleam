import gleam/option
import smalto/grammar.{type Grammar, type Rule, Grammar}

pub fn grammar() -> Grammar {
  Grammar(
    name: "typescript",
    extends: option.Some("javascript"),
    rules: rules(),
  )
}

fn rules() -> List(Rule) {
  [
    grammar.greedy_rule(
      "comment",
      "(?:^|[^\\\\])\\K\\/\\*[\\s\\S]*?(?:\\*\\/|$)",
    ),
    grammar.greedy_rule("comment", "(?:^|[^\\\\:])\\K\\/\\/.*"),
    grammar.greedy_rule("comment", "^#!.*"),
    grammar.greedy_rule_with_inside(
      "template-string",
      "`(?:\\\\[\\s\\S]|\\$\\{(?:[^{}]|\\{(?:[^{}]|\\{[^}]*\\})*\\})+\\}|(?!\\$\\{)[^\\\\`])*`",
      [
        grammar.rule("string", "^`|`$"),
        grammar.nested_rule(
          "interpolation",
          "(?:(?:^|[^\\\\])(?:\\\\{2})*)\\K\\$\\{(?:[^{}]|\\{(?:[^{}]|\\{[^}]*\\})*\\})+\\}",
          "typescript",
        ),
        grammar.rule("string", "[\\s\\S]+"),
      ],
    ),
    grammar.greedy_rule(
      "property",
      "(?m)(?:(?:^|[,{])[ \\t]*)\\K([\"'])(?:\\\\(?:\\r\\n|[\\s\\S])|(?!\\2)[^\\\\\\r\\n])*\\2(?=\\s*:)",
    ),
    grammar.greedy_rule(
      "string",
      "([\"'])(?:\\\\(?:\\r\\n|[\\s\\S])|(?!\\1)[^\\\\\\r\\n])*\\1",
    ),
    grammar.greedy_rule_with_inside(
      "class-name",
      "(?:\\b(?:class|extends|implements|instanceof|interface|new|type)\\s+)\\K(?!keyof\\b)(?!\\s)[_$a-zA-Z\\xA0-\\x{FFFF}](?:(?!\\s)[$\\w\\xA0-\\x{FFFF}])*(?:\\s*<(?:[^<>]|<(?:[^<>]|<[^<>]*>)*>)*>)?",
      [
        grammar.greedy_rule(
          "comment",
          "(?:^|[^\\\\])\\K\\/\\*[\\s\\S]*?(?:\\*\\/|$)",
        ),
        grammar.greedy_rule("comment", "(?:^|[^\\\\:])\\K\\/\\/.*"),
        grammar.greedy_rule("comment", "^#!.*"),
        grammar.greedy_rule_with_inside(
          "template-string",
          "`(?:\\\\[\\s\\S]|\\$\\{(?:[^{}]|\\{(?:[^{}]|\\{[^}]*\\})*\\})+\\}|(?!\\$\\{)[^\\\\`])*`",
          [
            grammar.rule("string", "^`|`$"),
            grammar.rule(
              "interpolation",
              "(?:(?:^|[^\\\\])(?:\\\\{2})*)\\K\\$\\{(?:[^{}]|\\{(?:[^{}]|\\{[^}]*\\})*\\})+\\}",
            ),
            grammar.rule("string", "[\\s\\S]+"),
          ],
        ),
        grammar.greedy_rule(
          "property",
          "(?m)(?:(?:^|[,{])[ \\t]*)\\K([\"'])(?:\\\\(?:\\r\\n|[\\s\\S])|(?!\\2)[^\\\\\\r\\n])*\\2(?=\\s*:)",
        ),
        grammar.greedy_rule(
          "string",
          "([\"'])(?:\\\\(?:\\r\\n|[\\s\\S])|(?!\\1)[^\\\\\\r\\n])*\\1",
        ),
        grammar.greedy_rule_with_inside(
          "regex",
          "(?:(?:^|[^$\\w\\xA0-\\x{FFFF}.\"'\\])\\s]|\\b(?:return|yield))\\s*)\\K\\/(?:(?:\\[(?:[^\\]\\\\\\r\\n]|\\\\.)*\\]|\\\\.|[^/\\\\\\[\\r\\n])+\\/[dgimyus]{0,7}|(?:\\[(?:[^[\\]\\\\\\r\\n]|\\\\.|\\[(?:[^[\\]\\\\\\r\\n]|\\\\.|\\[(?:[^[\\]\\\\\\r\\n]|\\\\.)*\\])*\\])*\\]|\\\\.|[^/\\\\\\[\\r\\n])+\\/[dgimyus]{0,7}v[dgimyus]{0,7})(?=(?:\\s|\\/\\*(?:[^*]|\\*(?!\\/))*\\*\\/)*(?:$|[\\r\\n,.;:})\\]]|\\/\\/))",
          [
            grammar.rule("language-regex", "^(?<=\\/)[\\s\\S]+(?=\\/[a-z]*$)"),
            grammar.rule("regex-delimiter", "^\\/|\\/$"),
            grammar.rule("regex-flags", "^[a-z]+$"),
          ],
        ),
        grammar.rule(
          "function",
          "#?(?!\\s)[_$a-zA-Z\\xA0-\\x{FFFF}](?:(?!\\s)[$\\w\\xA0-\\x{FFFF}])*(?=\\s*[=:]\\s*(?:async\\s*)?(?:\\bfunction\\b|(?:\\((?:[^()]|\\([^()]*\\))*\\)|(?!\\s)[_$a-zA-Z\\xA0-\\x{FFFF}](?:(?!\\s)[$\\w\\xA0-\\x{FFFF}])*)\\s*=>))",
        ),
        grammar.rule("constant", "\\b[A-Z](?:[A-Z_]|\\dx?)*\\b"),
        grammar.rule("keyword", "(?:(?:^|\\})\\s*)\\Kcatch\\b"),
        grammar.rule(
          "keyword",
          "(?:^|[^.]|\\.\\.\\.\\s*)\\K\\b(?:as|assert(?=\\s*\\{)|async(?=\\s*(?:function\\b|\\(|[$\\w\\xA0-\\x{FFFF}]|$))|await|break|case|class|const|continue|debugger|default|delete|do|else|enum|export|extends|finally(?=\\s*(?:\\{|$))|for|from(?=\\s*(?:['\"]|$))|function|(?:get|set)(?=\\s*(?:[#\\[$\\w\\xA0-\\x{FFFF}]|$))|if|implements|import|in|instanceof|interface|let|new|null|of|package|private|protected|public|return|static|super|switch|this|throw|try|typeof|undefined|var|void|while|with|yield)\\b",
        ),
        grammar.rule(
          "keyword",
          "\\b(?:abstract|declare|is|keyof|readonly|require)\\b",
        ),
        grammar.rule(
          "keyword",
          "\\b(?:asserts|infer|interface|module|namespace|type)\\b(?=\\s*(?:[{_$a-zA-Z\\xA0-\\x{FFFF}]|$))",
        ),
        grammar.rule("keyword", "\\btype\\b(?=\\s*(?:[\\{*]|$))"),
        grammar.rule("boolean", "\\b(?:false|true)\\b"),
        grammar.rule(
          "function",
          "#?(?!\\s)[_$a-zA-Z\\xA0-\\x{FFFF}](?:(?!\\s)[$\\w\\xA0-\\x{FFFF}])*(?=\\s*(?:\\.\\s*(?:apply|bind|call)\\s*)?\\()",
        ),
        grammar.rule(
          "number",
          "(?:^|[^\\w$])\\K(?:NaN|Infinity|0[bB][01]+(?:_[01]+)*n?|0[oO][0-7]+(?:_[0-7]+)*n?|0[xX][\\dA-Fa-f]+(?:_[\\dA-Fa-f]+)*n?|\\d+(?:_\\d+)*n|(?:\\d+(?:_\\d+)*(?:\\.(?:\\d+(?:_\\d+)*)?)?|\\.\\d+(?:_\\d+)*)(?:[Ee][+-]?\\d+(?:_\\d+)*)?)(?![\\w$])",
        ),
        grammar.rule(
          "operator",
          "--|\\+\\+|\\*\\*=?|=>|&&=?|\\|\\|=?|[!=]==|<<=?|>>>?=?|[-+*/%&|^!=<>]=?|\\.{3}|\\?\\?=?|\\?\\.?|[~:]",
        ),
        grammar.rule("punctuation", "[{}[\\];(),.:]"),
        grammar.rule(
          "builtin",
          "\\b(?:Array|Function|Promise|any|boolean|console|never|number|string|symbol|unknown)\\b",
        ),
      ],
    ),
    grammar.greedy_rule_with_inside(
      "regex",
      "(?:(?:^|[^$\\w\\xA0-\\x{FFFF}.\"'\\])\\s]|\\b(?:return|yield))\\s*)\\K\\/(?:(?:\\[(?:[^\\]\\\\\\r\\n]|\\\\.)*\\]|\\\\.|[^/\\\\\\[\\r\\n])+\\/[dgimyus]{0,7}|(?:\\[(?:[^[\\]\\\\\\r\\n]|\\\\.|\\[(?:[^[\\]\\\\\\r\\n]|\\\\.|\\[(?:[^[\\]\\\\\\r\\n]|\\\\.)*\\])*\\])*\\]|\\\\.|[^/\\\\\\[\\r\\n])+\\/[dgimyus]{0,7}v[dgimyus]{0,7})(?=(?:\\s|\\/\\*(?:[^*]|\\*(?!\\/))*\\*\\/)*(?:$|[\\r\\n,.;:})\\]]|\\/\\/))",
      [
        grammar.rule("language-regex", "^(?<=\\/)[\\s\\S]+(?=\\/[a-z]*$)"),
        grammar.rule("regex-delimiter", "^\\/|\\/$"),
        grammar.rule("regex-flags", "^[a-z]+$"),
      ],
    ),
    grammar.rule(
      "function",
      "#?(?!\\s)[_$a-zA-Z\\xA0-\\x{FFFF}](?:(?!\\s)[$\\w\\xA0-\\x{FFFF}])*(?=\\s*[=:]\\s*(?:async\\s*)?(?:\\bfunction\\b|(?:\\((?:[^()]|\\([^()]*\\))*\\)|(?!\\s)[_$a-zA-Z\\xA0-\\x{FFFF}](?:(?!\\s)[$\\w\\xA0-\\x{FFFF}])*)\\s*=>))",
    ),
    grammar.rule("constant", "\\b[A-Z](?:[A-Z_]|\\dx?)*\\b"),
    grammar.rule("keyword", "(?:(?:^|\\})\\s*)\\Kcatch\\b"),
    grammar.rule(
      "keyword",
      "(?:^|[^.]|\\.\\.\\.\\s*)\\K\\b(?:as|assert(?=\\s*\\{)|async(?=\\s*(?:function\\b|\\(|[$\\w\\xA0-\\x{FFFF}]|$))|await|break|case|class|const|continue|debugger|default|delete|do|else|enum|export|extends|finally(?=\\s*(?:\\{|$))|for|from(?=\\s*(?:['\"]|$))|function|(?:get|set)(?=\\s*(?:[#\\[$\\w\\xA0-\\x{FFFF}]|$))|if|implements|import|in|instanceof|interface|let|new|null|of|package|private|protected|public|return|static|super|switch|this|throw|try|typeof|undefined|var|void|while|with|yield)\\b",
    ),
    grammar.rule(
      "keyword",
      "\\b(?:abstract|declare|is|keyof|readonly|require)\\b",
    ),
    grammar.rule(
      "keyword",
      "\\b(?:asserts|infer|interface|module|namespace|type)\\b(?=\\s*(?:[{_$a-zA-Z\\xA0-\\x{FFFF}]|$))",
    ),
    grammar.rule("keyword", "\\btype\\b(?=\\s*(?:[\\{*]|$))"),
    grammar.rule("boolean", "\\b(?:false|true)\\b"),
    grammar.rule_with_inside("decorator", "@[$\\w\\xA0-\\x{FFFF}]+", [
      grammar.rule("operator", "^@"),
      grammar.rule("function", "^[\\s\\S]+"),
    ]),
    grammar.greedy_rule_with_inside(
      "generic-function",
      "#?(?!\\s)[_$a-zA-Z\\xA0-\\x{FFFF}](?:(?!\\s)[$\\w\\xA0-\\x{FFFF}])*\\s*<(?:[^<>]|<(?:[^<>]|<[^<>]*>)*>)*>(?=\\s*\\()",
      [
        grammar.rule(
          "function",
          "^#?(?!\\s)[_$a-zA-Z\\xA0-\\x{FFFF}](?:(?!\\s)[$\\w\\xA0-\\x{FFFF}])*",
        ),
        grammar.rule("class-name", "<[\\s\\S]+"),
      ],
    ),
    grammar.rule(
      "function",
      "#?(?!\\s)[_$a-zA-Z\\xA0-\\x{FFFF}](?:(?!\\s)[$\\w\\xA0-\\x{FFFF}])*(?=\\s*(?:\\.\\s*(?:apply|bind|call)\\s*)?\\()",
    ),
    grammar.rule(
      "number",
      "(?:^|[^\\w$])\\K(?:NaN|Infinity|0[bB][01]+(?:_[01]+)*n?|0[oO][0-7]+(?:_[0-7]+)*n?|0[xX][\\dA-Fa-f]+(?:_[\\dA-Fa-f]+)*n?|\\d+(?:_\\d+)*n|(?:\\d+(?:_\\d+)*(?:\\.(?:\\d+(?:_\\d+)*)?)?|\\.\\d+(?:_\\d+)*)(?:[Ee][+-]?\\d+(?:_\\d+)*)?)(?![\\w$])",
    ),
    grammar.rule(
      "operator",
      "--|\\+\\+|\\*\\*=?|=>|&&=?|\\|\\|=?|[!=]==|<<=?|>>>?=?|[-+*/%&|^!=<>]=?|\\.{3}|\\?\\?=?|\\?\\.?|[~:]",
    ),
    grammar.rule("punctuation", "[{}[\\];(),.:]"),
    grammar.rule(
      "builtin",
      "\\b(?:Array|Function|Promise|any|boolean|console|never|number|string|symbol|unknown)\\b",
    ),
  ]
}
