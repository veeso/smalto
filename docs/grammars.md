---
layout: default
title: Grammars
nav_order: 5
---

# Grammars

A grammar defines how source code is tokenized for a particular language. Smalto ships with 36 built-in grammars and supports custom grammar definitions.

## Grammar structure

A `Grammar` has three fields:

| Field | Type | Description |
|-------|------|-------------|
| `name` | `String` | Language name (e.g., `"python"`, `"javascript"`) |
| `extends` | `Option(String)` | Optional parent language for inheritance |
| `rules` | `List(Rule)` | Ordered list of tokenization rules |

## Rules

Each `Rule` defines a pattern that matches a token type:

| Field | Type | Description |
|-------|------|-------------|
| `token` | `String` | Token name (maps to `Token` variants: `"keyword"` -> `Keyword`) |
| `pattern` | `String` | PCRE regex pattern |
| `greedy` | `Bool` | If `True`, matches against the full source text to avoid partial matches |
| `inside` | `Option(Inside)` | Optional nested grammar for recursive tokenization |

## Using built-in grammars

Each language module exports a `grammar()` function:

```gleam
import smalto
import smalto/languages/python

let tokens = smalto.to_tokens("print('hello')", python.grammar())
```

## Building custom grammars

Use the builder functions in `smalto/grammar` to define a grammar:

```gleam
import gleam/option.{None}
import smalto
import smalto/grammar.{Grammar}

let my_grammar = Grammar(
  name: "my-lang",
  extends: None,
  rules: [
    grammar.greedy_rule("string", "\"[^\"]*\""),
    grammar.rule("keyword", "\\b(?:let|if|else|fn|return)\\b"),
    grammar.rule("number", "\\b\\d+(?:\\.\\d+)?\\b"),
    grammar.rule("operator", "[+\\-*/=<>!]+"),
    grammar.rule("punctuation", "[{}()\\[\\];,]"),
  ],
)

let html = smalto.to_html("let x = 42", my_grammar)
```

### Rule builder functions

| Function | Description |
|----------|-------------|
| `grammar.rule(token, pattern)` | Non-greedy rule with no nesting |
| `grammar.greedy_rule(token, pattern)` | Greedy rule with no nesting |
| `grammar.rule_with_inside(token, pattern, rules)` | Rule with inline nested grammar |
| `grammar.greedy_rule_with_inside(token, pattern, rules)` | Greedy rule with inline nested grammar |
| `grammar.nested_rule(token, pattern, language)` | Rule with a language reference for cross-language nesting |

### Greedy vs non-greedy rules

Greedy rules match against the full source text before token boundaries are resolved. This prevents partial matches inside already-tokenized regions. Use greedy rules for tokens that might contain text resembling other tokens:

```gleam
// Greedy: prevents the keyword "if" inside a string from being matched as a keyword
grammar.greedy_rule("string", "\"[^\"]*\"")

// Non-greedy: fine for keywords since they're matched by word boundary
grammar.rule("keyword", "\\b(?:if|else|fn)\\b")
```

### Nested rules

Use `rule_with_inside` to recursively tokenize matched text:

```gleam
grammar.rule_with_inside("template-string", "`[^`]*`", [
  grammar.rule("interpolation", "\\$\\{[^}]+\\}"),
])
```

### Cross-language nesting

Use `nested_rule` to reference another language's grammar. This is useful for embedded languages like JavaScript inside HTML:

```gleam
grammar.nested_rule("script", "<script[^>]*>[\\s\\S]*?</script>", "javascript")
```

## Grammar inheritance

Grammars can extend other grammars. The child grammar's rules are prepended to the parent's rules, giving them higher priority:

```gleam
import gleam/option.{Some}
import smalto/grammar.{Grammar}

let typescript_grammar = Grammar(
  name: "typescript",
  extends: Some("javascript"),
  rules: [
    grammar.rule("keyword", "\\b(?:interface|type|enum|namespace|declare|abstract|implements)\\b"),
    grammar.rule("builtin", "\\b(?:string|number|boolean|void|never|any|unknown)\\b"),
  ],
)
```

When Smalto resolves this grammar, it prepends the TypeScript-specific rules before the inherited JavaScript rules. The built-in language grammars handle inheritance automatically.

## Rule order

Rules are tried in order. The first rule that matches at a given position wins. Place more specific rules before general ones:

```gleam
// Correct: triple-quoted strings before single-quoted
grammar.greedy_rule("string", "\"\"\"[\\s\\S]*?\"\"\""),
grammar.greedy_rule("string", "\"[^\"]*\""),

// Correct: specific keywords before general identifiers
grammar.rule("keyword", "\\b(?:if|else|fn)\\b"),
grammar.rule("function", "\\b[a-z_]\\w*(?=\\()"),
```
