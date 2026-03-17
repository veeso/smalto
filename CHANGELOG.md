# Changelog

## 3.0.0

Released on 2026-03-17

### Added

- **theme_converter:** scaffold converter tool- **smalto_lustre_themes:** scaffold package- **theme_converter:** implement CSS theme parser and Gleam code generator- **smalto_lustre_themes:** generate 45 theme functions- **smalto_lustre_themes:** add Lustre HTML render example
  > Add dev/lustre_html_render.gleam that demonstrates using smalto_lustre_themes
  > to render syntax-highlighted source code to a standalone HTML file via Lustre
  > elements and element.to_document_string. Embeds the matching CSS theme for
  > base text color and background styling.- **tools:** add prism supported languages to fetcher- **languages:** generate grammar modules for new languages

### CI

- build theme_converter- smalto lustre themes workflow- gleam 1.15.0

### Documentation

- **smalto_lustre_themes:** add README- **smalto_lustre_themes:** add auto-generated notice and theme list to module docs- add smalto_lustre_themes to README and docs- update readme- CONTRIBUTING

### Fixed

- **theme_converter:** strip @media blocks, fix doc comments, add tests
  > Strip @media blocks before CSS parsing to prevent high-contrast
  > overrides (e.g. `color: highlight`) from leaking into token styles.
  > Skip asterisk separator comments in extractDescription and fall back
  > to filename-derived descriptions for themes without doc comments.
  >
  > Extract converter logic into src/converter.js for testability and add
  > 49 unit tests covering all exported functions.- restore registry, update docs and examples for new languages
  > The prism_converter tool was overwriting the registry with only the
  > languages converted in each run. Fix the tool to always include all
  > known languages in the registry. Regenerate the registry with all 36
  > languages, update language counts and tables in README, docs, and
  > smalto.gleam module doc. Add extension mappings for the 6 new languages
  > (C#, F#, Nginx, Razor, React JSX, React TSX) to dev/cat.gleam.- escape lone curly braces in JS regex compilation
  > JS unicode mode (`u` flag) requires `{` and `}` to be escaped when not
  > part of valid quantifiers, unlike PCRE which treats them as literals.
  > This caused C#/Razor grammar regexes (e.g. `with(?=\s*{)`) to silently
  > fail to compile on the JS target, dropping keyword and class-name rules.

### Miscellaneous

- smalto lustre themes v 2

### Testing

- **smalto_lustre_themes:** add theme rendering tests- **languages:** add C# syntax highlighting snapshot- **languages:** add F# syntax highlighting snapshot- **languages:** add Nginx syntax highlighting snapshot- **languages:** add React JSX syntax highlighting snapshot- **languages:** add React TSX syntax highlighting snapshot- **languages:** add Razor syntax highlighting snapshot- fixed test for prism tool

## 2.0.2

Released on 2026-03-16

### Fixed

- handle greedy match ending within a skipped TokenNode
  > walk_greedy_span did not account for match_end falling before the next
  > TextNode's byte_start (i.e. within a previously skipped TokenNode).
  > This caused a negative offset in byte_slice, triggering an Erlang
  > binary:part badarg panic.
  >
  > Add a guard to keep the TextNode intact when match_end <= node_start.

## 2.0.1

Released on 2026-03-13

### CI

- always run js tools

### Performance

- cache compiled regexes at the FFI layer
  > Regex patterns are now memoized on first compile — via persistent_term
  > on Erlang and a module-level Map on JavaScript — so repeated calls to
  > regex.compile with the same pattern skip recompilation.

## 2.0.0

Released on 2026-03-11

### Added

- add JavaScript compilation target support
  > Add JavaScript FFI for regex operations with PCRE-to-JS translation
  > layer that handles \K (match-reset via lookbehinds), inline flags
  > (?i)/(?m)/(?s), and \x{HHHH} hex escapes.
  >
  > - Add src/regex_ffi.mjs with compile, find, byte_slice, byte_length
  > - Add @external(javascript, ...) annotations to regex.gleam
  > - Remove target = "erlang" from gleam.toml to enable both targets
  > - Add JS target testing to CI workflow
  > - Strip surrogate code point ranges in prism_converter (invalid in PCRE
  >   unicode mode, redundant in UTF-8)
  > - Update README and docs to mention dual-target support

### Fixed

- add default styles for markup tokens (Markdown highlighting)
  > Markup tokens (important, bold, italic, strike, code, url) produced by the
  > Markdown grammar were unstyled across all renderers. Added default styles to
  > the ANSI theme, Lustre default config, and CSS theme fallback rules.
  > Also added punctuation styling (gray) to the ANSI and Lustre default themes.

### Documentation

- added heading comments for languages modules
- add JavaScript target badge to smalto_lustre README

### Build

- smalto_lustre manifest
