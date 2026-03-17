# Contributing to Smalto

First off, thank you for considering contributing to Smalto! Every contribution is appreciated, whether it's a bug report, a feature request, or a pull request.

Please read and follow our [Code of Conduct](CODE_OF_CONDUCT.md) before participating.

## Reporting Issues

You can report bugs and request features on [GitHub Issues](https://github.com/veeso/smalto/issues) or on [Codeberg](https://codeberg.org/veeso/smalto/issues). Issues are typically tracked and resolved on GitHub.

When reporting a bug, please include:

- Gleam and OTP versions
- The language grammar involved
- A minimal reproducible code snippet
- Expected vs actual highlighting

## Development Setup

### Prerequisites

- [Gleam](https://gleam.run) >= 1.15.0
- [Erlang/OTP](https://www.erlang.org) >= 28
- [Rebar3](https://rebar3.org)
- [Node.js](https://nodejs.org) (only if using the Prism converter tool)

### Getting Started

```bash
# Clone the repository
git clone https://github.com/veeso/smalto.git
cd smalto

# Download dependencies
gleam deps download

# Run tests
gleam test

# Format code
gleam format src test
```

## Making Changes

### Branch Naming

Branch names must follow conventional commit prefixes, matching the type of change:

- `feat/short-description` - new features
- `fix/short-description` - bug fixes
- `refactor/short-description` - code refactoring
- `perf/short-description` - performance improvements
- `docs/short-description` - documentation changes
- `test/short-description` - test additions or fixes
- `ci/short-description` - CI/CD changes
- `chore/short-description` - maintenance tasks
- `build/short-description` - build system or dependency changes

### Commit Messages

This project uses [Conventional Commits](https://www.conventionalcommits.org/). The changelog is generated with git-cliff, so following this format is mandatory.

```txt
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

**Types:** `feat`, `fix`, `refactor`, `perf`, `docs`, `test`, `ci`, `chore`, `build`

Examples:

```txt
feat(languages): add Nginx grammar
fix(engine): handle empty lookbehind groups
refactor!: rename Grammar fields for clarity
```

A `!` after the type/scope indicates a breaking change.

### Code Style

- Follow [Gleam official conventions](https://gleam.run/writing-gleam/)
- Use qualified imports only (except for types and constructors)
- `snake_case` for functions, `PascalCase` for types
- Singular module names
- Never use `let assert` or `panic` in library code - always return `Result`
- Module docs use `////` comments; public functions and types get `///` doc comments
- Internal modules go under `smalto/internal/` and are not part of the public API

### Before Submitting

1. **Run the tests**: `gleam test`
2. **Format your code**: `gleam format src test`
3. **Check formatting**: `gleam format --check src test`

All three checks run in CI and must pass before a PR can be merged.

## Adding a New Language Grammar

Smalto ships with a [Prism.js converter tool](tools/prism_converter/) that auto-generates Gleam grammar modules from Prism.js language definitions. Most new languages should be added this way.

### Option A: Language available in Prism.js (preferred)

1. **Generate the grammar module**

   ```bash
   cd tools/prism_converter
   npm install
   node src/index.js <language>
   ```

   This creates `src/smalto/languages/<language>.gleam` and updates `src/smalto/internal/registry.gleam` automatically.

2. **Add a snapshot test** in `test/languages_test.gleam`:

   ```gleam
   pub fn <language>_highlighting_test() {
     "<representative code sample>"
     |> smalto.to_html(<language>.grammar())
     |> birdie.snap(title: "<language> highlighting")
   }
   ```

   Choose a code sample that exercises the main constructs of the language (keywords, strings, comments, functions, etc.).

3. **Add extension mappings** in `dev/cat.gleam`:

   Add the file extension(s) for the language to the `extension_map()` function.

4. **Update documentation**:

   - `src/smalto.gleam` - Update the language count in the module doc comment
   - `docs/supported-languages.md` - Update the count and add a row to the table
   - `docs/index.md` - Update the language count
   - `docs/grammars.md` - Update the language count

5. **Run tests and accept snapshots**:

   ```bash
   gleam test
   ```

   Review the generated snapshot in `birdie_snapshots/<language>_highlighting.accepted` to make sure highlighting looks correct.

### Option B: Language not in Prism.js (hand-written grammar)

If the language is not available in Prism.js (e.g., Gleam itself), you need to write the grammar manually.

1. **Create the grammar module** at `src/smalto/languages/<language>.gleam`.

   Each module exports a single `grammar() -> Grammar` function. Use the builder helpers from `smalto/grammar`:

   ```gleam
   import gleam/option
   import smalto/grammar.{type Grammar, type Rule, Grammar}

   pub fn grammar() -> Grammar {
     Grammar(name: "<language>", extends: option.None, rules: rules())
   }

   fn rules() -> List(Rule) {
     [
       grammar.greedy_rule("comment", "//.*"),
       grammar.greedy_rule("string", "\"[^\"]*\""),
       grammar.rule("keyword", "\\b(?:if|else|let|fn)\\b"),
       grammar.rule("punctuation", "[{}();,]"),
     ]
   }
   ```

   - Use `grammar.rule(token, pattern)` for non-greedy rules
   - Use `grammar.greedy_rule(token, pattern)` for greedy rules (strings, comments)
   - Use `grammar.greedy_rule_with_inside(token, pattern, inside_rules)` for rules with nested tokenization
   - If the language extends another, set `extends: option.Some("parent_language")`
   - Token names map to `Token` variants: `"keyword"` → `Keyword`, unknown names become `Custom`

2. **Register the grammar** in `src/smalto/internal/registry.gleam`:

   Add the import and a `#("<language>", <language>.grammar())` entry to the dict.

3. **Add to `MANUAL_LANGUAGES`** in `tools/prism_converter/src/index.js`:

   This ensures the language appears in the registry even when the converter regenerates all grammars.

4. **Follow steps 2–5 from Option A** (test, extension mapping, docs, accept snapshots).

### Checklist

When adding a new language, make sure all of these files are updated:

- [ ] `src/smalto/languages/<lang>.gleam` - grammar module
- [ ] `src/smalto/internal/registry.gleam` - import and dict entry
- [ ] `test/languages_test.gleam` - snapshot test
- [ ] `birdie_snapshots/<lang>_highlighting.accepted` - accepted snapshot
- [ ] `dev/cat.gleam` - extension mapping
- [ ] `dev/html_render.gleam` - extension mapping
- [ ] `smalto_lustre_themes/dev/lustre_html_render.gleam` - extension mapping
- [ ] `src/smalto.gleam` - language count in module doc
- [ ] `docs/supported-languages.md` - count and table row
- [ ] `docs/index.md` - language count
- [ ] `docs/grammars.md` - language count
- [ ] `tools/prism_converter/src/index.js` - `MANUAL_LANGUAGES` (hand-written grammars only)
- [ ] `tools/prism_converter/test/fetcher.test.js` - Increase the number of expected languages (hand-written grammars only)

## Pull Requests

1. Fork the repository and create your branch from `main`
2. Make your changes following the guidelines above
3. Open a pull request targeting the `main` branch
4. Fill in a clear description of what you changed and why

A maintainer will review your PR. At least one maintainer approval is required before merging.

## License

By contributing to Smalto, you agree that your contributions will be licensed under the [MIT License](LICENSE).
