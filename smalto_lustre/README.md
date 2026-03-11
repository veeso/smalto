# smalto_lustre

[![Package Version](https://img.shields.io/hexpm/v/smalto_lustre)](https://hex.pm/packages/smalto_lustre)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/smalto_lustre/)
[![conventional-commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-%23FE5196?logo=conventionalcommits&logoColor=white)](https://conventionalcommits.org)
[![target-erlang](https://img.shields.io/badge/target-erlang-b83998)](https://www.erlang.org/)
[![Erlang Compatible](https://img.shields.io/badge/target-erlang-b83998)](https://www.erlang.org/)
![JavaScript Compatible](https://img.shields.io/badge/target-javascript-f3e155)

[Lustre](https://hexdocs.pm/lustre/) element renderer for [smalto](https://hex.pm/packages/smalto) syntax-highlighted tokens.

Converts smalto `Token` values into Lustre `Element` nodes using a configurable `Config` that maps each token type to a rendering function.

## Installation

```sh
gleam add smalto smalto_lustre
```

## Quick start

```gleam
import lustre/element
import smalto
import smalto/languages/python
import smalto/lustre as smalto_lustre

pub fn main() {
  let code = "print('hello')"
  let tokens = smalto.to_tokens(code, python.grammar())
  let elements = smalto_lustre.to_lustre(tokens, smalto_lustre.default_config())

  // Render to an HTML string
  let html =
    elements
    |> element.fragment
    |> element.to_string
}
```

The `default_config()` renders each token as an inline-styled `<span>` with colors matching smalto's built-in ANSI color scheme.

## Custom rendering

Override individual token renderers using the builder functions:

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

let elements = smalto_lustre.to_lustre(tokens, config)
```

Available builders: `keyword`, `string`, `number`, `comment`, `function`, `operator`, `punctuation`, `type_`, `module`, `variable`, `constant`, `builtin`, `tag`, `attribute`, `selector`, `property`, `regex`, `custom`.

## Default color scheme

| Token | Color |
| ----------- | ----- |
| keyword | `#b8860b` (dark yellow) |
| string | `#008000` (green) |
| number | `#008000` (green) |
| comment | `#808080` (gray, italic) |
| function | `#0000ff` (blue) |
| operator | `#800080` (magenta) |
| punctuation | plain text |
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
| custom | plain text |

`Whitespace` and `Other` tokens are always rendered as plain text nodes.

## Documentation

API reference is available on [HexDocs](https://hexdocs.pm/smalto_lustre/).

## License

smalto_lustre is licensed under the MIT License. See [LICENSE](../LICENSE) for details.
