# Prism Converter

A Node.js tool that generates Gleam grammar modules for [Smalto](../../) from [Prism.js](https://prismjs.com/) language definitions.

## Requirements

- Node.js 20+
- npm

## Setup

```sh
npm install
```

## Usage

Convert specific languages:

```sh
node src/index.js python rust javascript
```

Convert all 35 supported Prism.js languages (Gleam is hand-written):

```sh
node src/index.js --all
```

### Options

| Flag           | Short | Default                                    | Description                                        |
| -------------- | ----- | ------------------------------------------ | -------------------------------------------------- |
| `--all`        | `-a`  | `false`                                    | Convert all supported languages                    |
| `--output-dir` | `-o`  | `../../src/smalto/languages/`              | Output directory for `.gleam` files                |
| `--registry`   | `-r`  | `../../src/smalto/internal/registry.gleam` | Registry file path                                 |
| `--log-level`  | `-l`  | `info`                                     | Log level (trace, debug, info, warn, error, fatal) |

### Output

The tool generates:

- One `.gleam` file per language in the output directory (e.g., `python.gleam`, `rust.gleam`)
- A `registry.gleam` file that maps language names to their `Grammar` definitions

## Architecture

| Module                   | Description                                                            |
| ------------------------ | ---------------------------------------------------------------------- |
| `src/fetcher.js`         | Loads Prism.js grammars via `require`, handles dependency ordering     |
| `src/parser.js`          | Normalizes Prism grammar objects into an intermediate representation   |
| `src/renderer.js`        | Generates Gleam source code from the IR using smalto builder functions |
| `src/registry_writer.js` | Generates the `registry.gleam` module                                  |
| `src/index.js`           | CLI entry point that orchestrates the pipeline                         |

### Pipeline

```
CLI args -> fetcher (load Prism.js) -> parser (normalize to IR) -> renderer (Gleam source) -> write files
                                                                -> registry_writer (registry.gleam)
```

### Key behaviors

- **Regex conversion**: JS regex flags are converted to PCRE inline flags (`/i` -> `(?i)`, `/m` -> `(?m)`, `/s` -> `(?s)`)
- **Lookbehind**: Prism's `lookbehind: true` patterns are converted to PCRE `(?<=...)` lookbehinds
- **Aliases**: When a Prism rule has an `alias`, it is used as the token name
- **Inside/rest**: Inline `inside` grammars become `InlineGrammar`, `rest` self-references become `LanguageRef`
- **Extends**: Known inheritance relationships (e.g., TypeScript extends JavaScript) are hardcoded for reliability
- **Cycle detection**: Circular grammar references in Prism objects are detected and skipped

## Supported languages

Bash, C, C++, C#, CSS, Dart, Dockerfile, Elixir, Erlang, F#, Go, Haskell, HTML, Java, JavaScript, JSON, Kotlin, Lua, Markdown, Nginx, PHP, Python, Razor (cshtml), React JSX, React TSX, Ruby, Rust, Scala, SQL, Swift, TOML, TypeScript, XML, YAML, Zig

Gleam is not available in Prism.js and must be handled separately.

## Tests

```sh
npm test
```

Runs unit tests for all modules (fetcher, parser, renderer, registry writer) and CLI integration tests.
