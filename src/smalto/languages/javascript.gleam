import gleam/option
import smalto/grammar.{type Grammar, type Rule, Grammar}

pub fn grammar() -> Grammar {
  Grammar(name: "javascript", extends: option.Some("clike"), rules: rules())
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
          "javascript",
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
    grammar.rule_with_inside(
      "class-name",
      "(?:\\b(?:class|extends|implements|instanceof|interface|new)\\s+)\\K[\\w.\\\\]+",
      [
        grammar.rule("punctuation", "[.\\\\]"),
      ],
    ),
    grammar.rule(
      "class-name",
      "(?:^|[^$\\w\\xA0-\\x{FFFF}])\\K(?!\\s)[_$A-Z\\xA0-\\x{FFFF}](?:(?!\\s)[$\\w\\xA0-\\x{FFFF}])*(?=\\.(?:constructor|prototype))",
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
    grammar.rule_with_inside(
      "parameter",
      "(?:function(?:\\s+(?!\\s)[_$a-zA-Z\\xA0-\\x{FFFF}](?:(?!\\s)[$\\w\\xA0-\\x{FFFF}])*)?\\s*\\(\\s*)\\K(?!\\s)(?:[^()\\s]|\\s+(?![\\s)])|\\([^()]*\\))+(?=\\s*\\))",
      [
        grammar.greedy_rule(
          "comment",
          "(?:^|[^\\\\])\\K\\/\\*[\\s\\S]*?(?:\\*\\/|$)",
        ),
        grammar.greedy_rule("comment", "(?:^|[^\\\\:])\\K\\/\\/.*"),
        grammar.greedy_rule("comment", "^#!.*"),
        grammar.greedy_rule(
          "template-string",
          "`(?:\\\\[\\s\\S]|\\$\\{(?:[^{}]|\\{(?:[^{}]|\\{[^}]*\\})*\\})+\\}|(?!\\$\\{)[^\\\\`])*`",
        ),
        grammar.greedy_rule(
          "property",
          "(?m)(?:(?:^|[,{])[ \\t]*)\\K([\"'])(?:\\\\(?:\\r\\n|[\\s\\S])|(?!\\2)[^\\\\\\r\\n])*\\2(?=\\s*:)",
        ),
        grammar.greedy_rule(
          "string",
          "([\"'])(?:\\\\(?:\\r\\n|[\\s\\S])|(?!\\1)[^\\\\\\r\\n])*\\1",
        ),
        grammar.rule(
          "class-name",
          "(?:\\b(?:class|extends|implements|instanceof|interface|new)\\s+)\\K[\\w.\\\\]+",
        ),
        grammar.rule(
          "class-name",
          "(?:^|[^$\\w\\xA0-\\x{FFFF}])\\K(?!\\s)[_$A-Z\\xA0-\\x{FFFF}](?:(?!\\s)[$\\w\\xA0-\\x{FFFF}])*(?=\\.(?:constructor|prototype))",
        ),
        grammar.greedy_rule(
          "regex",
          "(?:(?:^|[^$\\w\\xA0-\\x{FFFF}.\"'\\])\\s]|\\b(?:return|yield))\\s*)\\K\\/(?:(?:\\[(?:[^\\]\\\\\\r\\n]|\\\\.)*\\]|\\\\.|[^/\\\\\\[\\r\\n])+\\/[dgimyus]{0,7}|(?:\\[(?:[^[\\]\\\\\\r\\n]|\\\\.|\\[(?:[^[\\]\\\\\\r\\n]|\\\\.|\\[(?:[^[\\]\\\\\\r\\n]|\\\\.)*\\])*\\])*\\]|\\\\.|[^/\\\\\\[\\r\\n])+\\/[dgimyus]{0,7}v[dgimyus]{0,7})(?=(?:\\s|\\/\\*(?:[^*]|\\*(?!\\/))*\\*\\/)*(?:$|[\\r\\n,.;:})\\]]|\\/\\/))",
        ),
        grammar.rule(
          "function",
          "#?(?!\\s)[_$a-zA-Z\\xA0-\\x{FFFF}](?:(?!\\s)[$\\w\\xA0-\\x{FFFF}])*(?=\\s*[=:]\\s*(?:async\\s*)?(?:\\bfunction\\b|(?:\\((?:[^()]|\\([^()]*\\))*\\)|(?!\\s)[_$a-zA-Z\\xA0-\\x{FFFF}](?:(?!\\s)[$\\w\\xA0-\\x{FFFF}])*)\\s*=>))",
        ),
        grammar.rule(
          "parameter",
          "(?:function(?:\\s+(?!\\s)[_$a-zA-Z\\xA0-\\x{FFFF}](?:(?!\\s)[$\\w\\xA0-\\x{FFFF}])*)?\\s*\\(\\s*)\\K(?!\\s)(?:[^()\\s]|\\s+(?![\\s)])|\\([^()]*\\))+(?=\\s*\\))",
        ),
        grammar.rule(
          "parameter",
          "(?i)(?:^|[^$\\w\\xA0-\\x{FFFF}])\\K(?!\\s)[_$a-z\\xA0-\\x{FFFF}](?:(?!\\s)[$\\w\\xA0-\\x{FFFF}])*(?=\\s*=>)",
        ),
        grammar.rule(
          "parameter",
          "(?:\\(\\s*)\\K(?!\\s)(?:[^()\\s]|\\s+(?![\\s)])|\\([^()]*\\))+(?=\\s*\\)\\s*=>)",
        ),
        grammar.rule(
          "parameter",
          "(?:(?:\\b|\\s|^)(?!(?:as|async|await|break|case|catch|class|const|continue|debugger|default|delete|do|else|enum|export|extends|finally|for|from|function|get|if|implements|import|in|instanceof|interface|let|new|null|of|package|private|protected|public|return|set|static|super|switch|this|throw|try|typeof|undefined|var|void|while|with|yield)(?![$\\w\\xA0-\\x{FFFF}]))(?:(?!\\s)[_$a-zA-Z\\xA0-\\x{FFFF}](?:(?!\\s)[$\\w\\xA0-\\x{FFFF}])*\\s*)\\(\\s*|\\]\\s*\\(\\s*)\\K(?!\\s)(?:[^()\\s]|\\s+(?![\\s)])|\\([^()]*\\))+(?=\\s*\\)\\s*\\{)",
        ),
        grammar.rule("constant", "\\b[A-Z](?:[A-Z_]|\\dx?)*\\b"),
        grammar.rule("keyword", "(?:(?:^|\\})\\s*)\\Kcatch\\b"),
        grammar.rule(
          "keyword",
          "(?:^|[^.]|\\.\\.\\.\\s*)\\K\\b(?:as|assert(?=\\s*\\{)|async(?=\\s*(?:function\\b|\\(|[$\\w\\xA0-\\x{FFFF}]|$))|await|break|case|class|const|continue|debugger|default|delete|do|else|enum|export|extends|finally(?=\\s*(?:\\{|$))|for|from(?=\\s*(?:['\"]|$))|function|(?:get|set)(?=\\s*(?:[#\\[$\\w\\xA0-\\x{FFFF}]|$))|if|implements|import|in|instanceof|interface|let|new|null|of|package|private|protected|public|return|static|super|switch|this|throw|try|typeof|undefined|var|void|while|with|yield)\\b",
        ),
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
          "property",
          "(?m)(?:(?:^|[,{])[ \\t]*)\\K(?!\\s)[_$a-zA-Z\\xA0-\\x{FFFF}](?:(?!\\s)[$\\w\\xA0-\\x{FFFF}])*(?=\\s*:)",
        ),
        grammar.rule(
          "operator",
          "--|\\+\\+|\\*\\*=?|=>|&&=?|\\|\\|=?|[!=]==|<<=?|>>>?=?|[-+*/%&|^!=<>]=?|\\.{3}|\\?\\?=?|\\?\\.?|[~:]",
        ),
        grammar.rule("punctuation", "[{}[\\];(),.:]"),
      ],
    ),
    grammar.rule(
      "parameter",
      "(?i)(?:^|[^$\\w\\xA0-\\x{FFFF}])\\K(?!\\s)[_$a-z\\xA0-\\x{FFFF}](?:(?!\\s)[$\\w\\xA0-\\x{FFFF}])*(?=\\s*=>)",
    ),
    grammar.rule(
      "parameter",
      "(?:\\(\\s*)\\K(?!\\s)(?:[^()\\s]|\\s+(?![\\s)])|\\([^()]*\\))+(?=\\s*\\)\\s*=>)",
    ),
    grammar.rule(
      "parameter",
      "(?:(?:\\b|\\s|^)(?!(?:as|async|await|break|case|catch|class|const|continue|debugger|default|delete|do|else|enum|export|extends|finally|for|from|function|get|if|implements|import|in|instanceof|interface|let|new|null|of|package|private|protected|public|return|set|static|super|switch|this|throw|try|typeof|undefined|var|void|while|with|yield)(?![$\\w\\xA0-\\x{FFFF}]))(?:(?!\\s)[_$a-zA-Z\\xA0-\\x{FFFF}](?:(?!\\s)[$\\w\\xA0-\\x{FFFF}])*\\s*)\\(\\s*|\\]\\s*\\(\\s*)\\K(?!\\s)(?:[^()\\s]|\\s+(?![\\s)])|\\([^()]*\\))+(?=\\s*\\)\\s*\\{)",
    ),
    grammar.rule("constant", "\\b[A-Z](?:[A-Z_]|\\dx?)*\\b"),
    grammar.rule("keyword", "(?:(?:^|\\})\\s*)\\Kcatch\\b"),
    grammar.rule(
      "keyword",
      "(?:^|[^.]|\\.\\.\\.\\s*)\\K\\b(?:as|assert(?=\\s*\\{)|async(?=\\s*(?:function\\b|\\(|[$\\w\\xA0-\\x{FFFF}]|$))|await|break|case|class|const|continue|debugger|default|delete|do|else|enum|export|extends|finally(?=\\s*(?:\\{|$))|for|from(?=\\s*(?:['\"]|$))|function|(?:get|set)(?=\\s*(?:[#\\[$\\w\\xA0-\\x{FFFF}]|$))|if|implements|import|in|instanceof|interface|let|new|null|of|package|private|protected|public|return|static|super|switch|this|throw|try|typeof|undefined|var|void|while|with|yield)\\b",
    ),
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
      "property",
      "(?m)(?:(?:^|[,{])[ \\t]*)\\K(?!\\s)[_$a-zA-Z\\xA0-\\x{FFFF}](?:(?!\\s)[$\\w\\xA0-\\x{FFFF}])*(?=\\s*:)",
    ),
    grammar.rule(
      "operator",
      "--|\\+\\+|\\*\\*=?|=>|&&=?|\\|\\|=?|[!=]==|<<=?|>>>?=?|[-+*/%&|^!=<>]=?|\\.{3}|\\?\\?=?|\\?\\.?|[~:]",
    ),
    grammar.rule("punctuation", "[{}[\\];(),.:]"),
  ]
}
