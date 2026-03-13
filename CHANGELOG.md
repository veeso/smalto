# Changelog

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
