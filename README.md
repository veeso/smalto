# Smalto

[![Package Version](https://img.shields.io/hexpm/v/smalto)](https://hex.pm/packages/smalto)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/smalto/)
[![conventional-commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-%23FE5196?logo=conventionalcommits&logoColor=white)](https://conventionalcommits.org)
[![target-erlang](https://img.shields.io/badge/target-erlang-b83998)](https://www.erlang.org/)
[![codeberg](https://img.shields.io/badge/Codeberg-2185D0?&logo=Codeberg&logoColor=white)](https://codeberg.org/veeso/smalto)

[![test](https://github.com/veeso/smalto/actions/workflows/test.yml/badge.svg)](https://github.com/veeso/smalto/actions/workflows/test.yml)
[![prism-converter](https://github.com/veeso/smalto/actions/workflows/prism-converter.yml/badge.svg)](https://github.com/veeso/smalto/actions/workflows/prism-converter.yml)

A general-purpose syntax highlighting library for Gleam, with regex-based grammars for 30+ languages.

Smalto tokenizes source code using regex-based grammar definitions inspired by [Prism.js](https://prismjs.com/), with output to structured tokens, ANSI terminal colors, or HTML with CSS classes.

## Features

- Regex-based tokenizer engine with greedy matching and nested grammar support
- 30 built-in languages including Gleam, Rust, Python, JavaScript, HTML, CSS, and more
- Three output formats: tokens, ANSI terminal colors, HTML with CSS classes
- Language inheritance (e.g., TypeScript extends JavaScript)
- Nested tokenization for embedded languages (e.g., CSS inside HTML)
- Hybrid token types: well-known semantic variants plus a `Custom` escape hatch

## Installation

```sh
gleam add smalto@1
```

## Quick start

```gleam
import smalto
import smalto/languages/python

pub fn main() {
  let code = "
def greet(name: str) -> str:
    \"\"\"Return a greeting.\"\"\"
    return f'Hello, {name}!'
"

  // Highlight to HTML
  let html = smalto.to_html(code, python.grammar())

  // Highlight to ANSI terminal colors
  let ansi = smalto.to_ansi(code, python.grammar())

  // Get raw tokens for custom processing
  let tokens = smalto.to_tokens(code, python.grammar())
}
```

### HTML output

The HTML renderer wraps each token in a `<span>` with a CSS class. Place the output within `<pre><code>...</code></pre>` and style the classes:

```css
pre code .smalto-keyword  { color: #ffd596; }
pre code .smalto-string   { color: #c8ffa7; }
pre code .smalto-number   { color: #c8ffa7; }
pre code .smalto-comment  { color: #d4d4d4; font-style: italic; }
pre code .smalto-function { color: #9ce7ff; }
pre code .smalto-operator { color: #ffaff3; }
pre code .smalto-type     { color: #ffddfa; }
pre code .smalto-module   { color: #ffddfa; }
pre code .smalto-tag      { color: #ff6b6b; }
pre code .smalto-attribute { color: #ffd596; }
pre code .smalto-selector { color: #9ce7ff; }
pre code .smalto-property { color: #ffd596; }
```

## Supported languages

| Language | Module | Extends |
| ---------- | -------- | --------- |
| Bash | `smalto/languages/bash` | |
| C | `smalto/languages/c` | |
| C++ | `smalto/languages/cpp` | C |
| CSS | `smalto/languages/css` | |
| Dart | `smalto/languages/dart` | |
| Dockerfile | `smalto/languages/dockerfile` | |
| Elixir | `smalto/languages/elixir` | |
| Erlang | `smalto/languages/erlang` | |
| Gleam | `smalto/languages/gleam` | |
| Go | `smalto/languages/go` | |
| Haskell | `smalto/languages/haskell` | |
| HTML | `smalto/languages/html` | |
| Java | `smalto/languages/java` | |
| JavaScript | `smalto/languages/javascript` | |
| JSON | `smalto/languages/json` | |
| Kotlin | `smalto/languages/kotlin` | |
| Lua | `smalto/languages/lua` | |
| Markdown | `smalto/languages/markdown` | |
| PHP | `smalto/languages/php` | |
| Python | `smalto/languages/python` | |
| Ruby | `smalto/languages/ruby` | |
| Rust | `smalto/languages/rust` | |
| Scala | `smalto/languages/scala` | |
| SQL | `smalto/languages/sql` | |
| Swift | `smalto/languages/swift` | |
| TOML | `smalto/languages/toml` | |
| TypeScript | `smalto/languages/typescript` | JavaScript |
| XML | `smalto/languages/xml` | |
| YAML | `smalto/languages/yaml` | |
| Zig | `smalto/languages/zig` | |

## Try it out

Smalto ships with example tools in the `dev/` directory:

```sh
# Print syntax-highlighted source to the terminal using ANSI colors
gleam run -m cat -- path/to/file.py

# Render a standalone HTML file with an embedded CSS theme
gleam run -m html_render -- path/to/file.py dracula output.html
```

The `cat` tool detects the language from the file extension and prints highlighted output to stdout. The `html_render` tool does the same but writes a self-contained HTML file using one of the 45 bundled CSS themes (see `themes/` directory).

## Documentation

API reference is available on [HexDocs](https://hexdocs.pm/smalto/).

## Development

```sh
gleam build   # Compile the project
gleam test    # Run the tests
gleam format src test  # Format code
```

### Prism.js converter

Language grammars are generated from [Prism.js](https://prismjs.com/) definitions using a Node.js converter tool:

```sh
cd tools/prism_converter
npm install
node convert.js python rust javascript  # Convert specific languages
node convert.js --all                    # Convert all target languages
```

## License

Smalto is licensed under the MIT License. See [LICENSE](LICENSE) for details.
