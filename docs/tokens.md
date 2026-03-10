---
layout: default
title: Tokens
nav_order: 4
---

# Tokens

Smalto's tokenizer produces a list of `Token` values. Each token wraps the matched source text and carries a semantic category.

## Token type

The `Token` type has 19 built-in variants plus `Custom` for language-specific categories:

| Variant | Description |
|---------|-------------|
| `Keyword(String)` | Language keywords (`if`, `let`, `fn`, `import`) |
| `String(String)` | String literals |
| `Number(String)` | Numeric literals |
| `Comment(String)` | Comments (line and block) |
| `Function(String)` | Function names |
| `Operator(String)` | Operators (`+`, `-`, `==`, `->`) |
| `Punctuation(String)` | Punctuation characters (`(`, `)`, `{`, `}`) |
| `Type(String)` | Type names |
| `Module(String)` | Module names |
| `Variable(String)` | Variable names |
| `Constant(String)` | Constants |
| `Builtin(String)` | Built-in functions or values |
| `Tag(String)` | HTML/XML tags |
| `Attribute(String)` | HTML/XML attributes |
| `Selector(String)` | CSS selectors |
| `Property(String)` | CSS/object properties |
| `Regex(String)` | Regular expressions |
| `Whitespace(String)` | Whitespace sequences |
| `Other(String)` | Unmatched text |
| `Custom(name: String, value: String)` | Language-specific categories |

## Working with tokens

### Getting the token name

Use `token.name()` to get the category as a lowercase string:

```gleam
import smalto/token

token.name(token.Keyword("if"))
// -> "keyword"

token.name(token.Custom("decorator", "@app"))
// -> "decorator"
```

### Getting the token value

Use `token.value()` to extract the matched source text:

```gleam
import smalto/token

token.value(token.Keyword("if"))
// -> "if"

token.value(token.Custom("decorator", "@app"))
// -> "@app"
```

### Pattern matching

Tokens are a standard Gleam type, so you can pattern match directly:

```gleam
import smalto/token.{Comment, Keyword, String, Whitespace}

case tok {
  Keyword(text) -> "keyword: " <> text
  String(text) -> "string: " <> text
  Comment(text) -> "comment: " <> text
  Whitespace(_) -> ""
  _ -> token.value(tok)
}
```

## Custom tokens

Some grammars produce `Custom` tokens for categories that don't map to a built-in variant. The `name` field identifies the category:

```gleam
import smalto/token.{Custom}

case tok {
  Custom("decorator", value) -> handle_decorator(value)
  Custom("annotation", value) -> handle_annotation(value)
  Custom(name, value) -> handle_other(name, value)
  _ -> token.value(tok)
}
```

## Token to AnsiToken conversion

When working with ANSI themes, use `token.to_ansi_token()` to convert a `Token` to its `AnsiToken` key:

```gleam
import smalto/token

token.to_ansi_token(token.Keyword("if"))
// -> AnsiKeyword

token.to_ansi_token(token.Custom("decorator", "@app"))
// -> AnsiCustom("decorator")
```

See [ANSI themes](ansi-themes) for how `AnsiToken` is used in theme configuration.
