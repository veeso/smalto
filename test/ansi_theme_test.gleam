import gleam/function
import gleam/string as gleam_string
import gleeunit/should
import smalto/ansi_theme
import smalto/token.{AnsiCustom, AnsiKeyword, AnsiOther, AnsiString}

pub fn default_theme_has_keyword_style_test() {
  let style = ansi_theme.get(ansi_theme.default(), AnsiKeyword)
  let result = style("if")
  { result != "if" }
  |> should.be_true
}

pub fn empty_theme_returns_identity_test() {
  let style = ansi_theme.get(ansi_theme.new(), AnsiKeyword)
  style("if")
  |> should.equal("if")
}

pub fn keyword_sets_style_test() {
  let theme =
    ansi_theme.new()
    |> ansi_theme.keyword(gleam_string.uppercase)
  let style = ansi_theme.get(theme, AnsiKeyword)
  style("if")
  |> should.equal("IF")
}

pub fn get_missing_token_returns_identity_test() {
  let theme =
    ansi_theme.new()
    |> ansi_theme.keyword(gleam_string.uppercase)
  let style = ansi_theme.get(theme, AnsiString)
  style("hello")
  |> should.equal("hello")
}

pub fn setter_replaces_existing_style_test() {
  let theme =
    ansi_theme.new()
    |> ansi_theme.keyword(gleam_string.uppercase)
    |> ansi_theme.keyword(gleam_string.lowercase)
  let style = ansi_theme.get(theme, AnsiKeyword)
  style("IF")
  |> should.equal("if")
}

pub fn custom_token_setter_works_test() {
  let theme =
    ansi_theme.new()
    |> ansi_theme.custom("decorator", gleam_string.uppercase)
  let style = ansi_theme.get(theme, AnsiCustom("decorator"))
  style("app")
  |> should.equal("APP")
}

pub fn custom_token_different_names_are_distinct_test() {
  let theme =
    ansi_theme.new()
    |> ansi_theme.custom("decorator", gleam_string.uppercase)
  let style = ansi_theme.get(theme, AnsiCustom("annotation"))
  style("app")
  |> should.equal("app")
}

pub fn default_theme_other_is_unstyled_test() {
  let style = ansi_theme.get(ansi_theme.default(), AnsiOther)
  style("xyz")
  |> should.equal("xyz")
}

pub fn identity_function_is_returned_for_missing_test() {
  let style = ansi_theme.get(ansi_theme.new(), AnsiKeyword)
  { style == function.identity }
  |> should.be_true
}
