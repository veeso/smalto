# Changelog

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

### Documentation

- added heading comments for languages modules
- add JavaScript target badge to smalto_lustre README

### Build

- smalto_lustre manifest
