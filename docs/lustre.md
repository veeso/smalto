---
layout: default
title: Lustre integration
nav_order: 3
---

# Lustre integration

The [`smalto_lustre`](https://hex.pm/packages/smalto_lustre) package renders syntax-highlighted tokens as [Lustre](https://hexdocs.pm/lustre/) `Element` nodes, so you can embed highlighted code directly in Lustre views.

## Installation

Add both packages to your project:

```sh
gleam add smalto smalto_lustre
```

## Quick example

```gleam
import lustre/element
import smalto
import smalto/languages/python
import smalto/lustre as smalto_lustre

pub fn highlighted_code() -> element.Element(msg) {
  let code = "print('hello, world!')"
  let tokens = smalto.to_tokens(code, python.grammar())
  let elements = smalto_lustre.to_lustre(tokens, smalto_lustre.default_config())
  element.fragment(elements)
}
```

The `default_config()` renders each token as an inline-styled `<span>` with colors matching smalto's built-in ANSI color scheme.

## Custom rendering

Override individual token renderers with the builder functions. Start from `default_config()` and replace only what you need:

```gleam
import lustre/attribute
import lustre/element
import lustre/element/html
import smalto/lustre as smalto_lustre

let config =
  smalto_lustre.default_config()
  |> smalto_lustre.keyword(fn(value) {
    html.span([attribute.class("smalto-keyword")], [element.text(value)])
  })
  |> smalto_lustre.comment(fn(value) {
    html.span([attribute.class("smalto-comment")], [element.text(value)])
  })
```

This is useful when you prefer CSS classes over inline styles, or want to attach event handlers or custom attributes to specific token types.

### Available builders

`keyword`, `string`, `number`, `comment`, `function`, `operator`, `punctuation`, `type_`, `module`, `variable`, `constant`, `builtin`, `tag`, `attribute`, `selector`, `property`, `regex`, `custom`

### Custom tokens

The `custom` builder receives both the token name and its text value:

```gleam
let config =
  smalto_lustre.default_config()
  |> smalto_lustre.custom(fn(name, value) {
    html.span([attribute.class("smalto-" <> name)], [element.text(value)])
  })
```

## Default color scheme

The default config uses inline `style="color: ..."` attributes with these colors:

| Token | Color |
| ----------- | ----- |
| keyword | `#b8860b` (dark yellow) |
| string | `#008000` (green) |
| number | `#008000` (green) |
| comment | `#808080` (gray, italic) |
| function | `#0000ff` (blue) |
| operator | `#800080` (magenta) |
| punctuation | `#808080` (gray) |
| type | `#008b8b` (cyan) |
| module | `#008b8b` (cyan) |
| variable | `#ffd700` (bright yellow) |
| constant | `#ff00ff` (bright magenta) |
| builtin | `#1e90ff` (bright blue) |
| tag | `#ff0000` (red) |
| attribute | `#b8860b` (dark yellow) |
| selector | `#008b8b` (cyan) |
| property | `#b8860b` (dark yellow) |
| regex | `#008000` (green) |
| custom | plain text (see below) |

The default config also styles markup tokens commonly produced by the Markdown grammar:

| Custom token | Style |
|-------------|-------|
| `important` | bold, `#b8860b` (dark yellow) |
| `bold` | bold |
| `italic` | italic |
| `strike` | line-through |
| `code` | `#008000` (green) |
| `url` | underline, `#008b8b` (cyan) |

Other custom tokens are rendered as plain text.

`Whitespace` and `Other` tokens are always rendered as plain text nodes, regardless of the config.

## API reference

Full API documentation is available on [HexDocs](https://hexdocs.pm/smalto_lustre/).
