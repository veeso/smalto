---
layout: default
title: Supported languages
nav_order: 6
---

# Supported languages

Smalto ships with grammars for 30 languages. Each language module exports a `grammar()` function.

## Language list

| Language | Module | Extends |
|----------|--------|---------|
| Bash | `smalto/languages/bash` | |
| C | `smalto/languages/c` | clike |
| C++ | `smalto/languages/cpp` | C |
| CSS | `smalto/languages/css` | |
| Dart | `smalto/languages/dart` | clike |
| Dockerfile | `smalto/languages/dockerfile` | |
| Elixir | `smalto/languages/elixir` | |
| Erlang | `smalto/languages/erlang` | |
| Gleam | `smalto/languages/gleam` | |
| Go | `smalto/languages/go` | clike |
| Haskell | `smalto/languages/haskell` | |
| HTML | `smalto/languages/html` | |
| Java | `smalto/languages/java` | clike |
| JavaScript | `smalto/languages/javascript` | clike |
| JSON | `smalto/languages/json` | |
| Kotlin | `smalto/languages/kotlin` | clike |
| Lua | `smalto/languages/lua` | |
| Markdown | `smalto/languages/markdown` | |
| PHP | `smalto/languages/php` | clike |
| Python | `smalto/languages/python` | |
| Ruby | `smalto/languages/ruby` | clike |
| Rust | `smalto/languages/rust` | |
| Scala | `smalto/languages/scala` | Java |
| SQL | `smalto/languages/sql` | |
| Swift | `smalto/languages/swift` | clike |
| TOML | `smalto/languages/toml` | |
| TypeScript | `smalto/languages/typescript` | JavaScript |
| XML | `smalto/languages/xml` | |
| YAML | `smalto/languages/yaml` | |
| Zig | `smalto/languages/zig` | |

## Usage

Import the language module and call `grammar()`:

```gleam
import smalto
import smalto/languages/rust

let html = smalto.to_html("fn main() {}", rust.grammar())
```

## Inheritance

Some grammars extend a parent language. For example, TypeScript extends JavaScript, and C++ extends C. The child grammar's rules are prepended to the parent's, giving them higher match priority. Inheritance is resolved automatically when you call `grammar()`.

## Adding language support

To highlight a language not in the list, define a custom `Grammar`. See [Grammars](grammars) for details on building custom grammars.
