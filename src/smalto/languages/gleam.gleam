import gleam/option
import smalto/grammar.{type Grammar, type Rule, Grammar}

/// Returns the Gleam language grammar.
pub fn grammar() -> Grammar {
  Grammar(name: "gleam", extends: option.None, rules: rules())
}

fn rules() -> List(Rule) {
  [
    // Comments: module (////), doc (///), and normal (//)
    grammar.greedy_rule("comment", "\\/\\/\\/\\/.*"),
    grammar.greedy_rule("comment", "\\/\\/\\/.*"),
    grammar.greedy_rule("comment", "\\/\\/.*"),
    // Strings: double-quoted with escape sequences
    grammar.greedy_rule("string", "\"(?:\\\\[\\s\\S]|[^\\\\\"\\r\\n])*\""),
    // Module in import statements
    grammar.rule("module", "(?:\\bimport\\s+)\\K[a-z][a-z_/\\d]*"),
    // Function definition after fn keyword
    grammar.rule("function", "(?:\\bfn\\s+)\\K[a-z_]\\w*"),
    // Keywords
    grammar.rule(
      "keyword",
      "\\b(?:as|assert|auto|case|const|delegat|echo|else|external|fn|if|implement|import|let|macro|opaque|panic|pub|test|todo|type|use)\\b",
    ),
    // Bit string keywords
    grammar.rule(
      "keyword",
      "\\b(?:bits|bytes|float|int|utf8|utf16|utf32|utf8_codepoint|utf16_codepoint|utf32_codepoint|signed|unsigned|big|little|native|size|unit)\\b(?=\\s*(?:[,>-]))",
    ),
    // Numbers: hex, octal, binary, float, integer (with underscores)
    grammar.rule(
      "number",
      "\\b0x[\\da-fA-F][\\da-fA-F_]*\\b|\\b0o[0-7][0-7_]*\\b|\\b0b[01][01_]*\\b|\\b\\d[\\d_]*\\.\\d[\\d_]*(?:e[+-]?\\d[\\d_]*)?\\b|\\b\\d[\\d_]*\\b",
    ),
    // Module qualifier in qualified function calls (e.g., `io.println(`, `list.map(`)
    grammar.rule("module", "\\b[a-z_]\\w*(?=\\.[a-z_]\\w*\\s*\\()"),
    // Function call: identifier followed by (
    grammar.rule("function", "\\b[a-z_]\\w*(?=\\s*\\()"),
    // Type constructors and type names (PascalCase)
    grammar.rule("type", "\\b[A-Z]\\w*\\b"),
    // Attribute
    grammar.rule("attribute", "@[a-z_]\\w*"),
    // Discard name
    grammar.rule("variable", "\\b_\\w*\\b"),
    // Operators
    grammar.rule(
      "operator",
      "\\|>|<>|<<|>>|->|<-|\\.\\.|&&|\\|\\||[+\\-*/]=?|%|[<>]=?\\.?|[!=]=|=",
    ),
    // Punctuation
    grammar.rule("punctuation", "[(){}\\[\\]:;,.#|]"),
  ]
}
