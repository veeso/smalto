import gleam/option.{None}
import gleeunit
import gleeunit/should
import smalto
import smalto/grammar
import smalto/token

pub fn main() -> Nil {
  gleeunit.main()
}

fn simple_grammar() -> grammar.Grammar {
  grammar.Grammar("test", None, [
    grammar.greedy_rule("string", "\"[^\"]*\""),
    grammar.rule("keyword", "\\b(?:if|else|while)\\b"),
    grammar.rule("number", "\\b\\d+\\b"),
  ])
}

// -- to_tokens tests --

pub fn to_tokens_empty_input_test() {
  smalto.to_tokens("", simple_grammar())
  |> should.equal([])
}

pub fn to_tokens_simple_code_test() {
  smalto.to_tokens("if 42", simple_grammar())
  |> should.equal([token.Keyword("if"), token.Other(" "), token.Number("42")])
}

pub fn to_tokens_string_and_keyword_test() {
  smalto.to_tokens("if \"hello\"", simple_grammar())
  |> should.equal([
    token.Keyword("if"),
    token.Other(" "),
    token.String("\"hello\""),
  ])
}

pub fn to_tokens_with_inline_inside_test() {
  let g =
    grammar.Grammar("test", None, [
      grammar.rule_with_inside("block", "\\[[^\\]]*\\]", [
        grammar.rule("keyword", "\\bx\\b"),
      ]),
    ])

  smalto.to_tokens("[x]", g)
  |> should.equal([token.Other("["), token.Keyword("x"), token.Other("]")])
}

// -- to_html tests --

pub fn to_html_renders_spans_test() {
  smalto.to_html("if 42", simple_grammar())
  |> should.equal(
    "<span class=\"hl-keyword\">if</span> <span class=\"hl-number\">42</span>",
  )
}

pub fn to_html_escapes_html_in_other_test() {
  let g = grammar.Grammar("test", None, [])
  smalto.to_html("<b>", g)
  |> should.equal("&lt;b&gt;")
}

pub fn to_html_with_inline_inside_test() {
  let g =
    grammar.Grammar("test", None, [
      grammar.rule_with_inside("block", "\\[[^\\]]*\\]", [
        grammar.rule("keyword", "\\bx\\b"),
      ]),
    ])

  smalto.to_html("[x]", g)
  |> should.equal("[<span class=\"hl-keyword\">x</span>]")
}

// -- to_ansi tests --

pub fn to_ansi_returns_colored_output_test() {
  let result = smalto.to_ansi("if", simple_grammar())
  // Should contain ANSI codes, so not equal to plain "if"
  { result != "if" }
  |> should.be_true
}

pub fn to_ansi_unmatched_text_is_plain_test() {
  let g = grammar.Grammar("test", None, [])
  smalto.to_ansi("hello", g)
  |> should.equal("hello")
}
