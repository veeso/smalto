//// HTML and ANSI terminal renderers for syntax-highlighted tokens.

import gleam/list
import gleam/string_tree
import houdini
import smalto/ansi_theme.{type AnsiTheme}
import smalto/token.{Other, Whitespace}

/// Render tokens as HTML with `hl-` prefixed CSS classes.
///
/// Whitespace and Other tokens are output as HTML-escaped text without wrapping.
/// All other tokens are wrapped in `<span class="hl-{name}">` elements.
pub fn to_html(tokens: List(token.Token)) -> String {
  tokens
  |> list.fold(string_tree.new(), fn(tree, tok) {
    let val = tok |> token.value |> houdini.escape
    case tok {
      Whitespace(_) | Other(_) -> string_tree.append(tree, val)
      _ -> {
        let class_name = token.name(tok)
        tree
        |> string_tree.append("<span class=\"hl-")
        |> string_tree.append(class_name)
        |> string_tree.append("\">")
        |> string_tree.append(val)
        |> string_tree.append("</span>")
      }
    }
  })
  |> string_tree.to_string
}

/// Render tokens with ANSI terminal color codes using the given theme.
///
/// Each token type is styled according to the theme. Tokens without
/// a style entry in the theme are rendered as plain text.
pub fn to_ansi(tokens: List(token.Token), theme: AnsiTheme) -> String {
  tokens
  |> list.fold(string_tree.new(), fn(tree, tok) {
    let val = token.value(tok)
    let style = ansi_theme.get(theme, token.to_ansi_token(tok))
    string_tree.append(tree, style(val))
  })
  |> string_tree.to_string
}
