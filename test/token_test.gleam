import gleeunit/should
import smalto/token.{
  AnsiAttribute, AnsiBuiltin, AnsiComment, AnsiConstant, AnsiCustom,
  AnsiFunction, AnsiKeyword, AnsiModule, AnsiNumber, AnsiOperator, AnsiOther,
  AnsiProperty, AnsiPunctuation, AnsiRegex, AnsiSelector, AnsiString, AnsiTag,
  AnsiType, AnsiVariable, AnsiWhitespace,
}

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

pub fn to_ansi_token_for_all_variants_test() {
  token.to_ansi_token(token.Keyword("if")) |> should.equal(AnsiKeyword)
  token.to_ansi_token(token.String("hi")) |> should.equal(AnsiString)
  token.to_ansi_token(token.Number("42")) |> should.equal(AnsiNumber)
  token.to_ansi_token(token.Comment("//")) |> should.equal(AnsiComment)
  token.to_ansi_token(token.Function("f")) |> should.equal(AnsiFunction)
  token.to_ansi_token(token.Operator("+")) |> should.equal(AnsiOperator)
  token.to_ansi_token(token.Punctuation(";")) |> should.equal(AnsiPunctuation)
  token.to_ansi_token(token.Type("Int")) |> should.equal(AnsiType)
  token.to_ansi_token(token.Module("m")) |> should.equal(AnsiModule)
  token.to_ansi_token(token.Variable("x")) |> should.equal(AnsiVariable)
  token.to_ansi_token(token.Constant("C")) |> should.equal(AnsiConstant)
  token.to_ansi_token(token.Builtin("p")) |> should.equal(AnsiBuiltin)
  token.to_ansi_token(token.Tag("div")) |> should.equal(AnsiTag)
  token.to_ansi_token(token.Attribute("a")) |> should.equal(AnsiAttribute)
  token.to_ansi_token(token.Selector("s")) |> should.equal(AnsiSelector)
  token.to_ansi_token(token.Property("p")) |> should.equal(AnsiProperty)
  token.to_ansi_token(token.Regex("/x/")) |> should.equal(AnsiRegex)
  token.to_ansi_token(token.Whitespace(" ")) |> should.equal(AnsiWhitespace)
  token.to_ansi_token(token.Other("?")) |> should.equal(AnsiOther)
  token.to_ansi_token(token.Custom("deco", "@"))
  |> should.equal(AnsiCustom("deco"))
}
