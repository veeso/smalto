---
layout: default
title: Smalto
nav_order: 1
---

# Smalto

[![Package Version](https://img.shields.io/hexpm/v/smalto)](https://hex.pm/packages/smalto)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/smalto/)
[![conventional-commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-%23FE5196?logo=conventionalcommits&logoColor=white)](https://conventionalcommits.org)
[![target-erlang](https://img.shields.io/badge/target-erlang-b83998)](https://www.erlang.org/)

A general-purpose syntax highlighting library for Gleam, with regex-based grammars for 30 languages.

Smalto tokenizes source code using Prism.js-inspired grammars and renders the result as HTML with CSS classes, ANSI terminal colors, or structured tokens for custom rendering.

## Features

- **30 languages** — Gleam, Erlang, Elixir, JavaScript, TypeScript, Python, Rust, Go, C, C++, HTML, CSS, JSON, TOML, YAML, Bash, SQL, Java, Ruby, PHP, Swift, Kotlin, Haskell, Lua, Markdown, Dockerfile, XML, Zig, Scala, Dart
- **HTML output** — tokens wrapped in `<span class="smalto-{name}">` elements, ready for CSS theming
- **ANSI output** — terminal-colored output with configurable themes
- **Structured tokens** — access the raw token list for custom rendering pipelines
- **Custom grammars** — define your own grammars with regex patterns, greedy matching, and nested rules
- **Language inheritance** — grammars can extend other grammars (e.g., TypeScript extends JavaScript)
- **Configurable ANSI themes** — customize terminal colors per token type, or use the built-in default

## How it works

1. You pick a language grammar (e.g., `python.grammar()`)
2. Smalto tokenizes the source code into a list of `Token` values using a Prism.js-faithful engine
3. You choose an output format: HTML, ANSI, or raw tokens

## Documentation

| Guide | Description |
|-------|-------------|
| [Getting started](getting-started) | Installation, quick examples |
| [Tokens](tokens) | Token types, names, and values |
| [Grammars](grammars) | Grammar structure, rules, and custom grammars |
| [ANSI themes](ansi-themes) | Configuring terminal color themes |
| [Supported languages](supported-languages) | Full list of built-in language grammars |

## API reference

Full API documentation is available on [HexDocs](https://hexdocs.pm/smalto/).
