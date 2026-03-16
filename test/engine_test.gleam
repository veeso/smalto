import gleeunit/should
import smalto/grammar
import smalto/internal/engine
import smalto/token.{Custom, Keyword, Other, String as TString}

fn no_lookup(_name: String) -> List(grammar.Rule) {
  []
}

pub fn empty_input_returns_empty_list_test() {
  let rules = [grammar.rule("keyword", "\\bif\\b")]
  engine.tokenize("", rules, no_lookup)
  |> should.equal([])
}

pub fn single_keyword_match_test() {
  let rules = [grammar.rule("keyword", "\\bif\\b")]
  engine.tokenize("if", rules, no_lookup)
  |> should.equal([Keyword("if")])
}

pub fn unmatched_text_becomes_other_test() {
  let rules = [grammar.rule("keyword", "\\bif\\b")]
  engine.tokenize("xyz", rules, no_lookup)
  |> should.equal([Other("xyz")])
}

pub fn first_match_wins_test() {
  let rules = [
    grammar.rule("keyword", "if"),
    grammar.rule("variable", "[a-z]+"),
  ]
  engine.tokenize("if", rules, no_lookup)
  |> should.equal([Keyword("if")])
}

pub fn mixed_tokens_test() {
  let rules = [
    grammar.greedy_rule("string", "\"[^\"]*\""),
    grammar.rule("keyword", "\\bif\\b"),
  ]
  engine.tokenize("if \"hello\"", rules, no_lookup)
  |> should.equal([Keyword("if"), Other(" "), TString("\"hello\"")])
}

pub fn keyword_inside_string_not_matched_test() {
  let rules = [
    grammar.greedy_rule("string", "\"[^\"]*\""),
    grammar.rule("keyword", "\\bif\\b"),
  ]
  engine.tokenize("\"if\"", rules, no_lookup)
  |> should.equal([TString("\"if\"")])
}

pub fn adjacent_other_tokens_collapsed_test() {
  let rules = [grammar.rule("keyword", "\\bif\\b")]
  engine.tokenize("abc if xyz", rules, no_lookup)
  |> should.equal([Other("abc "), Keyword("if"), Other(" xyz")])
}

pub fn nested_tokenization_test() {
  let outer_rules = [
    grammar.nested_rule("block", "\\{[^}]*\\}", "inner"),
  ]
  let lookup = fn(_name: String) -> List(grammar.Rule) {
    [grammar.rule("keyword", "\\bx\\b")]
  }
  let result = engine.tokenize("{x}", outer_rules, lookup)
  // The block "{x}" is re-tokenized with inner rules.
  // "{" and "}" don't match the keyword rule, so they become Other.
  // "x" matches the keyword rule.
  result
  |> should.equal([Other("{"), Keyword("x"), Other("}")])
}

pub fn map_token_name_known_names_test() {
  engine.map_token_name("keyword", "if")
  |> should.equal(Keyword("if"))

  engine.map_token_name("string", "\"hi\"")
  |> should.equal(TString("\"hi\""))

  engine.map_token_name("number", "42")
  |> should.equal(token.Number("42"))

  engine.map_token_name("comment", "// x")
  |> should.equal(token.Comment("// x"))

  engine.map_token_name("function", "foo")
  |> should.equal(token.Function("foo"))

  engine.map_token_name("operator", "+")
  |> should.equal(token.Operator("+"))

  engine.map_token_name("punctuation", ";")
  |> should.equal(token.Punctuation(";"))

  engine.map_token_name("type", "Int")
  |> should.equal(token.Type("Int"))

  engine.map_token_name("module", "gleam")
  |> should.equal(token.Module("gleam"))

  engine.map_token_name("variable", "x")
  |> should.equal(token.Variable("x"))

  engine.map_token_name("constant", "PI")
  |> should.equal(token.Constant("PI"))

  engine.map_token_name("builtin", "print")
  |> should.equal(token.Builtin("print"))

  engine.map_token_name("tag", "div")
  |> should.equal(token.Tag("div"))

  engine.map_token_name("attribute", "id")
  |> should.equal(token.Attribute("id"))

  engine.map_token_name("selector", ".cls")
  |> should.equal(token.Selector(".cls"))

  engine.map_token_name("property", "color")
  |> should.equal(token.Property("color"))

  engine.map_token_name("regex", "/x/")
  |> should.equal(token.Regex("/x/"))
}

