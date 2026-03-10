import gleeunit/should
import smalto/grammar
import smalto/internal/engine
import smalto/token.{
  Comment, Function as TFunction, Keyword, Number, Operator, Other, Punctuation,
  String as TString, Variable,
}

fn no_lookup(_name: String) -> List(grammar.Rule) {
  []
}

// ---------------------------------------------------------------------------
// 1. Rule ordering / priority
// ---------------------------------------------------------------------------

pub fn rule_priority_first_rule_wins_test() {
  // Two rules both match "class" — first should win
  let rules = [
    grammar.rule("keyword", "class"),
    grammar.rule("variable", "class"),
  ]
  engine.tokenize("class", rules, no_lookup)
  |> should.equal([Keyword("class")])
}

pub fn rule_priority_longer_match_loses_to_earlier_rule_test() {
  // First rule matches shorter "class", second would match "classname"
  // First rule wins because rules are tried in order
  let rules = [
    grammar.rule("keyword", "class"),
    grammar.rule("variable", "classname"),
  ]
  engine.tokenize("classname", rules, no_lookup)
  |> should.equal([Keyword("class"), Other("name")])
}

pub fn rule_priority_multiple_matches_in_text_test() {
  // A single rule matches multiple positions — all should be found
  let rules = [grammar.rule("keyword", "\\bif\\b")]
  engine.tokenize("if then if else if", rules, no_lookup)
  |> should.equal([
    Keyword("if"),
    Other(" then "),
    Keyword("if"),
    Other(" else "),
    Keyword("if"),
  ])
}

// ---------------------------------------------------------------------------
// 2. Non-greedy matching
// ---------------------------------------------------------------------------

pub fn non_greedy_match_at_start_test() {
  let rules = [grammar.rule("keyword", "let")]
  engine.tokenize("let x", rules, no_lookup)
  |> should.equal([Keyword("let"), Other(" x")])
}

pub fn non_greedy_match_in_middle_test() {
  let rules = [grammar.rule("keyword", "if")]
  engine.tokenize("x if y", rules, no_lookup)
  |> should.equal([Other("x "), Keyword("if"), Other(" y")])
}

pub fn non_greedy_match_at_end_test() {
  let rules = [grammar.rule("keyword", "end")]
  engine.tokenize("the end", rules, no_lookup)
  |> should.equal([Other("the "), Keyword("end")])
}

pub fn non_greedy_multiple_matches_same_rule_test() {
  let rules = [grammar.rule("number", "\\d+")]
  engine.tokenize("1 + 2 + 3", rules, no_lookup)
  |> should.equal([
    Number("1"),
    Other(" + "),
    Number("2"),
    Other(" + "),
    Number("3"),
  ])
}

pub fn non_greedy_does_not_match_across_token_boundaries_test() {
  // First rule tokenizes "ab", so second rule (which matches "bc") cannot
  // see "bc" as a contiguous fragment — "b" is consumed, only "c" remains
  let rules = [
    grammar.rule("keyword", "ab"),
    grammar.rule("variable", "bc"),
  ]
  engine.tokenize("abc", rules, no_lookup)
  |> should.equal([Keyword("ab"), Other("c")])
}

// ---------------------------------------------------------------------------
// 3. Greedy matching
// ---------------------------------------------------------------------------

pub fn greedy_string_prevents_keyword_inside_test() {
  // Greedy string rule wraps "if" — keyword should NOT match inside
  let rules = [
    grammar.rule("keyword", "\\bif\\b"),
    grammar.greedy_rule("string", "\"[^\"]*\""),
  ]
  engine.tokenize("\"if\"", rules, no_lookup)
  |> should.equal([TString("\"if\"")])
}

pub fn greedy_comment_prevents_matches_inside_test() {
  // Greedy comment wrapping code; keywords inside should not match
  let rules = [
    grammar.rule("keyword", "\\bif\\b"),
    grammar.greedy_rule("comment", "/\\*[\\s\\S]*?\\*/"),
  ]
  engine.tokenize("/* if else */", rules, no_lookup)
  |> should.equal([Comment("/* if else */")])
}

