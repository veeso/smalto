import gleam/option
import smalto/grammar.{type Grammar, type Rule, Grammar}

pub fn grammar() -> Grammar {
  Grammar(name: "zig", extends: option.None, rules: rules())
}

fn rules() -> List(Rule) {
  [
    grammar.rule("doc-comment", "\\/\\/[/!].*"),
    grammar.rule("comment", "\\/{2}.*"),
    grammar.greedy_rule(
      "string",
      "(?<=^|[^\\\\@])c?\"(?:[^\"\\\\\\r\\n]|\\\\.)*\"",
    ),
    grammar.greedy_rule(
      "string",
      "(?<=[\\r\\n])([ \\t]+c?\\\\{2}).*(?:(?:\\r\\n?|\\n)\\2.*)*",
    ),
    grammar.greedy_rule(
      "char",
      "(?<=^|[^\\\\])'(?:[^'\\\\\\r\\n]|[\\x{D800}-\\x{DFFF}]{2}|\\\\(?:.|x[a-fA-F\\d]{2}|u\\{[a-fA-F\\d]{1,6}\\}))'",
    ),
    grammar.rule("builtin", "\\B@(?!\\d)\\w+(?=\\s*\\()"),
    grammar.rule(
      "label",
      "(?<=\\b(?:break|continue)\\s*:\\s*)\\w+\\b|\\b(?!\\d)\\w+\\b(?=\\s*:\\s*(?:\\{|while\\b))",
    ),
    grammar.rule(
      "class-name",
      "\\b(?!\\d)\\w+(?=\\s*=\\s*(?:(?:extern|packed)\\s+)?(?:enum|struct|union)\\s*[({])",
    ),
    grammar.rule_with_inside(
      "class-name",
      "(?<=:\\s*)(?!\\s)(?:!?\\s*(?:(?:\\?|\\bpromise->|(?:\\[[^[\\]]*\\]|\\*(?!\\*)|\\*\\*)(?:\\s*align\\s*\\((?:[^()]|\\([^()]*\\))*\\)|\\s*const\\b|\\s*volatile\\b|\\s*allowzero\\b)*)\\s*)*(?:\\bpromise\\b|(?:\\berror\\.)?\\b(?!\\b(?:align|allowzero|and|anyframe|anytype|asm|async|await|break|cancel|catch|comptime|const|continue|defer|else|enum|errdefer|error|export|extern|fn|for|if|inline|linksection|nakedcc|noalias|nosuspend|null|or|orelse|packed|promise|pub|resume|return|stdcallcc|struct|suspend|switch|test|threadlocal|try|undefined|union|unreachable|usingnamespace|var|volatile|while)\\b)(?!\\d)\\w+\\b(?:\\.\\b(?!\\b(?:align|allowzero|and|anyframe|anytype|asm|async|await|break|cancel|catch|comptime|const|continue|defer|else|enum|errdefer|error|export|extern|fn|for|if|inline|linksection|nakedcc|noalias|nosuspend|null|or|orelse|packed|promise|pub|resume|return|stdcallcc|struct|suspend|switch|test|threadlocal|try|undefined|union|unreachable|usingnamespace|var|volatile|while)\\b)(?!\\d)\\w+\\b)*(?!\\s+\\b(?!\\b(?:align|allowzero|and|anyframe|anytype|asm|async|await|break|cancel|catch|comptime|const|continue|defer|else|enum|errdefer|error|export|extern|fn|for|if|inline|linksection|nakedcc|noalias|nosuspend|null|or|orelse|packed|promise|pub|resume|return|stdcallcc|struct|suspend|switch|test|threadlocal|try|undefined|union|unreachable|usingnamespace|var|volatile|while)\\b)(?!\\d)\\w+\\b)))+(?=\\s*(?:align\\s*\\((?:[^()]|\\([^()]*\\))*\\)\\s*)?[=;,)])|(?!\\s)(?:!?\\s*(?:(?:\\?|\\bpromise->|(?:\\[[^[\\]]*\\]|\\*(?!\\*)|\\*\\*)(?:\\s*align\\s*\\((?:[^()]|\\([^()]*\\))*\\)|\\s*const\\b|\\s*volatile\\b|\\s*allowzero\\b)*)\\s*)*(?:\\bpromise\\b|(?:\\berror\\.)?\\b(?!\\b(?:align|allowzero|and|anyframe|anytype|asm|async|await|break|cancel|catch|comptime|const|continue|defer|else|enum|errdefer|error|export|extern|fn|for|if|inline|linksection|nakedcc|noalias|nosuspend|null|or|orelse|packed|promise|pub|resume|return|stdcallcc|struct|suspend|switch|test|threadlocal|try|undefined|union|unreachable|usingnamespace|var|volatile|while)\\b)(?!\\d)\\w+\\b(?:\\.\\b(?!\\b(?:align|allowzero|and|anyframe|anytype|asm|async|await|break|cancel|catch|comptime|const|continue|defer|else|enum|errdefer|error|export|extern|fn|for|if|inline|linksection|nakedcc|noalias|nosuspend|null|or|orelse|packed|promise|pub|resume|return|stdcallcc|struct|suspend|switch|test|threadlocal|try|undefined|union|unreachable|usingnamespace|var|volatile|while)\\b)(?!\\d)\\w+\\b)*(?!\\s+\\b(?!\\b(?:align|allowzero|and|anyframe|anytype|asm|async|await|break|cancel|catch|comptime|const|continue|defer|else|enum|errdefer|error|export|extern|fn|for|if|inline|linksection|nakedcc|noalias|nosuspend|null|or|orelse|packed|promise|pub|resume|return|stdcallcc|struct|suspend|switch|test|threadlocal|try|undefined|union|unreachable|usingnamespace|var|volatile|while)\\b)(?!\\d)\\w+\\b)))+(?=\\s*(?:align\\s*\\((?:[^()]|\\([^()]*\\))*\\)\\s*)?\\{)",
      [
        grammar.rule("comment", "\\/{2}.*"),
        grammar.rule("builtin", "\\B@(?!\\d)\\w+(?=\\s*\\()"),
        grammar.rule(
          "class-name",
          "\\b(?!\\d)\\w+(?=\\s*=\\s*(?:(?:extern|packed)\\s+)?(?:enum|struct|union)\\s*[({])",
        ),
        grammar.rule(
          "class-name",
          "(?<=\\)\\s*)(?!\\s)(?:!?\\s*(?:(?:\\?|\\bpromise->|(?:\\[[^[\\]]*\\]|\\*(?!\\*)|\\*\\*)(?:\\s*align\\s*\\((?:[^()]|\\([^()]*\\))*\\)|\\s*const\\b|\\s*volatile\\b|\\s*allowzero\\b)*)\\s*)*(?:\\bpromise\\b|(?:\\berror\\.)?\\b(?!\\b(?:align|allowzero|and|anyframe|anytype|asm|async|await|break|cancel|catch|comptime|const|continue|defer|else|enum|errdefer|error|export|extern|fn|for|if|inline|linksection|nakedcc|noalias|nosuspend|null|or|orelse|packed|promise|pub|resume|return|stdcallcc|struct|suspend|switch|test|threadlocal|try|undefined|union|unreachable|usingnamespace|var|volatile|while)\\b)(?!\\d)\\w+\\b(?:\\.\\b(?!\\b(?:align|allowzero|and|anyframe|anytype|asm|async|await|break|cancel|catch|comptime|const|continue|defer|else|enum|errdefer|error|export|extern|fn|for|if|inline|linksection|nakedcc|noalias|nosuspend|null|or|orelse|packed|promise|pub|resume|return|stdcallcc|struct|suspend|switch|test|threadlocal|try|undefined|union|unreachable|usingnamespace|var|volatile|while)\\b)(?!\\d)\\w+\\b)*(?!\\s+\\b(?!\\b(?:align|allowzero|and|anyframe|anytype|asm|async|await|break|cancel|catch|comptime|const|continue|defer|else|enum|errdefer|error|export|extern|fn|for|if|inline|linksection|nakedcc|noalias|nosuspend|null|or|orelse|packed|promise|pub|resume|return|stdcallcc|struct|suspend|switch|test|threadlocal|try|undefined|union|unreachable|usingnamespace|var|volatile|while)\\b)(?!\\d)\\w+\\b)))+(?=\\s*(?:align\\s*\\((?:[^()]|\\([^()]*\\))*\\)\\s*)?;)",
        ),
        grammar.rule(
          "keyword",
          "\\b(?:anyerror|bool|c_u?(?:int|long|longlong|short)|c_longdouble|c_void|comptime_(?:float|int)|f(?:16|32|64|128)|[iu](?:8|16|32|64|128|size)|noreturn|type|void)\\b",
        ),
        grammar.rule(
          "keyword",
          "\\b(?:align|allowzero|and|anyframe|anytype|asm|async|await|break|cancel|catch|comptime|const|continue|defer|else|enum|errdefer|error|export|extern|fn|for|if|inline|linksection|nakedcc|noalias|nosuspend|null|or|orelse|packed|promise|pub|resume|return|stdcallcc|struct|suspend|switch|test|threadlocal|try|undefined|union|unreachable|usingnamespace|var|volatile|while)\\b",
        ),
        grammar.rule("function", "\\b(?!\\d)\\w+(?=\\s*\\()"),
        grammar.rule(
          "number",
          "\\b(?:0b[01]+|0o[0-7]+|0x[a-fA-F\\d]+(?:\\.[a-fA-F\\d]*)?(?:[pP][+-]?[a-fA-F\\d]+)?|\\d+(?:\\.\\d*)?(?:[eE][+-]?\\d+)?)\\b",
        ),
        grammar.rule("boolean", "\\b(?:false|true)\\b"),
        grammar.rule(
          "operator",
          "\\.[*?]|\\.{2,3}|[-=]>|\\*\\*|\\+\\+|\\|\\||(?:<<|>>|[-+*]%|[-+*/%^&|<>!=])=?|[?~]",
        ),
        grammar.rule("punctuation", "[.:,;(){}[\\]]"),
      ],
    ),
    grammar.rule(
      "keyword",
      "\\b(?:align|allowzero|and|anyframe|anytype|asm|async|await|break|cancel|catch|comptime|const|continue|defer|else|enum|errdefer|error|export|extern|fn|for|if|inline|linksection|nakedcc|noalias|nosuspend|null|or|orelse|packed|promise|pub|resume|return|stdcallcc|struct|suspend|switch|test|threadlocal|try|undefined|union|unreachable|usingnamespace|var|volatile|while)\\b",
    ),
    grammar.rule("function", "\\b(?!\\d)\\w+(?=\\s*\\()"),
    grammar.rule(
      "number",
      "\\b(?:0b[01]+|0o[0-7]+|0x[a-fA-F\\d]+(?:\\.[a-fA-F\\d]*)?(?:[pP][+-]?[a-fA-F\\d]+)?|\\d+(?:\\.\\d*)?(?:[eE][+-]?\\d+)?)\\b",
    ),
    grammar.rule("boolean", "\\b(?:false|true)\\b"),
    grammar.rule(
      "operator",
      "\\.[*?]|\\.{2,3}|[-=]>|\\*\\*|\\+\\+|\\|\\||(?:<<|>>|[-+*]%|[-+*/%^&|<>!=])=?|[?~]",
    ),
    grammar.rule("punctuation", "[.:,;(){}[\\]]"),
  ]
}