pub fn map_token_name_unknown_becomes_custom_test() {
  engine.map_token_name("decorator", "@app")
  |> should.equal(Custom("decorator", "@app"))
}

pub fn greedy_rule_with_inside_test() {
  let rules = [
    grammar.greedy_rule_with_inside("string", "\"[^\"]*\"", [
      grammar.rule("variable", "\\$\\w+"),
    ]),
    grammar.rule("keyword", "\\bif\\b"),
  ]
  // Greedy string with inside: "if" inside string should not become keyword,
  // but $var should be tokenized as variable
  engine.tokenize("\"hello $name\" if", rules, no_lookup)
  |> should.equal([
    Other("\"hello "),
    token.Variable("$name"),
    Other("\" "),
    Keyword("if"),
  ])
}

pub fn whitespace_tokens_collapsed_test() {
  // Whitespace tokens produced adjacently should be collapsed
  let rules = [
    grammar.rule("keyword", "\\bif\\b"),
  ]
  // Two spaces around keyword — each space is a single Other, not Whitespace.
  // To test Whitespace collapsing, we need rules that produce Whitespace tokens.
  // The engine produces Other for unmatched text, not Whitespace.
  // So this tests Other collapsing with multiple unmatched segments.
  engine.tokenize("  if  ", rules, no_lookup)
  |> should.equal([Other("  "), Keyword("if"), Other("  ")])
}

pub fn greedy_match_spanning_token_node_no_panic_test() {
  // Regression: a greedy rule whose match spans past a TokenNode (created by
  // a prior rule) into a subsequent TextNode caused a badarg panic in
  // byte_slice when match_end fell before the next TextNode's start offset.
  //
  // Setup: "aa bb cc"
  //   Rule 1 (non-greedy): tokenizes "bb" as keyword → nodes become:
  //     TextNode("aa ", 0, 3), TokenNode([Keyword("bb")]), TextNode(" cc", 6, 3)
  //   Rule 2 (greedy): pattern "aa.+" matches "aa bb cc" in the original text.
  //     match_start=0, match_end=8 spans past the TokenNode.
  //     walk_greedy_span skips the TokenNode, then encounters TextNode(" cc",6,3).
  //     Before the fix, match_end(8) > node_start(6) so the slice was valid here,
  //     but a different input can trigger the negative offset.
  //
  // To trigger the actual bug, we need match_end to land *within* the
  // TokenNode's byte range so it's < the next TextNode's node_start.
  // "aabb cc" with Rule 1 matching "bb" (start=2,len=2) and
  // Rule 2 (greedy) matching "aabb" (start=0,len=4). match_end=4, but
  // next TextNode starts at 4 so match_end==node_start which is the boundary.
  //
  // Better: "XaaYZcc" where Rule 1 matches "YZ" (positions 3..5), then
  // Rule 2 (greedy) matches "XaaY" (positions 0..4). match_end=4 < node_start=5.
  let rules = [
    grammar.rule("keyword", "YZ"),
    grammar.greedy_rule("string", "XaaY"),
  ]
  let result = engine.tokenize("XaaYZcc", rules, no_lookup)
  // Rule 1 tokenizes "YZ" as keyword.
  // Rule 2 greedily matches "XaaY" in original (bytes 0..4).
  // walk_greedy_span skips (overwrites) the TokenNode for "YZ", reaches
  // TextNode("cc",5,2). match_end=4 < node_start=5 → TextNode kept intact.
  // The keyword "YZ" is overwritten by the greedy match (Prism.js behavior).
  result
  |> should.equal([TString("XaaY"), Other("cc")])
}

pub fn empty_match_skipped_test() {
  let rules = [grammar.rule("keyword", "x*")]
  let result = engine.tokenize("ab", rules, no_lookup)
  // "x*" matches empty at 'a' and 'b', so each char becomes Other or Keyword("")
  // The engine should not hang and should produce finite output.
  // 'a' and 'b' are not 'x', so empty match → skip grapheme → Other
  result
  |> should.equal([Other("ab")])
}