pub fn greedy_vs_non_greedy_ordering_test() {
  // Non-greedy keyword first, then greedy string.
  // Input: "if" — greedy string should overwrite the non-greedy keyword match
  let rules = [
    grammar.rule("keyword", "\\bif\\b"),
    grammar.greedy_rule("string", "\"[^\"]*\""),
  ]
  engine.tokenize("\"if\"", rules, no_lookup)
  |> should.equal([TString("\"if\"")])
}

pub fn greedy_multiline_string_test() {
  // Greedy string pattern matching across newlines
  let rules = [
    grammar.greedy_rule("string", "\"[\\s\\S]*?\""),
    grammar.rule("keyword", "\\bif\\b"),
  ]
  engine.tokenize("\"hello\nworld\"", rules, no_lookup)
  |> should.equal([TString("\"hello\nworld\"")])
}

// ---------------------------------------------------------------------------
// 4. Inline grammar / inside
// ---------------------------------------------------------------------------

pub fn inside_inline_grammar_test() {
  // Rule with inline inside rules — string content gets recursively tokenized
  let rules = [
    grammar.rule_with_inside("string", "\"[^\"]*\"", [
      grammar.rule("variable", "\\$\\w+"),
    ]),
  ]
  engine.tokenize("\"hello $name\"", rules, no_lookup)
  |> should.equal([Other("\"hello "), Variable("$name"), Other("\"")])
}

pub fn inside_inline_grammar_nested_tokens_test() {
  // Template string with interpolation: outer matches backtick string,
  // inside rules match ${...}, and inner rules tokenize the expression
  let rules = [
    grammar.rule_with_inside("string", "`[^`]*`", [
      grammar.rule_with_inside("variable", "\\$\\{[^}]*\\}", [
        grammar.rule("variable", "\\w+"),
      ]),
    ]),
  ]
  engine.tokenize("`hello ${name}`", rules, no_lookup)
  |> should.equal([Other("`hello ${"), Variable("name"), Other("}`")])
}

pub fn inside_language_ref_test() {
  // Rule with LanguageRef — lookup provides inner lang rules
  let rules = [grammar.nested_rule("block", "\\{[^}]*\\}", "inner_lang")]
  let lookup = fn(_name: String) -> List(grammar.Rule) {
    [grammar.rule("keyword", "\\breturn\\b")]
  }
  engine.tokenize("{return}", rules, lookup)
  |> should.equal([Other("{"), Keyword("return"), Other("}")])
}

pub fn inside_preserves_unmatched_as_other_test() {
  // Inside grammar doesn't match everything — unmatched parts become Other
  let rules = [
    grammar.rule_with_inside("string", "\"[^\"]*\"", [
      grammar.rule("variable", "\\$\\w+"),
    ]),
  ]
  engine.tokenize("\"no vars here\"", rules, no_lookup)
  |> should.equal([Other("\"no vars here\"")])
}

// ---------------------------------------------------------------------------
// 5. Greedy spanning across nodes
// ---------------------------------------------------------------------------

pub fn greedy_span_across_text_nodes_test() {
  // A greedy rule matches text that was split by a previous non-greedy rule.
  // Rule 1 (non-greedy keyword "var") matches inside the string.
  // Rule 2 (greedy string) should overwrite and claim the full range.
  let rules = [
    grammar.rule("keyword", "\\bvar\\b"),
    grammar.greedy_rule("string", "\"[^\"]*\""),
  ]
  engine.tokenize("\"var x\"", rules, no_lookup)
  |> should.equal([TString("\"var x\"")])
}

// ---------------------------------------------------------------------------
// 6. Edge cases
// ---------------------------------------------------------------------------

pub fn empty_input_test() {
  let rules = [grammar.rule("keyword", "\\bif\\b")]
  engine.tokenize("", rules, no_lookup)
  |> should.equal([])
}

