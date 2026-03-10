import gleam/option
import smalto/grammar.{type Grammar, type Rule, Grammar}

pub fn grammar() -> Grammar {
  Grammar(name: "rust", extends: option.None, rules: rules())
}

fn rules() -> List(Rule) {
  [
    grammar.greedy_rule(
      "comment",
      "(?<=^|[^\\\\])\\/\\*(?:[^*/]|\\*(?!\\/)|\\/(?!\\*)|\\/\\*(?:[^*/]|\\*(?!\\/)|\\/(?!\\*)|\\/\\*(?:[^*/]|\\*(?!\\/)|\\/(?!\\*)|\\/\\*(?:[^*/]|\\*(?!\\/)|\\/(?!\\*)|[^\\s\\S])*\\*\\/)*\\*\\/)*\\*\\/)*\\*\\/",
    ),
    grammar.greedy_rule("comment", "(?<=^|[^\\\\:])\\/\\/.*"),
    grammar.greedy_rule(
      "string",
      "b?\"(?:\\\\[\\s\\S]|[^\\\\\"])*\"|b?r(#*)\"(?:[^\"]|\"(?!\\1))*\"\\1",
    ),
    grammar.greedy_rule(
      "char",
      "b?'(?:\\\\(?:x[0-7][\\da-fA-F]|u\\{(?:[\\da-fA-F]_*){1,6}\\}|.)|[^\\\\\\r\\n\\t'])'",
    ),
    grammar.greedy_rule(
      "attr-name",
      "#!?\\[(?:[^\\[\\]\"]|\"(?:\\\\[\\s\\S]|[^\\\\\"])*\")*\\]",
    ),
    grammar.nested_rule(
      "closure-params",
      "(?<=[=(,:]\\s*|\\bmove\\s*)\\|[^|]*\\||\\|[^|]*\\|(?=\\s*(?:\\{|->))",
      "rust",
    ),
    grammar.rule("symbol", "'\\w+"),
    grammar.rule("punctuation", "(?<=\\$\\w+:)[a-z]+"),
    grammar.rule("variable", "\\$\\w+"),
    grammar.rule("function", "(?<=\\bfn\\s+)\\w+"),
    grammar.rule(
      "class-name",
      "(?<=\\b(?:enum|struct|trait|type|union)\\s+)\\w+",
    ),
    grammar.rule("namespace", "(?<=\\b(?:crate|mod)\\s+)[a-z][a-z_\\d]*"),
    grammar.rule_with_inside(
      "namespace",
      "(?<=\\b(?:crate|self|super)\\s*)::\\s*[a-z][a-z_\\d]*\\b(?:\\s*::(?:\\s*[a-z][a-z_\\d]*\\s*::)*)?",
      [
        grammar.rule("punctuation", "::"),
      ],
    ),
    grammar.rule(
      "keyword",
      "\\b(?:Self|abstract|as|async|await|become|box|break|const|continue|crate|do|dyn|else|enum|extern|final|fn|for|if|impl|in|let|loop|macro|match|mod|move|mut|override|priv|pub|ref|return|self|static|struct|super|trait|try|type|typeof|union|unsafe|unsized|use|virtual|where|while|yield)\\b",
    ),
    grammar.rule(
      "keyword",
      "\\b(?:bool|char|f(?:32|64)|[ui](?:8|16|32|64|128|size)|str)\\b",
    ),
    grammar.rule("function", "\\b[a-z_]\\w*(?=\\s*(?:::\\s*<|\\())"),
    grammar.rule("property", "\\b\\w+!"),
    grammar.rule("constant", "\\b[A-Z_][A-Z_\\d]+\\b"),
    grammar.rule("class-name", "\\b[A-Z]\\w*\\b"),
    grammar.rule_with_inside(
      "namespace",
      "(?:\\b[a-z][a-z_\\d]*\\s*::\\s*)*\\b[a-z][a-z_\\d]*\\s*::(?!\\s*<)",
      [
        grammar.rule("punctuation", "::"),
      ],
    ),
    grammar.rule(
      "number",
      "\\b(?:0x[\\dA-Fa-f](?:_?[\\dA-Fa-f])*|0o[0-7](?:_?[0-7])*|0b[01](?:_?[01])*|(?:(?:\\d(?:_?\\d)*)?\\.)?\\d(?:_?\\d)*(?:[Ee][+-]?\\d+)?)(?:_?(?:f32|f64|[iu](?:8|16|32|64|size)?))?\\b",
    ),
    grammar.rule("boolean", "\\b(?:false|true)\\b"),
    grammar.rule("punctuation", "->|\\.\\.=|\\.{1,3}|::|[{}[\\];(),:]"),
    grammar.rule(
      "operator",
      "[-+*\\/%!^]=?|=[=>]?|&[&=]?|\\|[|=]?|<<?=?|>>?=?|[@?]",
    ),
  ]
}
