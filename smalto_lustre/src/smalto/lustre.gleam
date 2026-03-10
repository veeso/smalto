//// Lustre element renderer for smalto syntax-highlighted tokens.
////
//// Converts a list of `Token` values into Lustre `Element` nodes using a
//// configurable `Config` that maps each token type to a rendering function.
//// Use `default_config` for inline-styled spans matching smalto's ANSI color
//// scheme, or build a custom config with the builder functions.
////
//// ## Usage
////
//// ```gleam
//// import smalto
//// import smalto/languages/python
//// import smalto/lustre as smalto_lustre
////
//// // Render with the default inline-styled config
//// let tokens = smalto.to_tokens("print('hello')", python.grammar())
//// let elements = smalto_lustre.to_lustre(tokens, smalto_lustre.default_config())
////
//// // Customize specific token renderers
//// let config =
////   smalto_lustre.default_config()
////   |> smalto_lustre.keyword(fn(value) {
////     html.span([attribute.class("my-keyword")], [element.text(value)])
////   })
//// let elements = smalto_lustre.to_lustre(tokens, config)
//// ```

import gleam/list
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import smalto/token.{type Token, Custom, Other, Whitespace}

/// Configuration for rendering tokens as Lustre elements.
///
/// Each field is a function that receives the token's text value and returns
/// a Lustre element. The `custom` field receives both the token name and value.
/// `Whitespace` and `Other` tokens are always rendered as plain text nodes.
pub type Config(msg) {
  Config(
    keyword: fn(String) -> Element(msg),
    string: fn(String) -> Element(msg),
    number: fn(String) -> Element(msg),
    comment: fn(String) -> Element(msg),
    function: fn(String) -> Element(msg),
    operator: fn(String) -> Element(msg),
    punctuation: fn(String) -> Element(msg),
    type_: fn(String) -> Element(msg),
    module: fn(String) -> Element(msg),
    variable: fn(String) -> Element(msg),
    constant: fn(String) -> Element(msg),
    builtin: fn(String) -> Element(msg),
    tag: fn(String) -> Element(msg),
    attribute: fn(String) -> Element(msg),
    selector: fn(String) -> Element(msg),
    property: fn(String) -> Element(msg),
    regex: fn(String) -> Element(msg),
    custom: fn(String, String) -> Element(msg),
  )
}

/// Create the default config with inline-styled `<span>` elements
/// matching smalto's built-in ANSI color scheme.
///
/// Each token is rendered as `<span style="color: ...">value</span>`.
/// Comments additionally receive `font-style: italic`.
/// Punctuation and custom tokens are rendered as plain text.
pub fn default_config() -> Config(msg) {
  Config(
    keyword: colored_span("#b8860b"),
    string: colored_span("#008000"),
    number: colored_span("#008000"),
    comment: fn(value) {
      html.span(
        [
          attribute.style("color", "#808080"),
          attribute.style("font-style", "italic"),
        ],
        [element.text(value)],
      )
    },
    function: colored_span("#0000ff"),
    operator: colored_span("#800080"),
    punctuation: fn(value) { element.text(value) },
    type_: colored_span("#008b8b"),
    module: colored_span("#008b8b"),
    variable: colored_span("#ffd700"),
    constant: colored_span("#ff00ff"),
    builtin: colored_span("#1e90ff"),
    tag: colored_span("#ff0000"),
    attribute: colored_span("#b8860b"),
    selector: colored_span("#008b8b"),
    property: colored_span("#b8860b"),
    regex: colored_span("#008000"),
    custom: fn(_name, value) { element.text(value) },
  )
}

/// Render a list of tokens as Lustre elements using the given config.
///
/// `Whitespace` and `Other` tokens are always rendered as plain text nodes
/// regardless of the config. All other tokens are dispatched to the
/// corresponding config function.
pub fn to_lustre(tokens: List(Token), config: Config(msg)) -> List(Element(msg)) {
  list.map(tokens, token_to_element(_, config))
}

/// Set the rendering function for keyword tokens.
pub fn keyword(
  config: Config(msg),
  render: fn(String) -> Element(msg),
) -> Config(msg) {
  Config(..config, keyword: render)
}

/// Set the rendering function for string tokens.
pub fn string(
  config: Config(msg),
  render: fn(String) -> Element(msg),
) -> Config(msg) {
  Config(..config, string: render)
}

