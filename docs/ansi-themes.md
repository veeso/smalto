---
layout: default
title: ANSI themes
nav_order: 6
---

# ANSI themes

Smalto renders syntax-highlighted text with ANSI terminal color codes. The `AnsiTheme` type lets you control which colors are applied to each token type.

## Default theme

The default theme applies these colors:

| Token | Style |
|-------|-------|
| Keyword | Yellow |
| String | Green |
| Number | Green |
| Function | Blue |
| Comment | Gray italic |
| Module | Cyan |
| Type | Cyan |
| Operator | Magenta |
| Tag | Red |
| Builtin | Bright blue |
| Attribute | Yellow |
| Property | Yellow |
| Selector | Cyan |
| Regex | Green |
| Constant | Bright magenta |
| Variable | Bright yellow |
| Punctuation | No styling |
| Whitespace | No styling |
| Other | No styling |
| Custom | No styling |

Use `smalto.to_ansi()` to render with the default theme:

```gleam
import smalto
import smalto/languages/python

let colored = smalto.to_ansi("print('hello')", python.grammar())
```

## Custom themes

Build a custom theme with `ansi_theme.new()` and per-token setter functions:

```gleam
import gleam_community/ansi
import smalto
import smalto/ansi_theme
import smalto/languages/python

let theme =
  ansi_theme.new()
  |> ansi_theme.keyword(ansi.bright_magenta)
  |> ansi_theme.string(ansi.bright_green)
  |> ansi_theme.number(ansi.bright_yellow)
  |> ansi_theme.function(ansi.bright_cyan)
  |> ansi_theme.comment(fn(v) { ansi.italic(ansi.bright_black(v)) })
  |> ansi_theme.operator(ansi.red)

let colored = smalto.to_ansi_with("print('hello')", python.grammar(), theme)
```

Tokens without a setter in the theme are rendered as plain text.

## Setter functions

Each setter takes the theme and a styling function `fn(String) -> String`:

| Setter | Token type |
|--------|-----------|
| `ansi_theme.keyword(theme, style)` | Keywords |
| `ansi_theme.string(theme, style)` | String literals |
| `ansi_theme.number(theme, style)` | Numbers |
| `ansi_theme.comment(theme, style)` | Comments |
| `ansi_theme.function(theme, style)` | Function names |
| `ansi_theme.operator(theme, style)` | Operators |
| `ansi_theme.punctuation(theme, style)` | Punctuation |
| `ansi_theme.type_(theme, style)` | Type names |
| `ansi_theme.module(theme, style)` | Module names |
| `ansi_theme.variable(theme, style)` | Variables |
| `ansi_theme.constant(theme, style)` | Constants |
| `ansi_theme.builtin(theme, style)` | Built-in functions |
| `ansi_theme.tag(theme, style)` | HTML/XML tags |
| `ansi_theme.attribute(theme, style)` | Attributes |
| `ansi_theme.selector(theme, style)` | CSS selectors |
| `ansi_theme.property(theme, style)` | Properties |
| `ansi_theme.regex(theme, style)` | Regular expressions |
| `ansi_theme.whitespace(theme, style)` | Whitespace |
| `ansi_theme.other(theme, style)` | Unmatched text |
| `ansi_theme.custom(theme, name, style)` | Custom token by name |

## Composing styles

The styling function is `fn(String) -> String`, so you can compose multiple ANSI effects:

```gleam
import gleam_community/ansi

// Bold cyan
ansi_theme.keyword(theme, fn(v) { ansi.bold(ansi.cyan(v)) })

// Italic gray (like the default comment style)
ansi_theme.comment(theme, fn(v) { ansi.italic(ansi.gray(v)) })

// Underlined bright red
ansi_theme.tag(theme, fn(v) { ansi.underline(ansi.bright_red(v)) })
```

## Extending the default theme

Start from the default and override specific tokens:

```gleam
import gleam_community/ansi
import smalto/ansi_theme

let theme =
  ansi_theme.default()
  |> ansi_theme.keyword(ansi.bright_magenta)
  |> ansi_theme.comment(fn(v) { ansi.italic(ansi.bright_black(v)) })
```

## Custom token styles

Grammars may produce `Custom` tokens for language-specific categories. Style them with `ansi_theme.custom()`:

```gleam
import gleam_community/ansi
import smalto/ansi_theme

let theme =
  ansi_theme.default()
  |> ansi_theme.custom("decorator", ansi.bright_yellow)
  |> ansi_theme.custom("annotation", ansi.bright_cyan)
```
