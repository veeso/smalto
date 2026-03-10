//// ANSI terminal color themes for syntax highlighting.
////
//// An `AnsiTheme` maps token types to styling functions that transform
//// plain text into ANSI-colored output. Use `default()` for the built-in
//// color scheme, or build a custom theme with `new()` and per-token setters.
////
//// ## Example
////
//// ```gleam
//// import gleam_community/ansi
//// import smalto/ansi_theme
////
//// let theme =
////   ansi_theme.new()
////   |> ansi_theme.keyword(ansi.yellow)
////   |> ansi_theme.string(ansi.green)
////   |> ansi_theme.comment(fn(v) { ansi.italic(ansi.gray(v)) })
//// ```

import gleam/dict.{type Dict}
import gleam/function
import gleam_community/ansi
import smalto/token.{
  type AnsiToken, AnsiAttribute, AnsiBuiltin, AnsiComment, AnsiConstant,
  AnsiFunction, AnsiKeyword, AnsiModule, AnsiNumber, AnsiOperator, AnsiProperty,
  AnsiRegex, AnsiSelector, AnsiString, AnsiTag, AnsiType, AnsiVariable,
}

/// A theme that maps token types to ANSI styling functions.
///
/// Each entry maps a token category to a function `fn(String) -> String`
/// that applies terminal color codes. Tokens not present in the theme
/// are rendered without styling.
pub opaque type AnsiTheme {
  AnsiTheme(styles: Dict(AnsiToken, fn(String) -> String))
}

/// Create an empty theme where all tokens are unstyled.
pub fn new() -> AnsiTheme {
  AnsiTheme(styles: dict.new())
}

/// Create the default theme matching smalto's built-in color scheme.
pub fn default() -> AnsiTheme {
  new()
  |> keyword(ansi.yellow)
  |> string(ansi.green)
  |> number(ansi.green)
  |> function(ansi.blue)
  |> comment(fn(val) { ansi.italic(ansi.gray(val)) })
  |> module(ansi.cyan)
  |> type_(ansi.cyan)
  |> operator(ansi.magenta)
  |> tag(ansi.red)
  |> builtin(ansi.bright_blue)
  |> attribute(ansi.yellow)
  |> property(ansi.yellow)
  |> selector(ansi.cyan)
  |> regex(ansi.green)
  |> constant(ansi.bright_magenta)
  |> variable(ansi.bright_yellow)
}

/// Look up the styling function for a token type.
///
/// Returns the identity function if the token has no style in the theme.
pub fn get(theme: AnsiTheme, token: AnsiToken) -> fn(String) -> String {
  case dict.get(theme.styles, token) {
    Ok(style) -> style
    Error(_) -> function.identity
  }
}

/// Set the styling function for keyword tokens.
pub fn keyword(theme: AnsiTheme, style: fn(String) -> String) -> AnsiTheme {
  insert(theme, AnsiKeyword, style)
}

/// Set the styling function for string tokens.
pub fn string(theme: AnsiTheme, style: fn(String) -> String) -> AnsiTheme {
  insert(theme, AnsiString, style)
}

/// Set the styling function for number tokens.
pub fn number(theme: AnsiTheme, style: fn(String) -> String) -> AnsiTheme {
  insert(theme, AnsiNumber, style)
}

/// Set the styling function for comment tokens.
pub fn comment(theme: AnsiTheme, style: fn(String) -> String) -> AnsiTheme {
  insert(theme, AnsiComment, style)
}

/// Set the styling function for function tokens.
pub fn function(theme: AnsiTheme, style: fn(String) -> String) -> AnsiTheme {
  insert(theme, AnsiFunction, style)
}

/// Set the styling function for operator tokens.
pub fn operator(theme: AnsiTheme, style: fn(String) -> String) -> AnsiTheme {
  insert(theme, AnsiOperator, style)
}

/// Set the styling function for punctuation tokens.
pub fn punctuation(theme: AnsiTheme, style: fn(String) -> String) -> AnsiTheme {
  insert(theme, token.AnsiPunctuation, style)
}

/// Set the styling function for type tokens.
pub fn type_(theme: AnsiTheme, style: fn(String) -> String) -> AnsiTheme {
  insert(theme, AnsiType, style)
}

/// Set the styling function for module tokens.
pub fn module(theme: AnsiTheme, style: fn(String) -> String) -> AnsiTheme {
  insert(theme, AnsiModule, style)
}

/// Set the styling function for variable tokens.
pub fn variable(theme: AnsiTheme, style: fn(String) -> String) -> AnsiTheme {
  insert(theme, AnsiVariable, style)
}

/// Set the styling function for constant tokens.
pub fn constant(theme: AnsiTheme, style: fn(String) -> String) -> AnsiTheme {
  insert(theme, AnsiConstant, style)
}

/// Set the styling function for builtin tokens.
pub fn builtin(theme: AnsiTheme, style: fn(String) -> String) -> AnsiTheme {
  insert(theme, AnsiBuiltin, style)
}

/// Set the styling function for tag tokens.
pub fn tag(theme: AnsiTheme, style: fn(String) -> String) -> AnsiTheme {
  insert(theme, AnsiTag, style)
}

/// Set the styling function for attribute tokens.
pub fn attribute(theme: AnsiTheme, style: fn(String) -> String) -> AnsiTheme {
  insert(theme, AnsiAttribute, style)
}

/// Set the styling function for selector tokens.
pub fn selector(theme: AnsiTheme, style: fn(String) -> String) -> AnsiTheme {
  insert(theme, AnsiSelector, style)
}

/// Set the styling function for property tokens.
pub fn property(theme: AnsiTheme, style: fn(String) -> String) -> AnsiTheme {
  insert(theme, AnsiProperty, style)
}

/// Set the styling function for regex tokens.
pub fn regex(theme: AnsiTheme, style: fn(String) -> String) -> AnsiTheme {
  insert(theme, AnsiRegex, style)
}

/// Set the styling function for whitespace tokens.
pub fn whitespace(theme: AnsiTheme, style: fn(String) -> String) -> AnsiTheme {
  insert(theme, token.AnsiWhitespace, style)
}

/// Set the styling function for other (unmatched) tokens.
pub fn other(theme: AnsiTheme, style: fn(String) -> String) -> AnsiTheme {
  insert(theme, token.AnsiOther, style)
}

/// Set the styling function for a custom token by name.
pub fn custom(
  theme: AnsiTheme,
  name: String,
  style: fn(String) -> String,
) -> AnsiTheme {
  insert(theme, token.AnsiCustom(name), style)
}

fn insert(
  theme: AnsiTheme,
  token: AnsiToken,
  style: fn(String) -> String,
) -> AnsiTheme {
  AnsiTheme(styles: dict.insert(theme.styles, token, style))
}
