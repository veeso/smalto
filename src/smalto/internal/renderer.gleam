//// HTML and ANSI terminal renderers for syntax-highlighted tokens.

import gleam/list
import gleam/string_tree
import gleam_community/ansi
import houdini
import smalto/token.{
  Attribute, Builtin, Comment, Constant, Custom, Function, Keyword, Module,
  Number, Operator, Other, Property, Punctuation, Regex, Selector, String, Tag,
  Type, Variable, Whitespace,
}

/// Render tokens as HTML with `hl-` prefixed CSS classes.
///
/// Whitespace and Other tokens are output as HTML-escaped text without wrapping.
/// All other tokens are wrapped in `<span class="hl-{name}">` elements.
pub fn to_html(tokens: List(token.Token)) -> String {
  tokens
  |> list.fold(string_tree.new(), fn(tree, tok) {
    let val = houdini.escape(token.value(tok))
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

/// Render tokens with ANSI terminal color codes.
///
/// Each token type is mapped to a specific color for terminal display.
/// Whitespace, Other, Punctuation, and Custom tokens are rendered without
/// color codes.
pub fn to_ansi(tokens: List(token.Token)) -> String {
  tokens
  |> list.fold(string_tree.new(), fn(tree, tok) {
    let val = token.value(tok)
    let colored = case tok {
      Keyword(_) -> ansi.yellow(val)
      String(_) | Number(_) -> ansi.green(val)
      Function(_) -> ansi.blue(val)
      Comment(_) -> ansi.italic(ansi.gray(val))
      Module(_) | Type(_) -> ansi.cyan(val)
      Operator(_) -> ansi.magenta(val)
      Tag(_) -> ansi.red(val)
      Builtin(_) -> ansi.bright_blue(val)
      Attribute(_) | Property(_) -> ansi.yellow(val)
      Selector(_) -> ansi.cyan(val)
      Regex(_) -> ansi.green(val)
      Constant(_) -> ansi.bright_magenta(val)
      Variable(_) -> ansi.bright_yellow(val)
      Punctuation(_) | Whitespace(_) | Other(_) | Custom(_, _) -> val
    }
    string_tree.append(tree, colored)
  })
  |> string_tree.to_string
}
