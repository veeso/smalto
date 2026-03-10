---
layout: default
title: Getting started
nav_order: 2
---

# Getting started

This guide walks you through installing Smalto and highlighting your first code snippet.

## Prerequisites

- [Gleam](https://gleam.run) 1.14.0 or later
- [Erlang/OTP](https://www.erlang.org/) 28 or later

## Installation

Add Smalto to your Gleam project:

```sh
gleam add smalto
```

## Quick example

Highlight a Python snippet as HTML:

```gleam
import smalto
import smalto/languages/python

pub fn main() {
  let code = "print('hello, world!')"
  let html = smalto.to_html(code, python.grammar())
  // -> "<span class=\"smalto-function\">print</span>..."
}
```

## Output formats

Smalto supports three output formats from the same grammar and source code.

### HTML

Tokens are wrapped in `<span>` elements with `smalto-` prefixed CSS classes:

```gleam
import smalto
import smalto/languages/python

let html = smalto.to_html("x = 42", python.grammar())
// -> "x <span class=\"smalto-operator\">=</span> <span class=\"smalto-number\">42</span>"
```

Style them with CSS. Smalto ships with **45 pre-built themes** adapted from [Prism.js](https://prismjs.com) — just include one and wrap your output:

```html
<link rel="stylesheet" href="smalto-dracula.css">

<pre class="smalto"><code><!-- output from smalto.to_html() --></code></pre>
```

Browse all available themes in the [`themes/`](https://github.com/veeso/smalto/tree/main/themes) directory.

Or write your own CSS targeting the `smalto-` prefixed classes:

```css
.smalto-keyword { color: #c678dd; }
.smalto-string  { color: #98c379; }
.smalto-number  { color: #d19a66; }
.smalto-comment { color: #5c6370; font-style: italic; }
.smalto-function { color: #61afef; }
```

### ANSI

Render with terminal color codes using the default theme:

```gleam
import smalto
import smalto/languages/rust

let colored = smalto.to_ansi("fn main() {}", rust.grammar())
```

Or use a custom theme:

```gleam
import gleam_community/ansi
import smalto
import smalto/ansi_theme
import smalto/languages/rust

let theme =
  ansi_theme.new()
  |> ansi_theme.keyword(ansi.bright_magenta)
  |> ansi_theme.function(ansi.bright_cyan)
  |> ansi_theme.string(ansi.green)

let colored = smalto.to_ansi_with("fn main() {}", rust.grammar(), theme)
```

See [ANSI themes](ansi-themes) for full theme configuration.

### Structured tokens

Access the raw token list for custom rendering:

```gleam
import smalto
import smalto/languages/javascript
import smalto/token

let tokens = smalto.to_tokens("if (true) {}", javascript.grammar())
// [Keyword("if"), Whitespace(" "), Punctuation("("), ...]
```

Each token carries its type and matched text. See [Tokens](tokens) for details.

## Next steps

- [Tokens](tokens) — understand token types and how to work with them
- [Grammars](grammars) — learn about grammar structure and custom grammars
- [ANSI themes](ansi-themes) — customize terminal colors
- [Supported languages](supported-languages) — full list of built-in grammars
