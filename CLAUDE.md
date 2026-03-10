# Smalto

A general-purpose syntax highlighting library for Gleam, using regex-based grammars inspired by Prism.js.

## Project Documentation

- Design spec: `.claude/plans/smalto-design.md`
- Implementation plan: `.claude/plans/smalto-plan.md`

## Architecture

### Public modules
- `src/smalto.gleam` — Public API: `to_tokens`, `to_html`, `to_ansi`
- `src/smalto/token.gleam` — `Token` type (hybrid: core variants + `Custom`)
- `src/smalto/grammar.gleam` — `Grammar`, `Rule`, `Inside` types + inheritance resolution + builder helpers
- `src/smalto/languages/*.gleam` — One module per language, each exports `grammar() -> Grammar`

### Internal modules
- `src/smalto/internal/engine.gleam` — Prism.js-faithful tokenizer engine (linked-list algorithm)
- `src/smalto/internal/renderer.gleam` — ANSI and HTML output renderers
- `src/smalto/internal/regex.gleam` — Erlang `re` FFI wrapper (byte-level position tracking)
- `src/regex_ffi.erl` — Erlang FFI for regex compile/find/slice operations

### Tools
- `tools/prism_converter/src/index.js` — Node.js script to generate Gleam grammar modules from Prism.js

## Conventions

- Each language module exports a single `grammar() -> Grammar` function
- Languages with inheritance (e.g., TypeScript extends JavaScript) resolve their parent grammar internally
- Token names in `Rule` map to `Token` variants: `"keyword"` → `Keyword`, unknown → `Custom`
- HTML output uses `hl-` prefixed CSS classes: `<span class="hl-keyword">`
- All HTML output must be escaped with `houdini`
- Snapshot tests use `birdie` — one snapshot per language

## Dependencies

- `gleam_stdlib` — standard library
- `gleam_community_ansi` — ANSI terminal colors
- `houdini` — HTML entity escaping
- `gleeunit` (dev) — unit testing
- `birdie` (dev) — snapshot testing

## Target Languages (v1)

Gleam, Erlang, Elixir, JavaScript, TypeScript, Python, Rust, Go, C, C++, HTML, CSS, JSON, TOML, YAML, Bash, SQL, Java, Ruby, PHP, Swift, Kotlin, Haskell, Lua, Markdown, Dockerfile, XML, Zig, Scala, Dart
