import gleeunit/should
import smalto/token

pub fn name_returns_keyword_for_keyword_token_test() {
  token.name(token.Keyword("if"))
  |> should.equal("keyword")
}

pub fn name_returns_custom_name_test() {
  token.name(token.Custom("decorator", "@app"))
  |> should.equal("decorator")
}

pub fn name_for_all_builtin_variants_test() {
  token.name(token.Keyword("if")) |> should.equal("keyword")
  token.name(token.String("hello")) |> should.equal("string")
  token.name(token.Number("42")) |> should.equal("number")
  token.name(token.Comment("// x")) |> should.equal("comment")
  token.name(token.Function("main")) |> should.equal("function")
  token.name(token.Operator("+")) |> should.equal("operator")
  token.name(token.Punctuation("(")) |> should.equal("punctuation")
  token.name(token.Type("Int")) |> should.equal("type")
  token.name(token.Module("gleam")) |> should.equal("module")
  token.name(token.Variable("x")) |> should.equal("variable")
  token.name(token.Constant("PI")) |> should.equal("constant")
  token.name(token.Builtin("print")) |> should.equal("builtin")
  token.name(token.Tag("div")) |> should.equal("tag")
  token.name(token.Attribute("class")) |> should.equal("attribute")
  token.name(token.Selector(".btn")) |> should.equal("selector")
  token.name(token.Property("color")) |> should.equal("property")
  token.name(token.Regex("/\\d+/")) |> should.equal("regex")
  token.name(token.Whitespace(" ")) |> should.equal("whitespace")
  token.name(token.Other("???")) |> should.equal("other")
}

pub fn value_extracts_content_test() {
  token.value(token.Keyword("if"))
  |> should.equal("if")
}

pub fn value_extracts_custom_content_test() {
  token.value(token.Custom("x", "hello"))
  |> should.equal("hello")
}

pub fn value_for_all_builtin_variants_test() {
  token.value(token.Keyword("if")) |> should.equal("if")
  token.value(token.String("hello")) |> should.equal("hello")
  token.value(token.Number("42")) |> should.equal("42")
  token.value(token.Comment("// x")) |> should.equal("// x")
  token.value(token.Function("main")) |> should.equal("main")
  token.value(token.Operator("+")) |> should.equal("+")
  token.value(token.Punctuation("(")) |> should.equal("(")
  token.value(token.Type("Int")) |> should.equal("Int")
  token.value(token.Module("gleam")) |> should.equal("gleam")
  token.value(token.Variable("x")) |> should.equal("x")
  token.value(token.Constant("PI")) |> should.equal("PI")
  token.value(token.Builtin("print")) |> should.equal("print")
  token.value(token.Tag("div")) |> should.equal("div")
  token.value(token.Attribute("class")) |> should.equal("class")
  token.value(token.Selector(".btn")) |> should.equal(".btn")
  token.value(token.Property("color")) |> should.equal("color")
  token.value(token.Regex("/\\d+/")) |> should.equal("/\\d+/")
  token.value(token.Whitespace(" ")) |> should.equal(" ")
  token.value(token.Other("???")) |> should.equal("???")
}