pub fn no_rules_test() {
  engine.tokenize("hello world", [], no_lookup)
  |> should.equal([Other("hello world")])
}

pub fn all_text_matched_test() {
  // Every character matched by some rule, no Other tokens
  let rules = [
    grammar.rule("keyword", "\\bif\\b"),
    grammar.rule("punctuation", "[();]"),
  ]
  engine.tokenize("if()", rules, no_lookup)
  |> should.equal([Keyword("if"), Punctuation("("), Punctuation(")")])
}

pub fn unicode_input_test() {
  let rules = [
    grammar.rule("keyword", "\\blet\\b"),
    grammar.rule("number", "\\b\\d+\\b"),
  ]
  engine.tokenize("let café = 42", rules, no_lookup)
  |> should.equal([
    Keyword("let"),
    Other(" café = "),
    Number("42"),
  ])
}

pub fn overlapping_patterns_test() {
  // Float rule first, then integer rule. Float should win for "3.14"
  let rules = [
    grammar.rule("number", "\\d+\\.\\d+"),
    grammar.rule("number", "\\d+"),
  ]
  engine.tokenize("3.14", rules, no_lookup)
  |> should.equal([Number("3.14")])
}

pub fn pattern_with_lookahead_test() {
  // Pattern with lookahead — match consumes only text before the lookahead
  let rules = [grammar.rule("function", "\\b[a-z_]\\w*(?=\\()")]
  engine.tokenize("foo()", rules, no_lookup)
  |> should.equal([TFunction("foo"), Other("()")])
}

pub fn pattern_with_lookbehind_test() {
  // Pattern with lookbehind — match only the part after the lookbehind
  let rules = [grammar.rule("variable", "(?<=\\$)\\w+")]
  engine.tokenize("$name", rules, no_lookup)
  |> should.equal([Other("$"), Variable("name")])
}

pub fn invalid_pattern_silently_skipped_test() {
  // Invalid regex pattern should be skipped, other rules still work
  let rules = [
    grammar.rule("keyword", "[invalid("),
    grammar.rule("number", "\\d+"),
  ]
  engine.tokenize("42", rules, no_lookup)
  |> should.equal([Number("42")])
}

// ---------------------------------------------------------------------------
// 7. Mock language integration
// ---------------------------------------------------------------------------

pub fn mock_language_full_test() {
  let rules = [
    grammar.greedy_rule("string", "\"[^\"]*\""),
    grammar.greedy_rule("string", "'[^']*'"),
    grammar.greedy_rule("comment", "//.*"),
    grammar.greedy_rule("comment", "/\\*[\\s\\S]*?\\*/"),
    grammar.rule("keyword", "\\b(?:let|if|else|fn|return)\\b"),
    grammar.rule("number", "\\b\\d+(?:\\.\\d+)?\\b"),
    grammar.rule("function", "\\b[a-z_]\\w*(?=\\()"),
    grammar.rule("operator", "[+\\-*/=<>!]+"),
    grammar.rule("punctuation", "[{}()\\[\\];,.]"),
  ]

  let input =
    "let x = 42;\n// comment\nif (greet(\"hello\")) {\n  return x + 1;\n}"

  engine.tokenize(input, rules, no_lookup)
  |> should.equal([
    Keyword("let"),
    Other(" x "),
    Operator("="),
    Other(" "),
    Number("42"),
    Punctuation(";"),
    Other("\n"),
    Comment("// comment"),
    Other("\n"),
    Keyword("if"),
    Other(" "),
    Punctuation("("),
    TFunction("greet"),
    Punctuation("("),
    TString("\"hello\""),
    Punctuation(")"),
    Punctuation(")"),
    Other(" "),
    Punctuation("{"),
    Other("\n  "),
    Keyword("return"),
    Other(" x "),
    Operator("+"),
    Other(" "),
    Number("1"),
    Punctuation(";"),
    Other("\n"),
    Punctuation("}"),
  ])
}
