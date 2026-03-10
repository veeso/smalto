//// A general-purpose syntax highlighting library for Gleam.
////
//// Smalto uses regex-based grammars inspired by Prism.js to tokenize source
//// code for 30 programming languages, with output to structured tokens,
//// ANSI terminal colors, or HTML.
////
//// ## Usage
////
//// ```gleam
//// import smalto
//// import smalto/languages/python
////
//// let html = smalto.to_html("print('hello')", python.grammar())
//// let ansi = smalto.to_ansi("print('hello')", python.grammar())
//// let tokens = smalto.to_tokens("print('hello')", python.grammar())
//// ```
////
//// Each language module exports a single `grammar()` function that returns
//// the language's `Grammar` definition. Pass it directly to `to_tokens`,
//// `to_html`, or `to_ansi` along with the source code to highlight.

import gleam/dict
import gleam/option
import smalto/ansi_theme.{type AnsiTheme}
import smalto/grammar.{type Grammar}
import smalto/internal/engine
import smalto/internal/registry
import smalto/internal/renderer
import smalto/token.{type Token}

/// Tokenize source code into a list of tokens using the given grammar.
///
/// Cross-language `LanguageRef` references in grammar rules are resolved
/// automatically using the built-in language registry.
pub fn to_tokens(code: String, grammar: Grammar) -> List(Token) {
  let resolved_rules = resolve_grammar(grammar)
  engine.tokenize(code, resolved_rules, lookup())
}

/// Render syntax-highlighted HTML from source code.
///
/// Tokens are wrapped in `<span class="smalto-{name}">` elements with
/// HTML-escaped content. Whitespace and unmatched text are output as-is.
pub fn to_html(code: String, grammar: Grammar) -> String {
  to_tokens(code, grammar) |> renderer.to_html
}

/// Render syntax-highlighted text with ANSI terminal color codes
/// using the default color theme.
///
/// Each token type is mapped to a specific terminal color.
pub fn to_ansi(code: String, grammar: Grammar) -> String {
  to_tokens(code, grammar) |> renderer.to_ansi(ansi_theme.default())
}

/// Render syntax-highlighted text with ANSI terminal color codes
/// using a custom color theme.
pub fn to_ansi_with(code: String, grammar: Grammar, theme: AnsiTheme) -> String {
  to_tokens(code, grammar) |> renderer.to_ansi(theme)
}

/// Resolve a grammar's inheritance chain into a flat list of rules.
fn resolve_grammar(g: Grammar) -> List(grammar.Rule) {
  let langs = registry.languages()
  grammar.resolve(g, fn(parent_name) {
    case dict.get(langs, parent_name) {
      Ok(parent) -> parent
      Error(_) ->
        grammar.Grammar(name: parent_name, extends: option.None, rules: [])
    }
  })
}

/// Build the language lookup function from the internal registry.
fn lookup() -> fn(String) -> List(grammar.Rule) {
  let langs = registry.languages()
  fn(name) {
    case dict.get(langs, name) {
      Ok(g) ->
        grammar.resolve(g, fn(parent_name) {
          case dict.get(langs, parent_name) {
            Ok(parent) -> parent
            Error(_) ->
              grammar.Grammar(
                name: parent_name,
                extends: option.None,
                rules: [],
              )
          }
        })
      Error(_) -> []
    }
  }
}