/// Set the rendering function for number tokens.
pub fn number(
  config: Config(msg),
  render: fn(String) -> Element(msg),
) -> Config(msg) {
  Config(..config, number: render)
}

/// Set the rendering function for comment tokens.
pub fn comment(
  config: Config(msg),
  render: fn(String) -> Element(msg),
) -> Config(msg) {
  Config(..config, comment: render)
}

/// Set the rendering function for function tokens.
pub fn function(
  config: Config(msg),
  render: fn(String) -> Element(msg),
) -> Config(msg) {
  Config(..config, function: render)
}

/// Set the rendering function for operator tokens.
pub fn operator(
  config: Config(msg),
  render: fn(String) -> Element(msg),
) -> Config(msg) {
  Config(..config, operator: render)
}

/// Set the rendering function for punctuation tokens.
pub fn punctuation(
  config: Config(msg),
  render: fn(String) -> Element(msg),
) -> Config(msg) {
  Config(..config, punctuation: render)
}

/// Set the rendering function for type tokens.
pub fn type_(
  config: Config(msg),
  render: fn(String) -> Element(msg),
) -> Config(msg) {
  Config(..config, type_: render)
}

/// Set the rendering function for module tokens.
pub fn module(
  config: Config(msg),
  render: fn(String) -> Element(msg),
) -> Config(msg) {
  Config(..config, module: render)
}

/// Set the rendering function for variable tokens.
pub fn variable(
  config: Config(msg),
  render: fn(String) -> Element(msg),
) -> Config(msg) {
  Config(..config, variable: render)
}

/// Set the rendering function for constant tokens.
pub fn constant(
  config: Config(msg),
  render: fn(String) -> Element(msg),
) -> Config(msg) {
  Config(..config, constant: render)
}

/// Set the rendering function for builtin tokens.
pub fn builtin(
  config: Config(msg),
  render: fn(String) -> Element(msg),
) -> Config(msg) {
  Config(..config, builtin: render)
}

/// Set the rendering function for tag tokens.
pub fn tag(
  config: Config(msg),
  render: fn(String) -> Element(msg),
) -> Config(msg) {
  Config(..config, tag: render)
}

/// Set the rendering function for attribute tokens.
pub fn attribute(
  config: Config(msg),
  render: fn(String) -> Element(msg),
) -> Config(msg) {
  Config(..config, attribute: render)
}

/// Set the rendering function for selector tokens.
pub fn selector(
  config: Config(msg),
  render: fn(String) -> Element(msg),
) -> Config(msg) {
  Config(..config, selector: render)
}

/// Set the rendering function for property tokens.
pub fn property(
  config: Config(msg),
  render: fn(String) -> Element(msg),
) -> Config(msg) {
  Config(..config, property: render)
}

/// Set the rendering function for regex tokens.
pub fn regex(
  config: Config(msg),
  render: fn(String) -> Element(msg),
) -> Config(msg) {
  Config(..config, regex: render)
}

/// Set the rendering function for custom tokens.
/// The function receives both the token name and text value.
pub fn custom(
  config: Config(msg),
  render: fn(String, String) -> Element(msg),
) -> Config(msg) {
  Config(..config, custom: render)
}

// --- Private helpers ---

fn token_to_element(tok: Token, config: Config(msg)) -> Element(msg) {
  case tok {
    Whitespace(v) | Other(v) -> element.text(v)
    token.Keyword(v) -> config.keyword(v)
    token.String(v) -> config.string(v)
    token.Number(v) -> config.number(v)
    token.Comment(v) -> config.comment(v)
    token.Function(v) -> config.function(v)
    token.Operator(v) -> config.operator(v)
    token.Punctuation(v) -> config.punctuation(v)
    token.Type(v) -> config.type_(v)
    token.Module(v) -> config.module(v)
    token.Variable(v) -> config.variable(v)
    token.Constant(v) -> config.constant(v)
    token.Builtin(v) -> config.builtin(v)
    token.Tag(v) -> config.tag(v)
    token.Attribute(v) -> config.attribute(v)
    token.Selector(v) -> config.selector(v)
    token.Property(v) -> config.property(v)
    token.Regex(v) -> config.regex(v)
    Custom(name, v) -> config.custom(name, v)
  }
}

fn colored_span(color: String) -> fn(String) -> Element(msg) {
  fn(value) {
    html.span([attribute.style("color", color)], [element.text(value)])
  }
}
